library( ggplot2 )
library( caret )
library( tidyverse )

# read data from file
data    <- read.csv(   "Ames_data.csv"        )
testIDs <- read.table( "project1_testIDs.dat" )

#
vNames = names( data )
# head( data )

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



# continuous variables
pairs( ~ Sale_Price + Bedroom_AbvGr, data=data )
pairs( ~ Sale_Price + BsmtFin_SF_1 + BsmtFin_SF_2 + Bsmt_Full_Bath + Bsmt_Half_Bath + Bsmt_Unf_SF, data=data )
pairs( ~ Sale_Price + Enclosed_Porch, data=data )
pairs( ~ Sale_Price + Fireplaces + First_Flr_SF + Full_Bath, data=data )
pairs( ~ Sale_Price + Garage_Area + Garage_Cars + Garage_Yr_Blt + Gr_Liv_Area, data=data )
pairs( ~ Sale_Price + Half_Bath + Kitchen_AbvGr, data=data )
pairs( ~ Sale_Price + Lot_Frontage + Low_Qual_Fin_SF + Lot_Area, data=data )
pairs( ~ Sale_Price + Mas_Vnr_Area + Misc_Val + Mo_Sold + Pool_Area, data=data )
pairs( ~ Sale_Price + Open_Porch_SF + Screen_Porch + Second_Flr_SF + Three_season_porch, data=data )
pairs( ~ Sale_Price + TotRms_AbvGrd + Total_Bsmt_SF + Wood_Deck_SF, data=data )
pairs( ~ Sale_Price + Year_Built + Year_Remod_Add + Year_Sold, data=data )

# categorical variables
plot_type = 5

plot_category( plot_type, data, "Alley", "Sale_Price" )
plot_category( plot_type, data, "Bldg_Type", "Sale_Price" )
plot_category( plot_type, data, "BsmtFin_Type_1", "Sale_Price" )
plot_category( plot_type, data, "BsmtFin_Type_2", "Sale_Price" )
plot_category( plot_type, data, "Bsmt_Cond", "Sale_Price" )
plot_category( plot_type, data, "Bsmt_Exposure", "Sale_Price" )
plot_category( plot_type, data, "Bsmt_Qual", "Sale_Price" )
plot_category( plot_type, data, "Central_Air", "Sale_Price" )
plot_category( plot_type, data, "Condition_1", "Sale_Price" )
plot_category( plot_type, data, "Condition_2", "Sale_Price" )
plot_category( plot_type, data, "Electrical", "Sale_Price" )
plot_category( plot_type, data, "Exter_Cond", "Sale_Price" )
plot_category( plot_type, data, "Exter_Qual", "Sale_Price" )
plot_category( plot_type, data, "Exterior_1st", "Sale_Price" )
plot_category( plot_type, data, "Exterior_2nd", "Sale_Price" )
plot_category( plot_type, data, "Fence", "Sale_Price" )
plot_category( plot_type, data, "Fireplace_Qu", "Sale_Price" )
plot_category( plot_type, data, "Foundation", "Sale_Price" )
plot_category( plot_type, data, "Functional", "Sale_Price" )
plot_category( plot_type, data, "Garage_Cond", "Sale_Price" )
plot_category( plot_type, data, "Garage_Finish", "Sale_Price" )
plot_category( plot_type, data, "Garage_Type", "Sale_Price" )
plot_category( plot_type, data, "Garage_Qual", "Sale_Price" )
plot_category( plot_type, data, "Heating", "Sale_Price" )
#plot_category( plot_type, data, "Heating_QC", "Sale_Price" )
plot_category( plot_type, data, "House_Style", "Sale_Price" )
plot_category( plot_type, data, "Kitchen_Qual", "Sale_Price" )   # convert to ordinal
plot_category( plot_type, data, "Land_Contour", "Sale_Price" )
plot_category( plot_type, data, "Land_Slope", "Sale_Price" )
plot_category( plot_type, data, "Lot_Config", "Sale_Price" )
plot_category( plot_type, data, "Lot_Shape", "Sale_Price" )
#plot_category( plot_type, data, "Mas_Vnr_Type", "Sale_Price" )
#plot_category( plot_type, data, "Misc_Feature", "Sale_Price" )
plot_category( plot_type, data, "MS_SubClass", "Sale_Price" )
plot_category( plot_type, data, "MS_Zoning", "Sale_Price" )
plot_category( plot_type, data, "Neighborhood", "Sale_Price" )
plot_category( plot_type, data, "Overall_Cond", "Sale_Price" )
plot_category( plot_type, data, "Overall_Qual", "Sale_Price" )
plot_category( plot_type, data, "Paved_Drive", "Sale_Price" )
#plot_category( plot_type, data, "Pool_QC", "Sale_Price" )
#plot_category( plot_type, data, "Roof_Matl", "Sale_Price" )
#plot_category( plot_type, data, "Roof_Style", "Sale_Price" )
plot_category( plot_type, data, "Sale_Condition", "Sale_Price" )
plot_category( plot_type, data, "Sale_Type", "Sale_Price" )
plot_category( plot_type, data, "Street", "Sale_Price" )
#plot_category( plot_type, data, "Utilities", "Sale_Price" )

plot_category( plot_type, data, "Longitude", "Sale_Price" )
plot_category( plot_type, data, "Latitude", "Sale_Price" )

