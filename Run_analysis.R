# Course 3 Getting and cleaning data
# week4 , final project
# 04 April 2019
# final version
rm(list=ls())
library(dplyr)
#description of data:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# data:
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# read data, labels and Subjects ID for train 
dat1 <- read.table("./UCI HAR Dataset/train/X_train.txt")
labels1 <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject1 <- read.table("./UCI HAR Dataset/train/subject_train.txt")
dat1 <- cbind(subject1,dat1,labels1)

# read data, labels and Subjects ID for text
dat2 <- read.table("./UCI HAR Dataset/test/X_test.txt")
labels2 <- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject2 <- read.table("./UCI HAR Dataset/test/subject_test.txt")
dat2 <- cbind(subject2,dat2,labels2)

# check if they really have the same number of features 
dim(dat1)
dim(dat2)

# read features names
feat <- read.table("./UCI HAR Dataset/features.txt")
features_names <- as.character(feat$V2)

# read activity labels
class_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
class_labels <- class_labels$V2
levels(class_labels)

# beware there are duplicated names! will be removed after
# combine train and test dataset
dat <- rbind(dat1,dat2)
dim(dat)
colnames(dat)
# add columns names + names of first and last one
names(dat) <- c("subject_ID",features_names, "labelType")
colnames(dat)

# remove duplicated column names
dat <- dat[,!duplicated(names(dat))]
dim(dat)

# one way to select mean and std
dat_small <- select(dat,c(ID = contains("subject_ID"),contains("mean"),contains("std"), activity_type = contains("labelType")))
dim(dat_small)
# activity_type must be a factor
dat_small$activity_type <- as.factor(dat_small$activity_type)
levels(dat_small$activity_type)


# select only mean and std
dat_s <- select(dat,contains("std"))
dat_m <- select(dat,contains("mean"))
dat_small2 <- cbind(dat_m,dat_s)
dat_small2$activity_type <- as.factor(dat$labelType)
# add subject ID
dat_small2$ID <- dat$subject_ID
dim(dat_small2)


# check level names
levels(dat_small$activity_type) <- levels(class_labels)
# check if takes new levels
levels(dat_small$activity_type)

# produce final averages for subjects and activities
dat_final <- dat_small %>% group_by(activity_type, ID) %>% summarize_all(mean)

write.table(dat_final, file = "final.txt",  row.name = FALSE)

