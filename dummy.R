### 
# example how to convert categorical variables to one-hot encoding
# using the dummyVars() function
#
# NOTE: There are other ways to do it.
######

# convert the specified columns in the data frame to one-hot encoding
# returns: (data frame) encoded variables
data_convert_ohe <- function( df, formula ) {
  
  # convert specified variables to one-hot encoding
  dv <- dummyVars( formula, data=df )
  
  # extract results
  df_encoded <- predict( dv, newdata=df )
  
  return( df_encoded )
}

# build a string of variable names to use as 'formula' argument of dummyVars()
# returns: (string) dummyVars() formula.
get_formula <- function( varNames ) {
  
  n = length( varNames )  
  formula = "~"

  for ( i in 1:n ) {
    if ( i > 1 ) {
      formula = paste( formula, " + ", varNames[i] )
    } else {
      formula = paste( formula, " ", varNames[i] )
    }
  }
  return( formula )
}


# read data from file
data    <- read.csv(   "Ames_data.csv"        )
testIDs <- read.table( "project1_testIDs.dat" )

# 1st ohe
f  = get_formula( c("Alley", "Street") )
df = data_convert_ohe( data, f )
dim( df )
head( df )

# 2nd ohe
f2  = get_formula( c( "BsmtFin_Type_1", "BsmtFin_Type_2" ) )
df2 = data_convert_ohe( data, f2 )
dim( df2 )
head( df2 )

# merge data frames
df_result = cbind( df, df2 )

# display results
head( df_result )
