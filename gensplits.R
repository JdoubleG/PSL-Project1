# Project 1
#
# Team: James Garijo-Garde (jamesig2) & Matthew Lind (YOUR_LOGIN)

data <- read.csv("Ames_data.csv")
testIDs <- read.table("project1_testIDs.dat")
j <- 2
train <- data[-testIDs[,j], ]
test <- data[testIDs[,j], ]
test.y <- test[, c(1, 83)] # extracts PID and Sale_Price
test <- test[, -83] # removes Sale_Price
write.csv(train,"train.csv",row.names=FALSE)
write.csv(test, "test.csv",row.names=FALSE)
write.csv(test.y,"test_y.csv",row.names=FALSE)