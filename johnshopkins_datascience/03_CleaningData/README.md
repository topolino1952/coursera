# Readme for the Getting and Cleaning Data Project, Week 4

## Introduction

The purpose of this project is practising to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 

The data set used for this project was collected from the accelerometer from a Samsung Galaxy S smartphone. This data can be used to estimate, whether the user is currently walking, sitting, standing or lying down. 

More information is provided in the `Codebook.md`.


## What the `run_analysis` script does

The provided script `run_analysis.R` reads the accelerometer data, combines two sets of data (test and training data), then extracts all measurements that represent either a mean or a std value and cleans the variable names.
Each observation belongs to a specific activity (e.g. walking, sitting) and and each activity was done by a specific test person, indicated by a subject id. The data is melted in a tidy form by activity and by subject and the mean values of all the columns are provided in wide format. Finally, the script exports this summary data set in wide format as a text file.

### Input Files for the Script

* Raw data:
    + `./rawdata/UCI HAR Dataset/activity_labels.txt`
    + `./rawdata/UCI HAR Dataset/features.txt`
    + `./rawdata/UCI HAR Dataset/test/subject_test.txt`
    + `./rawdata/UCI HAR Dataset/test/X_test.txt`
    + `./rawdata/UCI HAR Dataset/test/y_test.txt`
    + `./rawdata/UCI HAR Dataset/train/subject_train.txt`
    + `./rawdata/UCI HAR Dataset/train/X_train.txt`
    + `./rawdata/UCI HAR Dataset/train/y_train.txt`
    
    Note: the files in the subdirectory `/test/Inertial Signals` and `/train/Inertial Signls` are not used.

* Project files:
    + `README.md` (this file)
    + `Codebook.md`
    + `run_analysis.R`
  
### Output File

The script generates the file `tidyDataAverage.txt`. It can be read using the following command:
`data <- read.table("tidyDataAverage.txt", header = TRUE)`


## Guide to create the tidy data file

* You might want to set the working directory at the beginning of the script

* Run the `run_analysis.R` script
    + This will download the data to `./rawdata`
    + The script will unzip the data to the subdirectory `./rawdata/UCI HAR Dataset`
    + you may also adapt the path to the raw data by changing the content of the `rawDataPath` variable at the beginning of the script 

* The script generates the output file `tidyDataAverage.txt`.


### Details on the script

As requested by the assignment, the code book describes the variables, the data and any transformations that were done to clean up the data. Therefore, for any details about the script to generate the tidy data, please refer to either the code or the code book.





### Possible Improvements

* Data import could be significantly speeded up by using `read_fwf()` from the `readr` package.
