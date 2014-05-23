##
## run_analysis reads in training and test measurement sets, along with associated
## subject and activity files, cross-references them to feature and activity 
## descriptions provided in separate files. The function then does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each 
##    measurement type.
## 3. Creates anand returns an independent data set with the averages of each 
##    variable for each activity and each subject
##

run_analysis <- function (
    base.path = "./UCI HAR Dataset/",
    f.file = paste(base.path, "features.txt", sep=""),
    al.file = paste(base.path, "activity_labels.txt", sep=""),
    train.m.file = paste(base.path, "train/X_train.txt", sep=""),
    train.s.file = paste(base.path, "train/subject_train.txt", sep=""),
    train.a.file = paste(base.path, "train/y_train.txt", sep=""),
    test.m.file = paste(base.path, "test/X_test.txt", sep=""),
    test.s.file = paste(base.path, "test/subject_test.txt", sep=""),
    test.a.file = paste(base.path, "test/y_test.txt", sep=""))
{
    ##
    ## Collect all interesting features for consumption into matrix features.all
    ##

    raw.features <- read.table(
        f.file,quote="",colClasses=c("integer","character"),col.names=c("index","name"))

    fun.set <- c("mean\\(\\)","std")
    features.all <- data.frame("index"=integer(0),"name"=character(0))

    for (fun in fun.set)
    {
        features.local <- raw.features[grep(fun, raw.features$name),]
        features.all <- rbind(features.all, features.local)
    }

    features.all <- features.all[order(features.all$index),]

    ##
    ## Generalized function to merge measurements, subjects, and activities sets
    ##

    collect.measurements <- function ( m.file , s.file , a.file , features )
    {
        measurements.ctypes <- rep("numeric",561)
        raw.data <- read.table(m.file,quote="",colClasses=measurements.ctypes)
        raw.data <- raw.data[,features$index]
        colnames(raw.data) <- features$name

        raw.subjects <- read.table(s.file,quote="",colClasses=c("integer"),col.names=c("subject"))
        raw.data <- cbind(raw.data, raw.subjects)

        raw.activities <- read.table(a.file,quote="",colClasses=c("integer"),col.names=c("activity"))
        raw.train <- cbind(raw.data,raw.activities)
    }

    ## Merge training and test measurement sets, then apply activity labels

    full.data <- rbind(
        collect.measurements(train.m.file, train.s.file, train.a.file, features.all),
        collect.measurements(test.m.file, test.s.file, test.a.file, features.all))
    
    full.activities <- read.table(
        al.file,quote="",colClasses=c("integer","character"),col.names=c("index","activity.name"))
    full.data <- merge(full.data, full.activities, by.x="activity", by.y="index")
    full.data$activity <- NULL

    ##
    ## Generate mean values across all measurements for all subjects and all 
    ## activities. Populate results into summary.data as a three-dimensional
    ## array.
    ##

    names.subjects <- as.matrix(unique(full.data$subject))
    names.subjects <- names.subjects[order(names.subjects)]
    features.count <- length(features.all$name)
    summary.data <- array(0, 
        dim=c(length(full.activities$activity.name),length(names.subjects),length(features.all$name)), 
        dimnames=list(full.activities$activity.name,names.subjects,features.all$name))

    for (activity in full.activities$activity.name)
    {
        for (subject in names.subjects)
        {
            summary.data[activity,as.character(subject),] <- as.numeric(
                lapply(
                    as.list(
                        full.data[
                            ((full.data$subject == subject) & (full.data$activity.name == activity)),
                            1:features.count]),
                    mean)
            )
        }
    }
    
    ## Reformat tidy data into a data frame

    summary.data <- as.data.frame(as.table(summary.data))
    colnames(summary.data) <- c("activity","subject","measurement","value")
    summary.data
}
