
# Codebook for the Getting and Cleaning Data Project, Week 4



## Project Description

One of the most exciting areas in all of data science right now is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 

The data can be used to train models to classify different activites like walking, sitting, standing or lying. 

However for this project, the goal is to create a tidy data set according to the assignment instructions.


## Data Source

A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 



## Study design and data processing

### Collection of the raw data
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

### Notes on the original (raw) data 
The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

For each record it is provided:

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

* Features are normalized and bounded within [-1,1].
* Each feature vector is a row on the text file.


## Creating the tidy datafile

These are the tasks as asked by the assigment:

1. Merges the training and the test sets to create one data set.
1. Extracts only the measurements on the mean and standard deviation for each measurement.
1. Uses descriptive activity names to name the activities in the data set
1. Appropriately labels the data set with descriptive variable names.
1. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.




##### Preparations: Read the data

* Read the feature names (`features.txt`) 
    + cleaning: convert names from factor to character class
    
* Read the activity labels (`activity_labels.txt`)
    * cleaning: remove all '_' and convert characters to lower case

* Read test data
    + use the feature names as column names
    + read the corresponding activity data from `y_test.txt` and add it as a column to the test data
    + read the corresponding subject id data from `subject_test.txt`and add it as a column to the test data
* Read training data
    + use the feature names as column names
    + read the corresponding activity data from `y_train.txt` and add it as a column to the training data
    + read the corresponding subject id data from `subject_train.txt`and add it as a column to the training data


##### Task 1:

* Create a data frame which combines both test and training data  using `rbind()`. 
    + This is possible because both data frames have the same columns. 
    + Also combine the activity and the subjectId columns.

##### Task 2:

* Extract all columns that contain either `mean` or `std` in the feature name. 
    + Leave the activity and subjectId columns in the data set because they are used as identifier columns later.
    + Drop all other columns.

##### Task 3: 

* For the `activity` column, replace the integer levels by the character description as read in the file `activity_labels.txt`.
* Convert the `subjectId` column to factor class

##### Task 4:

* remove all "." that were inserted for characters other than a letter or a digit when using the feature names as column names
* replace "mean" by "Mean" and "std" by "Std" to apply proper camel case notation to the column names
* time/frequency domain variable:
    + if a variable name starts with 't', replace this character with "time" to be more explicit. 
    + if a variable name starts with 'f', replace this character with "frequency" to be more explicit.
* Further replacements could be done such as replacing "Acc" by "Acceleration", "Gyro" by "Gyroscope" and "Mag" by Magnitude, but this is omitted here since I think the resulting names will be too long and deteriorate the readability.

Note: the column names are explicitely not converted to lower case as suggested by the week 3 lesson, because I consider the readability of an all-lower-case name as very bad.


##### Task 5:

* Create a new data set by melting the data into narrow form by applying `activity` and `subjectId` as identifiers and all other columns as measurement variables.

* From this melted data set, create a summary data set in *wide form* which provides the mean value of every variable per activity and subject.

### Why is the submitted data tidy?

The output file submitted for review qualifies as tidy data set because it matches the requirements for tidy data outlined in Hadley Wickham's "Tidy Data" paper, including:

1. Each variable forms a column
2. Each observation forms a row
3. Each type of observational unit forms a table

In support for requirement 1 for tidy data, a variable contains all values that measure the same underlying attribute (like the mean value of Body Acceleration in X-axis, or the standard deviation of Gravity Acceleration Jerk in Z-axis).

In support for requirement 2 for tidy data, an observation contains all values on the same unit (in this example the unit is activity and subjectId) accross attributes.

In support for requriement 3 for tidy data, each fact is expressed in only one place.  

The submitted data is presented in wide format.


### Dealing with missing values

The data set is complete and contains no missing values.


## Description of the variables in the `tidyDataAverage.txt` file

The submitted tidy dataset contains 81 variables with 180 observations. 

The variables are described in the following table:

| Parameter Name | Class | Levels/Range | Unit | Description |
| :---           | :---  | :---         | :--- | :---        |
| activity | factor | walking, sitting, standing, laying | [-] |  Activity done by test person while collecting data |
| subjectId | factor | 1, 2 | [-] |  Subject Identification number |
| timeBodyAccMeanX | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeBodyAcc in X direction |
| timeBodyAccMeanY | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeBodyAcc in Y direction |
| timeBodyAccMeanZ | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeBodyAcc in Z direction |
| timeBodyAccStdX | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeBodyAcc in X direction |
| timeBodyAccStdY | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeBodyAcc in Y direction |
| timeBodyAccStdZ | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeBodyAcc in Z direction |
| timeGravityAccMeanX | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeGravityAcc in X direction |
| timeGravityAccMeanY | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeGravityAcc in Y direction |
| timeGravityAccMeanZ | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeGravityAcc in Z direction |
| timeGravityAccStdX | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeGravityAcc in X direction |
| timeGravityAccStdY | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeGravityAcc in Y direction |
| timeGravityAccStdZ | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeGravityAcc in Z direction |
| timeBodyAccJerkMeanX | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeBodyAccJerk in X direction |
| timeBodyAccJerkMeanY | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeBodyAccJerk in Y direction |
| timeBodyAccJerkMeanZ | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeBodyAccJerk in Z direction |
| timeBodyAccJerkStdX | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeBodyAccJerk in X direction |
| timeBodyAccJerkStdY | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeBodyAccJerk in Y direction |
| timeBodyAccJerkStdZ | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeBodyAccJerk in Z direction |
| timeBodyGyroMeanX | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeBodyGyro in X direction |
| timeBodyGyroMeanY | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeBodyGyro in Y direction |
| timeBodyGyroMeanZ | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeBodyGyro in Z direction |
| timeBodyGyroStdX | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeBodyGyro in X direction |
| timeBodyGyroStdY | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeBodyGyro in Y direction |
| timeBodyGyroStdZ | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeBodyGyro in Z direction |
| timeBodyGyroJerkMeanX | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeBodyGyroJerk in X direction |
| timeBodyGyroJerkMeanY | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeBodyGyroJerk in Y direction |
| timeBodyGyroJerkMeanZ | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeBodyGyroJerk in Z direction |
| timeBodyGyroJerkStdX | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeBodyGyroJerk in X direction |
| timeBodyGyroJerkStdY | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeBodyGyroJerk in Y direction |
| timeBodyGyroJerkStdZ | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeBodyGyroJerk in Z direction |
| timeBodyAccMagMean | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeBodyAccMag |
| timeBodyAccMagStd | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeBodyAccMag |
| timeGravityAccMagMean | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeGravityAccMag |
| timeGravityAccMagStd | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeGravityAccMag |
| timeBodyAccJerkMagMean | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeBodyAccJerkMag |
| timeBodyAccJerkMagStd | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeBodyAccJerkMag |
| timeBodyGyroMagMean | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeBodyGyroMag |
| timeBodyGyroMagStd | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeBodyGyroMag |
| timeBodyGyroJerkMagMean | numeric | normalized to [-1,1] | [-] | Time domain: Mean of timeBodyGyroJerkMag |
| timeBodyGyroJerkMagStd | numeric | normalized to [-1,1] | [-] | Time domain: Std of timeBodyGyroJerkMag |
| frequencyBodyAccMeanX | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyAcc in X direction |
| frequencyBodyAccMeanY | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyAcc in Y direction |
| frequencyBodyAccMeanZ | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyAcc in Z direction |
| frequencyBodyAccStdX | numeric | normalized to [-1,1] | [-] | Frequency domain: Std of frequencyBodyAcc in X direction |
| frequencyBodyAccStdY | numeric | normalized to [-1,1] | [-] | Frequency domain: Std of frequencyBodyAcc in Y direction |
| frequencyBodyAccStdZ | numeric | normalized to [-1,1] | [-] | Frequency domain: Std of frequencyBodyAcc in Z direction |
| frequencyBodyAccMeanFreqX | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyAcc in X direction |
| frequencyBodyAccMeanFreqY | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyAcc in Y direction |
| frequencyBodyAccMeanFreqZ | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyAcc in Z direction |
| frequencyBodyAccJerkMeanX | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyAccJerk in X direction |
| frequencyBodyAccJerkMeanY | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyAccJerk in Y direction |
| frequencyBodyAccJerkMeanZ | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyAccJerk in Z direction |
| frequencyBodyAccJerkStdX | numeric | normalized to [-1,1] | [-] | Frequency domain: Std of frequencyBodyAccJerk in X direction |
| frequencyBodyAccJerkStdY | numeric | normalized to [-1,1] | [-] | Frequency domain: Std of frequencyBodyAccJerk in Y direction |
| frequencyBodyAccJerkStdZ | numeric | normalized to [-1,1] | [-] | Frequency domain: Std of frequencyBodyAccJerk in Z direction |
| frequencyBodyAccJerkMeanFreqX | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyAccJerk in X direction |
| frequencyBodyAccJerkMeanFreqY | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyAccJerk in Y direction |
| frequencyBodyAccJerkMeanFreqZ | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyAccJerk in Z direction |
| frequencyBodyGyroMeanX | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyGyro in X direction |
| frequencyBodyGyroMeanY | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyGyro in Y direction |
| frequencyBodyGyroMeanZ | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyGyro in Z direction |
| frequencyBodyGyroStdX | numeric | normalized to [-1,1] | [-] | Frequency domain: Std of frequencyBodyGyro in X direction |
| frequencyBodyGyroStdY | numeric | normalized to [-1,1] | [-] | Frequency domain: Std of frequencyBodyGyro in Y direction |
| frequencyBodyGyroStdZ | numeric | normalized to [-1,1] | [-] | Frequency domain: Std of frequencyBodyGyro in Z direction |
| frequencyBodyGyroMeanFreqX | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyGyro in X direction |
| frequencyBodyGyroMeanFreqY | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyGyro in Y direction |
| frequencyBodyGyroMeanFreqZ | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyGyro in Z direction |
| frequencyBodyAccMagMean | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyAccMag |
| frequencyBodyAccMagStd | numeric | normalized to [-1,1] | [-] | Frequency domain: Std of frequencyBodyAccMag |
| frequencyBodyAccMagMeanFreq | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyAccMag |
| frequencyBodyBodyAccJerkMagMean | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyBodyAccJerkMag |
| frequencyBodyBodyAccJerkMagStd | numeric | normalized to [-1,1] | [-] | Frequency domain: Std of frequencyBodyBodyAccJerkMag |
| frequencyBodyBodyAccJerkMagMeanFreq | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyBodyAccJerkMag |
| frequencyBodyBodyGyroMagMean | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyBodyGyroMag |
| frequencyBodyBodyGyroMagStd | numeric | normalized to [-1,1] | [-] | Frequency domain: Std of frequencyBodyBodyGyroMag |
| frequencyBodyBodyGyroMagMeanFreq | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyBodyGyroMag |
| frequencyBodyBodyGyroJerkMagMean | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyBodyGyroJerkMag |
| frequencyBodyBodyGyroJerkMagStd | numeric | normalized to [-1,1] | [-] | Frequency domain: Std of frequencyBodyBodyGyroJerkMag |
| frequencyBodyBodyGyroJerkMagMeanFreq | numeric | normalized to [-1,1] | [-] | Frequency domain: Mean of frequencyBodyBodyGyroJerkMag |



## Sources
Used codebook template as referred from this post in the discussion forum: 
https://www.coursera.org/learn/data-cleaning/discussions/weeks/4/threads/vPkdCHiDEeaRhQ7LRvvExQ
https://gist.github.com/JorisSchut/dbc1fc0402f28cad9b41


