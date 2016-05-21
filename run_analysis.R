#I you already download the zip file named "rprog-data-ProgAssignment3-data.zip", please unzip
#file in your working directory. Please don`t change the names of the files.
#libraries needed: data.table, dplyr
run_analysis <- function(){
#"C:/Users/Javier/Documents/R Directory/rprog-data-ProgAssignment3-data.zip"  
  library(dplyr)
  library(data.table)
  WD <- getwd()
  dest_file <- paste(WD, "/UCI HAR Dataset")
  dest_file <- gsub(" /", "/", dest_file)
  
  #Check if the UCI HAR Dataset directory exists.
  if (!file.exists(dest_file, showWarnings = FALSE)){
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    tryCatch(download.file(url))
    zipfile <- unzip("rprog-data-ProgAssignment3-data.zip")

  }
  #Destination Directory for the test and train files.
  dest_file_test <- paste(dest_file, "/test/")
  dest_file_test <- gsub(" /", "/", dest_file_test)
  dest_file_train <- paste(dest_file, "/train/")
  dest_file_train <- gsub(" /", "/", dest_file_train)

  #1.- MERGE THE TRAINING AND THE TEST SETS TO CREATE ONE DATA SET
  
  #Load activity labels and features
  features <- read.table(gsub(" /", "/", paste(dest_file, "/features.txt")))
  features[,2] <- as.character(features[,2])
  activityLabels <- read.table(gsub(" /", "/", paste(dest_file, "/activity_labels.txt")))
  activityLabels[,2] <- as.character(activityLabels[,2])
  
  #Read temporal information from the file located in the destination Directories.
  test_S <- read.table(gsub("/ ", "/", paste(dest_file_test, "subject_test.txt")))
  test_X <- read.table(gsub("/ ", "/", paste(dest_file_test, "X_test.txt")))
  test_Y <- read.table(gsub("/ ", "/", paste(dest_file_test, "y_test.txt")))

  train_S <- read.table(gsub("/ ", "/", paste(dest_file_train, "subject_train.txt")))
  train_X <- read.table(gsub("/ ", "/", paste(dest_file_train, "X_train.txt")))
  train_Y <- read.table(gsub("/ ", "/", paste(dest_file_train, "y_train.txt")))
  
  #Merge all the data set and add labels
  data_testset <- cbind(test_S, test_Y, test_X)
  data_trainset <- cbind(train_S, train_Y, train_X)
  alldata <- rbind(data_trainset, data_testset)
  colnames(alldata) <- c("subject", "activity", features[,2])

  #2.- EXTRACT ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT
  #Correct all data names
  alldata <- data.table(alldata)
  column.names <- features[,2]
  column.names <- gsub("-", "", column.names)
  column.names <- gsub("[()]", "", column.names)
  column.names <- gsub("mean", "Mean", column.names)
  column.names <- gsub("std", "Std", column.names)
  colnames(alldata) <- c("subject", "activity", column.names)
  
  #Extract Mean and Standard Deviation data
  columnsWanted <- grep(".*Mean.*|.*Std.*", column.names)
  columnsWanted.names <- column.names[columnsWanted]
  columnsWanted.names <- c("subject", "activity", columnsWanted.names)
  sortData <- select(alldata, one_of(columnsWanted.names))
  
  #3.-USES DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA SET
  #turn activities into factors
  sortData$activity <- factor(sortData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
  
  #4.- APPROPRIATELY LABELS THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES.
  sortData.melted <- melt(sortData, id = c("subject","activity"))
  
  #5.- FROM THE DATA SET IN STEP 4, CREATES A SECOND, INDEPENDENT TIDY DATA SET WITH THE AVERAGE OF 
  #EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT.
  sortData.mean <- dcast(sortData.melted, subject + activity ~ variable, mean)
  
  #data creation
  write.table(sortData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
  
}