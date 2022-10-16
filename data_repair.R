### look for missing data ('NA') and repair
#
# NOTE: longhand version
###

data_repair_missing <- function( df ) {
  
  missing.n = sapply(
    names( df ), function(x) length( which( is.na( df[, x] ) ) ) 
  )
  
  which( missing.n != 0 )
  
  ## look for NA in each column
  varNames = names( df )
  
  for ( varName in varNames ) {
    
    rowIndices = which( is.na( df[varName] ) )
    
    if ( length( rowIndices ) > 0 ) {
      str = NULL
      cat( str, "----------------\n", varName, ":", length( rowIndices ), "\n" )
      # apply the correction
      df[ rowIndices, varName ] = 0
    }
  } 
  return( df )
}

# read data from file, then repair
data = read.csv( "Ames_data.csv" )
data_edited = data_repair_missing( data )
data_edited$Garage_Yr_Blt

# short version:
# data$Garage_Yr_Blt[ is.na( data$Garage_Yr_Blt) ] = 0
