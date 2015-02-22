## downloading an unzipping file
if (!file.exists("UCI HAR Dataset")) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl,destfile="./Dataset.zip",method="auto")
  unzip(zipfile="./Dataset.zip")
}

## reading data from files
activityTest  <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
activityTrain <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
subjectTest   <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
subjectTrain  <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
setTest   <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
setTrain  <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)

## Joining tables
Subj      <- rbind(subjectTrain, subjectTest)
Activity  <- rbind(activityTrain, activityTest)
Sets      <- rbind(setTrain, setTest)

## Description
names(Subj)<- "Subject"
names(Activity)<- "Activity"
featuresName <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)
names(Sets)<- featuresName$V2

## Merging in one data set
rawData <- cbind(Sets, cbind(Subj, Activity))

## Subset Features by measurements on the mean and standard deviation
Features<-featuresName$V2[grep("mean\\(\\)|std\\(\\)", featuresName$V2)]
rawData<-subset(rawData, select=c(as.character(Features), "Subject", "Activity" ))

activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)

names(rawData) <- gsub('Acc',"Accelerometer",names(rawData))
names(rawData) <- gsub('BodyBody',"Body",names(rawData))
names(rawData) <- gsub('Gyro',"Gyroscope",names(rawData))
names(rawData) <- gsub('Mag',"Magnitude",names(rawData))
names(rawData) <- gsub('^t',"Time",names(rawData))
names(rawData) <- gsub('^f',"Frequency",names(rawData))

tidyData <- ddply(rawData, c("Subject","Activity"), numcolwise(mean))

write.table(tidyData, file = "tidydata.txt", row.name=FALSE)