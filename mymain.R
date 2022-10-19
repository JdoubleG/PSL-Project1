#================================================================
# CS598 Practical Statistical Learning - Project 1
#
# Given housing data from Ames, Iowa, Predict sale price of future 
# home sales using linear regression and tree based methods.
#
# This file is for development purposes.
#
# Authors:  Matthew Lind, James Garijo-Garde
# Date: October 17, 2022
#================================================================

outFileNameLinear = "mysubmission1.txt"
outFileNameTree   = "mysubmission2.txt"

#--------------------------
# read data from file
#--------------------------
qValues = c(
  0.95,
  0.95,
  0.95,
  0.95,
  0.95,
  0.95,
  0.95,
  0.95
)

varNamesWinsor = c(
  "First_Flr_SF",
  "Garage_Area",
  "Gr_Liv_Area",
  "Lot_Area",
  "Lot_Frontage",
  "Open_Porch_SF",
  "Total_Bsmt_SF",
  "Wood_Deck_SF"
)

varNamesDrop = c( 
  "PID",
  "Sale_Price",
  
  "Condition_2", 
  "Heating", 
  "Latitude", 
  "Longitude",
  "Low_Qual_Fin_SF",
  "Misc_Feature", 
  "Pool_Area", 
  "Pool_QC", 
  "Roof_Matl", 
  "Street", 
  "Utilities",
  
  # categorical variables dominated by one level:
  "Mas_Vnr_Type",
  "Lot_Config",
  "Roof_Style",
  "Pool_Area",
  "Mo_Sold",
  "Year_Sold",
  
  # suggested by corrplot( var vs. Sale_Price ):
  "BsmtFin_SF_1",   # (negative correlation)
  "Enclosed_Porch", # (negative correlation)
  "Kitchen_AbvGr",  # (negative correlation)
  "Misc_Val",       # (zero correlation)
  "BmstFin_SF_2"    # (zero correlation)
)

#====================================================
# remove_variables() - returns a copy of the input data frame
#                      without the columns specified by varNames.
#
# df: data frame
# varNames: variables to drop
#
# returns: (data frame) copy of input data frame minus columns of dropped variables
#====================================================
remove_variables <- function( df, varNames ) {
  
  varIndices = c()
  colNames   = colnames( df )
  
  for ( varName in varNames ) {
    varIndices = c( varIndices, which( colNames == varName ) )
  }
  return( subset( df, select= -varIndices ) )
}

#====================================================
# to_one_hot() - returns a copy of the input data frame with the columns
#                associated with categorical variables replaced with
#                one-hot encoded binary variables representing the levels.
#
# df: data frame
#
# returns: (data frame) copy of input data frame minus columns of dropped variables
#====================================================
to_one_hot <- function( df ) {
  
  # get column names of the categorical variables in the data frame
  categorical.vars <- colnames( df )[ which( sapply( df, function(x) mode(x)=="character") ) ]
  
  # extract all columns except the categorical variables
  # this will be the base matrix (data frame)
  train.matrix <- df[ , !colnames( df ) %in% categorical.vars, drop=FALSE ]
  n.train      <- nrow( train.matrix )
  
  for ( var in categorical.vars ) {
    
    # get levels associated with this variable
    mylevels  <- sort( unique( df[, var] ) )
    
    # create (K - 1) levels when K > 2
    k <- length( mylevels )
    k <- ifelse( k > 2, k, 1 )
    
    # create empty matrix to store one-hot encoded levels for this variable
    tmp.train <- matrix( 0, n.train, k )
    
    # populate matrix with one-hot encodings
    col.names <- NULL
    
    for ( j in 1:k ) {
      # set value to 1 where variable value == current level
      tmp.train[ df[, var] == mylevels[j], j ] <- 1
      
      # append the one-hot encoded level to the tmp matrix
      col.names <- c( col.names, paste( var, '_', mylevels[j], sep='') )
    }
    
    # label the one-hot encoding columns, then append to design matrix
    colnames( tmp.train ) <- col.names
    train.matrix          <- cbind( train.matrix, tmp.train )
  }
  
  return( train.matrix )
}


#===================================================
# apply_winsor() - applies winsor method (clamping) to specified variables
#                  at the specified quantiles.
#
#     data: data frame to modify
#   qValue: quantile to clamp data
# varNames: vector of variables (columns) to process in the data frame
#
# returns: (data frame) copy of input data frame with winsor applied
#===================================================
apply_winsor <- function( data, qValues, varNames ) {
  df = data
  i = 1
  for ( varName in varNames ) {
    col                  <- df[, varName]
    threshold            <- quantile( col, probs = qValues[i], na.rm = TRUE )
    col[col > threshold] <- threshold
    df[, varName]        <- col
    i = i + 1
  }
  return( df )
}

#===================================================
# data_transform() - apply transformations to the data in the input data frame.
#
# df: input data frame
#
# returns: (data frame) copy of input data frame
#===================================================
data_transform <- function( df, qValues, varNamesWinsor ) {
  
  # replace missing values
  df[,"Garage_Yr_Blt"][ is.na( df[,"Garage_Yr_Blt"] ) ] = 0
  
  # apply winsor to variables with significant outliers
  df_winsor = apply_winsor( df, qValues, varNamesWinsor )
  
  return( df_winsor )
}

#=========================================
# data_conform() - conforms df_target to have same column count and order as df_source.
#                  columns of df_source not found in df_target are replaced with zeros.
#                  columns of df_target not found in df_source are dropped.
#                  columns of df_target are copied to output only when same columns exists in df_source
#
# returns: data frame shaped to df_source cols x df_target rows containing data of df_target.
#=========================================
data_conform <- function( df_source, df_target ) {
  
  nb_rows = nrow( df_target )
  nb_cols = ncol( df_source )
  m = NULL

  colNamesSource = colnames( df_source )
  colNamesTarget = colnames( df_target )
  
  for ( varName in colNamesSource ) {
    if ( varName %in% colNamesTarget ) {
      m = cbind( m, df_target[, varName] )     
    } else {
      m = cbind( m, rep( 0, nb_rows ) )
    }
  }
  colnames(m) <- colnames( df_source )
  
  return( m )
}

#=============================================
# dump_results() - output results to file
#
#=============================================
dump_results <- function( fileName, pid, predictions ) {
  results = cbind( pid, exp( predictions ) )
  colnames( results ) <- c( "PID", "Sale_Price" ) 
  write.csv( results, fileName, row.names=FALSE )
}

#=============================================
# train/test
#
#=============================================
cv_alpha      = 0.5
resultsTree   = NULL
resultsLinear = NULL
  
  #-----------------------------
  # Train
  #-----------------------------
  # read train data
  train <- read.csv( "train.csv" )
  
  # store log( Sale_Price ) for later
  train.y = log( train[ , "Sale_Price"] )
  Ymean   = mean( train.y )
  
  # Remove unwanted variables
  train.x  = remove_variables( train, varNamesDrop )
  colNames = colnames( train.x )
  
  # fix errors, apply winsor, ...
  train.x = data_transform( train.x, qValues, varNamesWinsor )
  
  # convert categorical variables to one-hot encoding
  train.matrix = to_one_hot( train.x )
  
  # remove the col mean, standardize
  Xmean        = colMeans( train.matrix )
  train.matrix = t( t(train.matrix) - Xmean )
  
  # set seed for reproducibility
  set.seed( 12345 )
  
  # fit the linear regression model
  cv.out <- cv.glmnet( as.matrix( train.matrix ), train.y, alpha = cv_alpha )
  
  # fit the tree model
  xgb.model <- xgboost(
    data      = as.matrix( train.matrix ),
    label     = train.y,
    max_depth = 6,
    eta       = 0.05,
    nrounds   = 5000,
    subsample = 0.5,
    verbose   = FALSE
  )
  
  #-----------------------
  # Test
  #-----------------------
  
  # load test split
  test <- read.csv( "test.csv" )
  pid = test[,"PID"]
  
  # remove variables
  test.x = remove_variables( test, varNamesDrop )
  
  # fix errors
  test.x = data_transform( test.x, qValues, varNamesWinsor )
  
  # convert to one-hot encoding
  test.matrix = to_one_hot( test.x )
  
  # test[ colnames(train) ]
  # conform test matrix to train matrix
  test.matrix = data_conform( train.matrix, test.matrix )
  
  # center (remove the 'train' mean)
  test.matrix = t( t( test.matrix ) - Xmean )
  
  # predict
  predLinear <- predict( cv.out, s = cv.out$lambda.min, newx = as.matrix( test.matrix ) )
  predTree   <- predict( xgb.model, as.matrix( test.matrix ) )
  
  # output predictions to file
  dump_results( outFileNameLinear, pid, predLinear )
  dump_results( outFileNameTree,   pid, predTree   )
