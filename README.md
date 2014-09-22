Getting_and_cleaning_data_project
=================================

This is the course project for Getting and cleaning data course.


The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


## Transformation details

There are 5 parts:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## How ```run_analysis.R``` implements the above steps:

* Require ```reshapre2``` and ```data.table``` libraries installed.
* Download the data source
* Load the features labels. (mean and std)
* Load test data by merging the following files ```X_test.txt```, ```Y_test.txt``` and ```subject_test.txt```.
* Load train data by merging the following files ```X_train.txt```, ```Y_train.txt``` and ```subject_train.txt```.
* Merge data sets (train and test).
* Load the activity labels by Activity_id.
* Correct the variables names for a better understanding of they by removing the following characters "(", ")", "-". Changing f --> frec (frecuency) and t --> time. And also capitol letter in mean and std for distinguish the start of the word.
* Create a tidy set with the mean of the average of each variable for each activity and each subject.
