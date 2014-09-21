# Initializating the libraries for the script
library(data.table)
library(reshape2)

### Initializating variables ###
# The file url and the name.
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName <- "Dataset.zip"


# Downloading the file into the working directory
download.file(fileUrl,fileName)
# Unziping the file into the working directory
unzip(fileName)


# Load: data column names
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Get the mean and std features first of merge train and test files. 
# Advise from David's project FAQ: "Seems a lot easier just to not include 
# them in the first place."

# Get the measurements which are the mean or the standard deviation from all features
extract_meanstd <- grepl("mean|std", features)
extract_freq <- grepl("meanFreq", features) #Remove meanFreq


# Load the test data from X_test.txt, Y_test.txt and subject_test.txt files.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", dec=".")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt", dec=".")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", dec=".")

# Set the columns names for each data frame.
colnames(X_test) <- features
colnames(Y_test) <- "Activity_id"
colnames(subject_test) <- "subject"

# Keep only mean and std features
X_test <- X_test[,extract_meanstd & !extract_freq]

# Merge all test data in one data frame. (We use cbind for adding columns)
test_data <- cbind(X_test,Y_test,subject_test)


# Load the train data from X_train.txt, Y_train.txt and subject_train.txt files.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", dec=".")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt", dec=".")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", dec=".")

# Set the columns names for each data frame.
colnames(X_train) <- features
colnames(Y_train) <- "Activity_id"
colnames(subject_train) <- "subject"

# Keep only mean and std features
X_train <- X_train[,extract_meanstd & !extract_freq]

# Merge all train data in one data frame. (We use cbind for adding columns)
train_data <- cbind(X_train,Y_train,subject_train)


# 1. Merges the training and the test sets to create one data set.
mergedData <- rbind(test_data, train_data)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# This point has been done before point 1 following the David's advice.


# 3. Uses descriptive activity names to name the activities in the data set
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activities) <- c("Activity_id", "Activity_label")

# Merge the activities id with their label from the file activity_labels.txt
mergedData <- merge(mergedData, activities, by.x = "Activity_id", by.y = "Activity_id")

# 4. Appropriately labels the data set with descriptive variable names. 
names(mergedData) <- sub("\\(\\)","", names(mergedData))
names(mergedData) <- sub("-","", names(mergedData))
names(mergedData) <- sub("mean","Mean", names(mergedData))
names(mergedData) <- sub("std","Std", names(mergedData))
names(mergedData) <- sub("f","frec", names(mergedData))
names(mergedData) <- sub("^t","time", names(mergedData))


# 5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.

# Select the labels for using in melt and dcast functions
selectLabels   = c("subject", "Activity_id", "Activity_label")

# Get the variables from mergedData names except "selectLabels"
selectVars = setdiff(colnames(mergedData), selectLabels)

# Melt the data with melt function by subject and activity.
tidyData = melt(mergedData, id = selectLabels, measure.vars = selectVars)

# Apply the mean function to the dataset using dcast function.
tidyData = dcast(tidyData, subject + Activity_label ~ variable, mean)

# Write tidyData and mergedData into the working directory
write.table(tidyData, file="./tidyData.txt", row.names=FALSE)
write.table(mergedData, file="./mergedData.txt", row.names=FALSE)
# END


