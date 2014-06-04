## reading in the data  -----------------------------------

actLabels <- read.table("activity_labels.txt")
names(actLabels) <- c("label","activity")
features <- read.table("features.txt", colClasses = c("character"))
features <- features$V2

## train data
trainX <- read.table("train/X_train.txt")
trainY <- read.table("train/y_train.txt")
subTrain <- read.table("train/subject_train.txt")

## test data
testX <- read.table("test/X_test.txt")
testY <- read.table("test/y_test.txt")
subTest <- read.table("test/subject_test.txt")

## Merging test and train set and renaming columns -----------------------

data <- rbind( cbind(subTrain,trainX, trainY), cbind(subTest,testX, testY))
names(data) <- c("subject", features, "label")


## Extract only measurements on mean and SD -----------------------
selectedCols <- features[union(grep("mean" , features) , grep("std", features))]
selectedData <- data[c("subject", selectedCols, "label")]

## Using descriptive activity names and cleaning variable names --------------------------
selectedCols <- gsub("\\()", "", selectedCols)
selectedCols <- gsub("\\-", "", selectedCols)
selectedCols <- gsub("mean", "Mean", selectedCols)
selectedCols <- gsub("std", "StdDev", selectedCols)
names(selectedData) <- c("subject", selectedCols, "label")
selectedData <- merge(selectedData, actLabels)
selectedData$label <- NULL

## averaging each variable for each activity and each subject

newData <- aggregate(selectedData[selectedCols], by = list(selectedData$activity,selectedData$subject), FUN = mean)
names(newData) <- gsub("Group.1", "activity", names(newData))
names(newData) <- gsub("Group.2", "subject", names(newData))

write.table(newData, "averageActivity.txt", row.names = F)


