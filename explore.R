library( ggplot2 )
library( caret )
library( tidyverse )

# read data from file
data    <- read.csv(   "Ames_data.csv"        )
testIDs <- read.table( "project1_testIDs.dat" )

vNames = names( data )
sort( names( data ))
# head( data )

#cols = data[ c( "joe", "Alley") ]
# dim( cols )


#============================================================
# plot_category() - plot categorical variable vs. continuous variable
#
# plot_type: type of plot to perform (1=scatter, 2=histogram 3=density, 4=bar, 5=box )
#         d: data frame
#  cat_name: categorical variable name
#    y_name: response variable
#============================================================
plot_category <- function( plot_type, d, cat_name, y_name ) {
  
  dd <- subset( d, select = c( y_name, cat_name ) )
  
  if ( plot_type == 1 ) {
    
    # scatter plot
    ggplot( dd ) +
      geom_point( aes( x=d[[cat_name]], y=d[[y_name]], color=d[[cat_name]]), size=2 ) +
      labs( x=cat_name, y="Sale Price", color=cat_name )
    
  } else if ( plot_type == 2 ) {
    
    # histogram
    ggplot( dd ) +
      geom_histogram( bins=100, aes( x=d[[y_name]], fill=d[[cat_name]] ), color = 'lightblue' ) +
      labs( x = y_name )
    
  } else if ( plot_type == 3 ) {
    
    # density plot
    ggplot( dd ) +
      geom_density( aes( x = d[[y_name]], fill = d[[cat_name]], alpha=0.35 ) ) +
      labs( x = y_name, color=dd[[cat_name]] )
    
  } else if ( plot_type == 4 ) { 
    
    # bar plot
    ggplot( dd ) +
      geom_bar( aes( x = d[[cat_name]], fill = d[[cat_name]], alpha=0.35 ) ) +
      labs( x = cat_name )
    
  } else if ( plot_type == 5 ) {
    
    # box plot
    ggplot( dd ) +
      geom_boxplot( aes( x = d[[cat_name]], y = d[[y_name]], fill = d[[cat_name]] )) + 
      labs( x = cat_name, y = y_name )
  }
}

#============================================================
# to_ordinal() - convert categorical variable levels to ordinal
#                by applying a numeric prefix to each level value.
#                intended for use with plotting as the plotter
#                processes level values in alphabetic order.
#
#       df: data frame
#  varName: variable name (column name)
# lvlNames: vector of levels associated with the variable
#
# returns: (data frame) data frame of modified variable
#============================================================
to_ordinal <- function( df, varName, lvlNames ) {
  df2 = df
  n = length( lvlNames )
  for ( i in 1:n ) {
    levelName = lvlNames[i]
    str = NULL
    str = paste( str, i-1, "_", levelName, sep="" )
    df2[varName][ df2[varName] == levelName ] <- str
  }
  return( df2 )
}

# Example of Ad hoc conversion to ordinal in case we need it again
# df = to_ordinal( df, "BsmtFin_Type_1", c( "No_Basement", "Unf", "LwQ", "Rec", "BLQ", "ALQ", "GLQ" ))


# pairs( ~ Sale_Price + Bedroom_AbvGr, data=data )
# pairs( ~ Sale_Price + BsmtFin_SF_1 + BsmtFin_SF_2 + Bsmt_Full_Bath + Bsmt_Half_Bath + Bsmt_Unf_SF, data=data )
# pairs( ~ Sale_Price + Enclosed_Porch, data=data )
# pairs( ~ Sale_Price + Fireplaces + First_Flr_SF + Full_Bath, data=data )
# pairs( ~ Sale_Price + Garage_Area + Garage_Cars + Garage_Yr_Blt + Gr_Liv_Area, data=data )
# pairs( ~ Sale_Price + Half_Bath + Kitchen_AbvGr, data=data )
# pairs( ~ Sale_Price + Lot_Frontage + Low_Qual_Fin_SF + Lot_Area, data=data )
# pairs( ~ Sale_Price + Mas_Vnr_Area + Misc_Val + Mo_Sold + Pool_Area, data=data )
# pairs( ~ Sale_Price + Open_Porch_SF + Screen_Porch + Second_Flr_SF + Three_season_porch, data=data )
# pairs( ~ Sale_Price + TotRms_AbvGrd + Total_Bsmt_SF + Wood_Deck_SF, data=data )
# pairs( ~ Sale_Price + Year_Built + Year_Remod_Add + Year_Sold, data=data )



#===============================================
# continuous variables
#===============================================
plot_type = 1
plot_category( plot_type, data, "BsmtFin_SF_1",       "Sale_Price" )  #
plot_category( plot_type, data, "BsmtFin_SF_2",       "Sale_Price" )
plot_category( plot_type, data, "Bsmt_Unf_SF",        "Sale_Price" )
plot_category( plot_type, data, "Enclosed_Porch",     "Sale_Price" )
plot_category( plot_type, data, "First_Flr_SF",       "Sale_Price" )
plot_category( plot_type, data, "Garage_Area",        "Sale_Price" )
plot_category( plot_type, data, "Gr_Liv_Area",        "Sale_Price" )
plot_category( plot_type, data, "Lot_Area",           "Sale_Price" )
plot_category( plot_type, data, "Lot_Frontage",       "Sale_Price" )
plot_category( plot_type, data, "Low_Qual_Fin_SF",    "Sale_Price" )  #
plot_category( plot_type, data, "Mas_Vnr_Area",       "Sale_Price" )
plot_category( plot_type, data, "Misc_Val",           "Sale_Price" )  #
plot_category( plot_type, data, "Open_Porch_SF",      "Sale_Price" )
plot_category( plot_type, data, "Pool_Area",          "Sale_Price" )  #
plot_category( plot_type, data, "Total_Bsmt_SF",      "Sale_Price" )
plot_category( plot_type, data, "Screen_Porch",       "Sale_Price" )
plot_category( plot_type, data, "Second_Flr_SF",      "Sale_Price" )
plot_category( plot_type, data, "Three_season_porch", "Sale_Price" )  #
plot_category( plot_type, data, "Wood_Deck_SF",       "Sale_Price" )


#===============================================
# continuous variables - discrete
#===============================================
plot_type = 1
plot_category( plot_type, data, "Bedroom_AbvGr",  "Sale_Price" )
plot_category( plot_type, data, "Bsmt_Full_Bath", "Sale_Price" )
plot_category( plot_type, data, "Bsmt_Half_Bath", "Sale_Price" )
plot_category( plot_type, data, "Fireplaces",     "Sale_Price" )
plot_category( plot_type, data, "Full_Bath",      "Sale_Price" )
plot_category( plot_type, data, "Garage_Cars",    "Sale_Price" )
plot_category( plot_type, data, "Garage_Yr_Blt",  "Sale_Price" )
plot_category( plot_type, data, "Half_Bath",      "Sale_Price" )  #
plot_category( plot_type, data, "Kitchen_AbvGr",  "Sale_Price" )  #
plot_category( plot_type, data, "Mo_Sold",        "Sale_Price" )  #
plot_category( plot_type, data, "TotRms_AbvGrd",  "Sale_Price" )
plot_category( plot_type, data, "Year_Built",     "Sale_Price" )
plot_category( plot_type, data, "Year_Remod_Add", "Sale_Price" )
plot_category( plot_type, data, "Year_Sold",      "Sale_Price" )  #


# categorical variables
#data2 <- subset( data, select = c( "Sale_Price", "Alley", "Street" ) )
#ggplot( data2 ) + geom_point( aes( x=Alley, y=Sale_Price, color=Alley), size=2 ) + labs( x="Alley", y="Sale Price")

#===============================================
# categorical variables - ordinal (ordered)
#===============================================
plot_type = 5
df = data

# basement finished rating 1
df$BsmtFin_Type_1 <- factor(df$BsmtFin_Type_1, order=TRUE,
  levels=c( "No_Basement", "Unf", "LwQ", "Rec", "BLQ", "ALQ", "GLQ" ))
plot_category( plot_type, df, "BsmtFin_Type_1", "Sale_Price" )

# basement finished rating 2
df$BsmtFin_Type_2 <- factor(df$BsmtFin_Type_2, order=TRUE,
  levels=c( "No_Basement", "Unf", "LwQ", "Rec", "BLQ", "ALQ", "GLQ" ))
plot_category( plot_type, df, "BsmtFin_Type_2", "Sale_Price" )

# basement condition
df$Bsmt_Cond <- factor(df$Bsmt_Cond, order=TRUE,
  levels=c( "No_Basement", "Poor", "Fair", "Typical", "Good", "Excellent" ))
plot_category( plot_type, df, "Bsmt_Cond", "Sale_Price" )

# basement exposure
df$Bsmt_Exposure <- factor(df$Bsmt_Exposure, order=TRUE,
  levels=c( "No_Basement", "No", "Mn", "Av", "Gd" ))
plot_category( plot_type, df, "Bsmt_Exposure", "Sale_Price" )

# Bsmt_Qual (height of basement)
df$Bsmt_Qual <- factor(df$Bsmt_Qual, order=TRUE,
  levels=c( "No_Basement", "Poor", "Fair", "Typical", "Good", "Excellent" ))
plot_category( plot_type, df, "Bsmt_Qual", "Sale_Price" )

# Central_Air
df$Central_Air <- factor(df$Central_Air, order=TRUE, levels=c( "N", "Y" ))
plot_category( plot_type, df, "Central_Air", "Sale_Price" )

# Electrical
df$Electrical <- factor(df$Electrical, order=TRUE,
  levels=c( "Mix", "FuseP", "FuseF", "FuseA", "SBrkr","Unknown" ))
plot_category( plot_type, df, "Electrical", "Sale_Price" )

# Exterior Quality
df$Exter_Qual <- factor(df$Exter_Qual, order=TRUE,
  levels=c( "Poor", "Fair", "Typical", "Good", "Excellent" ))
plot_category( plot_type, df, "Exter_Qual", "Sale_Price" )

# Exterior Condition
df$Exter_Cond <- factor(df$Exter_Cond, order=TRUE,
  levels=c( "Poor", "Fair", "Typical", "Good", "Excellent" ))
plot_category( plot_type, df, "Exter_Cond", "Sale_Price" )

# Fence
df$Fence <- factor(df$Fence, order=TRUE,
  levels=c( "No_Fence", "Minimum_Wood_Wire", "Good_Wood", "Minimum_Privacy", "Good_Privacy" ))
plot_category( plot_type, df, "Fence", "Sale_Price" )

# Fireplace QU
df$Fireplace_Qu <- factor(df$Fireplace_Qu, order=TRUE,
  levels=c( "No_Fireplace", "Poor", "Fair", "Typical", "Good", "Excellent" ))
plot_category( plot_type, df, "Fireplace_Qu", "Sale_Price" )

# Functional
df$Functional <- factor(df$Functional, order=TRUE,
  levels=c( "Sal", "Sev", "Maj2", "Maj1", "Mod", "Min2", "Min1", "Typ" ))
plot_category( plot_type, df, "Functional", "Sale_Price" )

# Garage Condition
df$Garage_Cond <- factor(df$Garage_Cond, order=TRUE,
  levels=c( "No_Garage", "Poor", "Fair", "Typical", "Good", "Excellent" ))
plot_category( plot_type, df, "Garage_Cond", "Sale_Price" )

# Garage Finish
df$Garage_Finish <- factor(df$Garage_Finish, order=TRUE,
  levels=c( "No_Garage", "Unf", "RFn", "Fin" ))
plot_category( plot_type, df, "Garage_Finish", "Sale_Price" )

# Garage Quality
df$Garage_Qual <- factor(df$Garage_Qual, order=TRUE,
  levels=c( "No_Garage", "Poor", "Fair", "Typical", "Good", "Excellent" ))
plot_category( plot_type, df, "Garage_Qual", "Sale_Price" )

# Heating QC
df$Heating_QC <- factor(df$Heating_QC, order=TRUE,
  levels=c( "Poor", "Fair", "Typical", "Good", "Excellent" ))
plot_category( plot_type, df, "Heating_QC", "Sale_Price" )

# Kitchen Quality
df$Kitchen_Qual <- factor(df$Kitchen_Qual, order=TRUE,
  levels=c( "Poor", "Fair", "Typical", "Good", "Excellent" ))
plot_category( plot_type, df, "Kitchen_Qual", "Sale_Price" )

# Land Slope
df$Land_Slope <- factor(df$Land_Slope, order=TRUE, levels=c( "Gtl", "Mod", "Sev" ))
plot_category( plot_type, df, "Land_Slope", "Sale_Price" )

# Lot Shape
df$Lot_Shape <- factor(df$Lot_Shape, order=TRUE,
  levels=c( "Irregular", "Moderately_Irregular", "Slightly_Irregular", "Regular" ))
plot_category( plot_type, df, "Lot_Shape", "Sale_Price" )

# Overall Condition
df$Overall_Cond <- factor(df$Overall_Cond, order=TRUE,
  levels=c( "Very_Poor", "Poor", "Fair", "Below_Average", "Average", "Above_Average", "Good", "Very_Good", "Excellent", "Very_Excellent" ))
plot_category( plot_type, df, "Overall_Cond", "Sale_Price" )

# Overall Quality
df$Overall_Qual <- factor(df$Overall_Qual, order=TRUE,
  levels=c( "Very_Poor", "Poor", "Fair", "Below_Average", "Average", "Above_Average", "Good", "Very_Good", "Excellent", "Very_Excellent" ))
plot_category( plot_type, df, "Overall_Qual", "Sale_Price" )

# Paved Drive
df$Paved_Drive <- factor(df$Paved_Drive, order=TRUE,
  levels=c( "Dirt_Gravel", "Partial_Pavement", "Paved" ))
plot_category( plot_type, df, "Paved_Drive", "Sale_Price" )

# Pool Quality
df$Pool_QC <- factor(df$Pool_QC, order=TRUE,
  levels=c( "No_Pool", "Poor", "Fair", "Typical", "Good", "Excellent" ))
plot_category( plot_type, df, "Pool_QC", "Sale_Price" )

# Utilities
df$Utilities <- factor(df$Utilities, order=TRUE,
  levels=c( "ELO", "NoSeWa", "NoSewr", "AllPub" ))
plot_category( plot_type, df, "Utilities", "Sale_Price" )


#===============================================
# categorical variables - nominal (unordered / unrelated)
#===============================================
plot_type = 1
plot_category( plot_type, data, "Alley", "Sale_Price" )
plot_category( plot_type, data, "Bldg_Type", "Sale_Price" )
plot_category( plot_type, data, "Central_Air", "Sale_Price" )
plot_category( plot_type, data, "Condition_1", "Sale_Price" )
plot_category( plot_type, data, "Condition_2", "Sale_Price" )
plot_category( plot_type, data, "Exterior_1st", "Sale_Price" )
plot_category( plot_type, data, "Exterior_2nd", "Sale_Price" )
plot_category( plot_type, data, "Foundation", "Sale_Price" )
plot_category( plot_type, data, "Garage_Type", "Sale_Price" )
plot_category( plot_type, data, "Heating", "Sale_Price" )
plot_category( plot_type, data, "House_Style", "Sale_Price" )
plot_category( plot_type, data, "Land_Contour", "Sale_Price" )
#plot_category( plot_type, data, "Lot_Config", "Sale_Price" )
#plot_category( plot_type, data, "Mas_Vnr_Type", "Sale_Price" )
#plot_category( plot_type, data, "Misc_Feature", "Sale_Price" )
plot_category( plot_type, data, "MS_SubClass", "Sale_Price" )
plot_category( plot_type, data, "MS_Zoning", "Sale_Price" )
plot_category( plot_type, data, "Neighborhood", "Sale_Price" )
#plot_category( plot_type, data, "Roof_Matl", "Sale_Price" )
#plot_category( plot_type, data, "Roof_Style", "Sale_Price" )
plot_category( plot_type, data, "Sale_Condition", "Sale_Price" )
plot_category( plot_type, data, "Sale_Type", "Sale_Price" )
#plot_category( plot_type, data, "Street", "Sale_Price" )


# numeric
plot_category( plot_type, data, "Longitude", "Sale_Price" )
plot_category( plot_type, data, "Latitude", "Sale_Price" )
# plot_category( plot_type, data, "Longitude", "Latitude" )




#--------------------------------------------------
# correlation plot (only supported for numeric variables)
#--------------------------------------------------
varNames   = names( data )
n          = ncol( data )
str        = NULL
colIndices = c() 

for ( i in 1:n ) {
  if ( class( data[,i] ) == "integer" ) {
    colIndices = c( colIndices, i )
    cat( str, i, varNames[i], "\n" )
  }
}
print( colIndices )
sort( varNames[ colIndices ] )

####
library( corrplot )

correlations <- cor( data[ , colIndices ], use="everything" )
corrplot( correlations, method="circle", type="lower",  sig.level = 0.01, insig = "blank", tl.cex=0.65 )

# highest correlations with sale_price:
Gr_Liv_Area
Total_Bsmt_SF
First_Flr_SF
Garage_Cars
Garage_Area
Year_built
Year_Remod_Add
Mas_Vnr_Area
Full_Bath
TotRms_AbvGrd
Fireplaces

# strongly correlated variables:
Garage_Cars + Garage_Area   # very strong
Gr_Liv_Area + TotalRms_AbvGrd

plot_category( plot_type, data, "Garage_Cars", "Garage_Area" )
plot_category( plot_type, data, "Gr_Liv_Area", "TotRms_AbvGrd" )