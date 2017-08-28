library(dplyr)
  # 1. DOWNLOAD THE DATASET

if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# 2. READING TABLES AND MERGE TRAINING & TEST DATASET TO ONE

x.train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
x.test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y.train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
y.test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject.train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
subject.test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
features <- read.table('./data/UCI HAR Dataset/features.txt')
activitylabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

# 2.1 ASSIGN COLUMN NAMES
colnames(x.train) <- features[,2] 
colnames(y.train) <-"activityId"
colnames(subject.train) <- "subjectID"

colnames(x.test) <- features[,2] 
colnames(y.test) <- "activityId"
colnames(subject.test) <- "subjectID"

colnames(activitylabels) <- c('activityId','activityType')
# 2.2 MERGE
trainingData <- cbind(y.train, subject.train, x.train)
testData <- cbind(y.test, subject.test, x.test)

CombineData <- rbind(trainingData, testData)
colNames <- colnames(CombineData)

#3. EXTRACTS ONLY THE MEASUREMENTS ON THE MEAN
# AND SD FOR EACH MEASUREMENT

# FIND COLUMNS WITH MEAN OR STD
MSCol <- CombineData[,grepl("mean|std|subject|activityId",colnames(CombineData))]

#4. Uses descriptive activity names to name the activities in the data set
MSCol <- merge(MSCol, activityLabels,
                              by='activityId',
                              all.x=TRUE)
# REORDER COLUMN ORDERS
MSCol <- MSCol %>% select(activityType, everything())

#5.Appropriately labels the data set with descriptive variable names.
names(MSCol) <- gsub("Acc", "Accelerator", names(MSCol))
names(MSCol) <- gsub("^t", "time", names(MSCol))
names(MSCol) <- gsub("^f", "frequency", names(MSCol))
names(MSCol) <- gsub("BodyBody", "Body", names(MSCol))
names(MSCol) <- gsub("Freq", "frequency", names(MSCol))
names(MSCol) <- gsub("Mag", "Magnitude", names(MSCol))
names(MSCol) <- gsub("\\(|\\)", "", names(MSCol), perl  = TRUE)

# 6.creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidydata_final<- ddply(MSCol, c("subjectID","activityId"), numcolwise(mean))

write.table(tidydata_final, 'tidydata_final.txt', row.names = F)
