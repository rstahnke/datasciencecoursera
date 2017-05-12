## packages and libraries used

# install.packages("dplyr")  ## remove the hash mark if necessary
library("dplyr")
# install.packages("reshape2")  ## remove the hash mark if necessary
library("reshape2")
a
## Input various training data sets and name the columns
trainx <- read.table("train/X_train.txt")  # Training set dim(trainx)=7352x561
features <- read.table("features.txt") # Features to be column names  dim(features)=561x2 
for (i in 1:561) {
	names(trainx)[i] <- toString(features[i,2])  # Assign feature names to columns
}
testx <- read.table("test/X_test.txt")  # Test set dim(trainx)=2947x561
for (i in 1:561) {
	names(testx)[i] <- toString(features[i,2])   # Assign feature names to columns
}
data1 <- rbind(trainx, testx)  # combine training and test data

trainy <- read.table("train/y_train.txt")  # Training labels  dim(trainy)=7352x1
names(trainy)[1] <- "labels"  # Name the variable
testy <- read.table("test/y_test.txt")  # Test labels  dim(trainy)=2947x1
names(testy)[1] <- "labels"  # Name the variable
data2 <- rbind(trainy, testy)


trainsubject <- read.table("train/subject_train.txt")  # Subject labels for training set
names(trainsubject)[1] <- "subject" # Name the variable
testsubject <- read.table("test/subject_test.txt")  # Subject labels for test set
names(testsubject)[1] <- "subject" # Name the variable
data3 <- rbind(trainsubject, testsubject)

# Columns 461 to 502 have duplicate names and must be deleted for grep to work
data <- data1[,-c(461:502)]
# Find columns with "mean()" or "std()" ==> dim(data)=10299x66 nowA
data <- data[, grep("mean\\(\\)|std\\(\\)",names(data))]
## Add the "labels" and "subject" data columns in
data <- cbind(data, data2)
data <- cbind(data, data3)

## Give meaningful labels to the Activities variable
data$labels <- factor(data$labels, c(1,2,3,4,5,6), c("walking","walking_upstairs","walking_downstairs","sitting","standing","laying"))

## Calculate the mean of the means and stdev's across all rows
data$mean <- rowMeans(data[,grep("mean",names(data))])
data$stdev <- rowMeans(data[,grep("std",names(data))])

## Select only id variables (labels and subject) and mean and stdev columns
datam <- data[,c("labels","subject","mean","stdev")] # dim=10299x4
datamelt <- melt(datam, id=c("labels","subject"))  # dim=20598x4
datamean <- dcast(datamelt, subject+labels~variable, mean)  # dim=180x4

## Write out the data file in tab-delimited form
## This file contains the means of the means and stdev variables for each person by activity
write.table(datamean, "mydata.txt", sep="\t") 
