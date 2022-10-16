library(ggplot2)

data <- read.csv("Ames_data.csv")
testIDs <- read.table("project1_testIDs.dat")
vNames = names(data)
train <- data[-testIDs[,j], ]

winsor.vars <- c("Lot_Frontage", "Lot_Area", "Mas_Vnr_Area", "BsmtFin_SF_2", "Bsmt_Unf_SF", "Total_Bsmt_SF", "Second_Flr_SF", 'First_Flr_SF', "Gr_Liv_Area", "Garage_Area", "Wood_Deck_SF", "Open_Porch_SF", "Enclosed_Porch", "Three_season_porch", "Screen_Porch", "Misc_Val")

quan.value <- 0.95
for(var in winsor.vars){
  dd <- subset(train, select=c("Sale_Price", var))
  before <- ggplot(dd, aes(x=train[[var]], y=train[["Sale_Price"]])) +
    geom_point(size=2) + geom_smooth(method=lm, color="red") +
    labs(x=paste("Before:", var), y="Sale Price")
  print(before)
  
  tmp <- train[, var]
  myquan <- quantile(tmp, probs = quan.value, na.rm = TRUE)
  tmp[tmp > myquan] <- myquan
  train[, var] <- tmp
  
  after <- ggplot(dd, aes(x=train[[var]], y=train[["Sale_Price"]])) +
    geom_point(size=2) + geom_smooth(method=lm, color="red") +
    labs(x=paste("After:", var), y="Sale Price")
  print(after)
}