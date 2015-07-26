library(dplyr)
library(tidyr)
library(reshape2)
# 
#          Working directory is my default working directory. Change as needed 
#
setwd("~/R/my_working_directory/")
#
#          download and put unzipped files into proj_data subfolder 
#
if (!file.exists("proj_data")) {
    dir.create("proj_data")}
url<-"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "./proj_data/dataarchive.zip") # include argument method="curl" if running a Mac
unzip("./proj_data/dataarchive.zip", overwrite=TRUE,junkpaths=TRUE,exdir = "./proj_data/UCI_HAR")
# 
#           read unzipped files into workspace  
# 
x_train<-read.table("./proj_data/UCI_HAR/X_train.txt",sep="")
x_test<-read.table("./proj_data/UCI_HAR/X_test.txt",sep="")
y_train<-read.table("./proj_data/UCI_HAR/Y_train.txt",sep="")
y_test<-read.table("./proj_data/UCI_HAR/Y_test.txt",sep="")
# View(x_train)
# View(x_test)
# View(y_train)
# View(y_test)
subject_train<-read.table("./proj_data/UCI_HAR/subject_train.txt",sep="",stringsAsFactors = FALSE)
subject_test<-read.table("./proj_data/UCI_HAR/subject_test.txt",sep="",stringsAsFactors = FALSE)
features<-read.table("./proj_data/UCI_HAR/features.txt",sep="",stringsAsFactors = FALSE)
activity_labels<-read.table("./proj_data/UCI_HAR/activity_labels.txt",sep="")
# 
# The following two files are for general information on the study and the measurement vectors. They are not
# part of the data construct of the tidy data set.
# 
features_info<-read.csv("./proj_data/UCI_HAR/features_info.txt",header=FALSE,sep=" ")
readme<-read.csv("./proj_data/UCI_HAR/README.txt",header=FALSE,sep=" ")
# View(subject_train)
# View(subject_test)
# View(features)
# View(activity_labels)
# View(features_info)
# View(readme)
# 
# dim(x_test)       #                 [1] 2947  561
# dim(x_train)      #                 [1] 7352  561
# dim(y_test)       #                 [1] 2947    1
# dim(y_train)      #                 [1] 7352    1
# dim(features)     #                 [1]  561    2 
# dim(subject_test) #                 [1] 2947    1
# 
# levels(as.factor(y_test[,1])) #     activity 1-6
# levels(as.factor(y_train[,1])) #    activity 1-6
# levels(as.factor(subject_test[,1])) # test individuals, length 9
# #                                     "2"  "4"  "9"  "10" "12" "13" "18" "20" "24", lenght(train) 21
# levels(as.factor(features[,2])) # length 477 but there are 561 rows. Check for dups after selecting 
#                                   mean and std cols
#__________________________________________________________________________________________________
#Create first tidy data set.
#                                 
# assign the column names to x_test and x_train contained in the second column of features
# 
colnames(x_test)<-features$V2
colnames(x_train)<-features$V2
# 
#    there are duplicate column names, luckily not any of the ones with mean or std: 
#      delete duplicate columns first 
# 
x_test <- x_test[ , !duplicated(colnames(x_test))]
x_train <- x_train[ , !duplicated(colnames(x_train))]
# 
#    select column names with "mean()" or "std()" 
#    
x_test<-select(x_test,contains("std()",ignore.case=TRUE),contains("mean()",ignore.case=TRUE))
x_train<-select(x_train,contains("std()",ignore.case=TRUE),contains("mean()",ignore.case=TRUE))
#
#    map the activity_labels to y_test and y_train  
#  
y_test<-merge(y_test,activity_labels)
y_train<-merge(y_train,activity_labels)
# 
#    add the following columns to the left of columns of x_test and y_test:
#   - subject:      this is the renamed subject_test and subject_train
#   - activity:     the activity label from activity_labels
#
x_test<-cbind(rename(subject_test,subject=V1),activity=y_test$V2,x_test) 
x_train<-cbind(rename(subject_train,subject=V1),activity=y_train$V2,x_train)
#
#  Since both x_test and y_test have matching columns, merge both data frames by rows. 
#  
x_all<-rbind(x_train,x_test)
x_all$subject<-as.factor(x_all$subject)
# 
# dim(x_all)                [1] 10299   69   Notice the additional column from subject_set
# 
namescol<-colnames(x_all)
namescol<-gsub("tBody","timeBody",namescol)
namescol<-gsub("fBody","freqBody",namescol)
namescol<-gsub("tGravity","timeGravity",namescol)
colnames(x_all)<-namescol
# 
#__________________________________________________________________________________________________
# 
#   Creates a second, independent tidy data set with the average of each variable for each 
#       activity and each subject   
#       
#     melt x_all by subject and activity and apply group_by function
#       
melted<-melt(x_all,id=c("subject", "activity"),measure.vars = c(colnames(x_all)[3:68]))
melted <- group_by(melted,subject,activity)
# 
# 
#     cast x_avg and calculate mean values by activity and subject 
# 
x_avg<-arrange(dcast(melted,activity+subject~variable,mean),activity,subject)
# 
# append "GrpAvg." to the column names 
# 
x_avg_labels<-colnames(x_avg)
x_avg_labels[3:ncol(x_avg)]<-paste0("GrpAvg.",x_avg_labels[3:ncol(x_avg)])
colnames(x_avg)<-x_avg_labels
#
# Create a text file in proj_data directory
#
write.table(x_avg, file="proj_data/tidy_data.txt",row.names = F)
