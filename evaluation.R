# Project 1
#
# Team: James Garijo-Garde (jamesig2) & Matthew Lind (YOUR_LOGIN)

# Suppose we have already read test_y.csv in as a two-column 
# data frame named "test.y":
# col 1: PID
# col 2: Sale_Price
test.y <- read.csv("test_y.csv")
# maybe necessary to set column names

pred <- read.csv("mysubmission1.txt")
names(test.y)[2] <- "True_Sale_Price"
pred <- merge(pred, test.y, by="PID")
sqrt(mean((log(pred$Sale_Price) - log(pred$True_Sale_Price))^2))