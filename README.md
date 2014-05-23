## run_analysis

### Description

*run_analysis.R* is an R script to clean and consolidate data from the [Human Activity Recognition Using Smartphones Data Set] (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) for the getdata-003 course. The script contains a single function - *run_analysis*.

### Usage

run_analysis(base.path = "./UCI HAR Dataset/", f.file = paste(base.path, "features.txt", sep=""), al.file = paste(base.path, "activity_labels.txt", sep=""), train.m.file = paste(base.path, "train/X_train.txt", sep=""), train.s.file = paste(base.path, "train/subject_train.txt", sep=""), train.a.file = paste(base.path, "train/y_train.txt", sep=""), test.m.file = paste(base.path, "test/X_test.txt", sep=""), test.s.file = paste(base.path, "test/subject_test.txt", sep=""), test.a.file = paste(base.path, "test/y_test.txt", sep=""))

### Arguments

**base.path** - UCI HAR Dataset main directory
**f.file** - file containing feature index-name pairs for the measurement data
**al.file** - file containing activity index-label pairs
**train.m.file** - file containing training set measurements
**train.s.file** - file containing training set subjects
**train.a.file** - file containing training set activities
**test.m.file** - file containing test set measurements
**test.s.file** - file containing test set subjects
**test.a.file** - file containing test set activities

### Details

With the UCI HAR data set unzipped in the working directory, execution of *run_analysis* with no arguments does the following:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Value

A data frame with columns **activity**, **subject**, **measurement**, **value**.

### Examples

> source("run_analysis.R")
> tidy_data <- run_analysis()
> str(tidy_data)
> head(tidy_data)
> tail(tidy_data)