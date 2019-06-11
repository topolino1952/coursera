# clear workspace
remove(list=ls())

# You might want to adapt the working directory to your local settings
#setwd("C:/gitrepositories/coursera/data_science/03_DataCleaning/course project")

# Adapt this path if you did copy the raw data to a different directory
mainPath <- "./rawdata"
rawDataPath <- file.path(mainPath, "UCI HAR dataset")


############################################################################################
# No need to change anything below this

# define the paths to the test and the training set, as defined by the UCI HAR Dataset
rawDataTestPath <- file.path(rawDataPath, "test")
rawDataTrainPath <- file.path(rawDataPath, "train")


###
### Preparation Task: download and read the raw data
###

### Download the data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# make sure that the main directory exists
if (!dir.exists(mainPath)) {dir.create(mainPath)}

# download data only if it is not yet available
zipname <- file.path(mainPath, "UCI_HAR_dataset.zip")
if (!file.exists(zipname)) {
  download.file(url, destfile = zipname, mode="wb")
  unzip(zipname, exdir = mainPath)
}


### Read the data

## Read the feature and the activity description files

featurefile <- read.csv(file.path(rawDataPath, "features.txt"), header=FALSE, sep="")
activityfile <- read.csv(file.path(rawDataPath, "activity_labels.txt"), header=FALSE, sep="")

# Clean the feature names: convert featurenames from factor to character
featurenames <- as.character(featurefile$V2)

# Get and clean the activitylabels: remove all '_' and convert characters to lower case
activitylabels <- activityfile$V2
activitylabels <- gsub("_", "", activitylabels)
activitylabels <- tolower(activitylabels)


## Read the test set and the training set

# Debug Parameter to reduce the number of read lines to N. Set `N <- Inf` to read everything.
N <- Inf

# read test data only if they are not yet available in the workspace
if(!exists("rawtest")) {
  rawtest <- read.fwf(file.path(rawDataTestPath, "X_test.txt"), 
                      widths = rep(16, 561), 
                      header=FALSE, 
                      sep="", 
                      col.names=featurenames, 
                      n=N)
  
  # add the subjectId and the activity to the data frame to keep the data together
  
  rawtest$subjectId <- unlist(read.table(file.path(rawDataTestPath, "subject_test.txt"), 
                                 header=FALSE, 
                                 nrows=N))
  
  rawtest$activity <- unlist(read.table(file.path(rawDataTestPath, "y_test.txt"), 
                                header=FALSE, 
                                nrows=N))
  
} else {
  print("rawtest:  data is already available in the workspace - not read from file.")
}

# read training data only if they are not yet available in the workspace
if(!exists("rawtrain")) {
  rawtrain <- read.fwf(file.path(rawDataTrainPath, "X_train.txt"), 
                       widths = rep(16, 561), 
                       header=FALSE, sep="", 
                       col.names=featurenames, 
                       n=N)
  
  # add the subjectId and the activity to the data frame to keep the data together
  
  rawtrain$subjectId <- unlist(read.table(file.path(rawDataTrainPath, "subject_train.txt"), 
                                         header=FALSE, 
                                         nrows=N))
  
  rawtrain$activity <- unlist(read.table(file.path(rawDataTrainPath, "y_train.txt"), 
                                        header=FALSE, 
                                        nrows=N))
  
} else {
  print("rawtrain: data is already available in the workspace - not read from file.")
}  



###
### Task 1: Merges the training and the test sets to create one data set.
###

# check that the columns in the test data are identical to the columns in the training data. 
# They should match because we used the same column names; but to be sure check again explicitely.
# If they match, paste training and test set together using rbind()
# if not, stop script.

if (identical(rownames(rawtest), rownames(rawtest))) {
  rawmerged <- rbind(rawtrain, rawtest) # rawmerged: unprocessed raw data, merged from test and training data
} else {
  stop()
}

# check whether no missing values were introduced 
if (!all(colSums(is.na(rawmerged))==0)) {
  warning("NA values are available in the rawmerged data set!")
}



###
### Task 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
###

# search for columns that have either "mean" or "std" anywhere in the column name. 
# note: "mean" or "std" can also be part of a parameter name, such as meanFreq.

c <- colnames(rawmerged)
meanOrStdColNames <- c[grep("mean|std", c)]

# create a new data frame containing only the mean or std columns and including all rows
# add the activity and the subjectId columns as well to keep all relevant data in the same data frame
data <- rawmerged[, c(meanOrStdColNames, "activity", "subjectId")]


###
### Task 3: Uses descriptive activity names to name the activities in the data set
###

# convert column activity to factor class
data$activity <- factor(data$activity)

# get the factor levels of the activity column
activitylevelindices <- as.numeric(levels(data$activity))

# replace the integer levels with the activity character labels
levels(data$activity) <- activitylabels[activitylevelindices] 

# convert subjectId to factor
data$subjectId <- factor(data$subjectId)


###
### Task 4: Appropriately labels the data set with descriptive variable names. 
###

# Note: the labeling of the columns has already been done when importing and cleaning the data in the preparation task.
#
# Clean up the column names:
# - remove all "." that were inserted for characters other than a letter or a digit when using the feature names as column names
# - replace "mean" by "Mean" and "std" by "Std" to apply proper camel case notation to the column names
# - if a variable name starts with 't', replace this character with "time" to be more explicit. 
# - If a variable name starts with 'f', replace this character with "frequency" to be more explicit.
# - Further replacements could be done such as replacing "Acc" by "Acceleration", "Gyro" by "Gyroscope" and "Mag" by Magnitude,
#   but this is omitted here since I think the resulting names will be too long and deteriorate the readability.
# - Note: the column names are explicitely not converted to lower case as suggested by the week 3 lesson, because I consider the readability 
#   of an all-lower-case name as very bad.
#

# remove all '.' from the column names
colnames(data) <- gsub("\\.", "", colnames(data))

# apply proper camel case notation to the column names
colnames(data) <- gsub("mean", "Mean", colnames(data))
colnames(data) <- gsub("std", "Std", colnames(data))

# replace the beginning 't' with 'time', 'f' with 'frequency'
colnames(data) <- gsub("^t", "time", colnames(data))
colnames(data) <- gsub("^f", "frequency", colnames(data))



###
### Task 5: From the data set in step 4, creates a second, independent tidy data set with the average of 
###         each variable for each activity and each subject.
###

library(reshape2)

# specify the id columns (activity and ) and the measurement columns (all other columns; selected by default)
dataMelt <- melt(data, id=c("activity", "subjectId"))

# group data by activity and subjectId and average all available measurement values
# data is presented in the wide form (assignment description says that either long or wide form is acceptable)
meanData <- dcast(dataMelt, activity + subjectId ~ variable, mean)


# check whether no missing values were introduced 
if (!all(colSums(is.na(meanData))==0)) {
  warning("NA values are available in the rawmerged data set!")
}

###
### Save the dataset from Task 5 to a file
###

# write ouptut file to the current directory
write.table(meanData, file="tidyDataAverage.txt", row.names = FALSE)



### 
### Code book generation
###

# if you want to run it, replace the "if (FALSE)" with "if (TRUE)"

if (FALSE) {
  codebook <- c()
  
  for(i in seq(ncol(meanData))) {
    
    varname <- colnames(meanData)[i]
    
    # frequency or time domain?
    if (grepl("^time", tolower(varname))) {
      description <- "Time domain:"
    } else if (grepl("^frequency", tolower(varname))) {
      description <- "Frequency domain:"
    } else {
      description <- ""
    }
    
    # mean or Std or something else?
    if (grepl("mean", tolower(varname))) {
      description <- paste(description, "Mean of")
    } else if (grepl("std", tolower(varname))) {
      description <- paste(description, "Std of")
    }
    
    var <- unlist(strsplit(varname, "Mean|Std"))
    description <- paste(description, var[1])
    
    # is the parameter valid for a specific direction (X, Y, Z)?
    # determine the position of X, Y, Z within the variable name
    if (!is.na(var[2])) {
      posDirection <- regexpr("X|Y|Z", var[2])
      if (posDirection > 0) {
        posDirection <- posDirection[1]
        direction <- substr(var[2], posDirection, posDirection)
        description <- paste(description, "in", direction, "direction")
      }
    } 
    
    # determine levels for factor variables. All other parameters are normalized: write that to the code book.
    if (is.factor(meanData[,i])) {
      levelsDescription <- paste(levels(meanData[,i]), collapse = ", ")
    } else {
      levelsDescription <- "normalized to [-1,1]"
    }
    
    codebookLine <- paste("|", varname, "|", class(meanData[,i]), "|", levelsDescription, "|", "[-]", "|", description, "|" )
    print(codebookLine)
    
    codebook[i] <- codebookLine
  }
  write.table(codebook, file="codebook.txt", row.names = FALSE)
}