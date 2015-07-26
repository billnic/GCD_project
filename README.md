---
title: "README template"  
author: "William F. Nicodemus"  
date: "July 23, 2015"  
output: html_document
keep_md: yes  
---
# Getting and Cleaning Data Course Project: Create a Tidy Data Set #

### Data Source: Human Activity Recognition Using Smartphones ###
### Program Script: run_analysis.R ###

### Intro ###

The program starts with loading the R packages needed to execute the code and setting the workings directory. Then files are downloaded, unzipped, and read into R. Then datasets are merged, needed columns are selected, and the data is manipulated to create an initial tidy dataset. Finally, from the resulting dataset, a second tidy dataset is created by taking the mean of each value columns grouped by two categorical variables.

### Preliminary Steps ###

Load the **dyplyr**, **tidyr**, and **reshape** packages. Set the working directory to R's default directory. This directory should be changed if needed.  

### Download, Unzip and Read Files ###

Create the subdirectory **proj_data** and download into this directory the zip file *dataarchive.zip* from [](http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). Unzip all the files and place them into a subdirectory of *proj_data* named **UCI_HAR**.
Read all necessary files using the function read.table(). For a list of files and their contents refer to the Codebook.md file.

### First Tidy Data Set: x_all ###

1. The code first assigns the column names in *features* to the measument values in *x_test* and *x_train*. This was done first because there were duplicate column names not visible with R's default column names and this crashed of functions. These columns with duplicates are deleted because they are not needed (their label do not include mean() or avg()). 

2. Select all columns with **mean()** or **std()** in their column names. There were other columns containing the word *mean* but I opted to not include them.

3. Map the labels in *activity_labels* to the *y_test* and *y_train* data frames. There are six activities (walking, standing and so forth) and are mapped their numerical values. 

4. Add to the data frames of numerical measurements *x_test* and *y_train*, the subject column in *y_test* and *y_train* and the activity column in *y_test* and *y_train*. The new columns **subject** and **activity** are placed in the first two columns of *x_test* and *y_train*.

5. Merge *x_train* and *x_test* into *x_all* by the rbind() function. Please note that merging is possible without further manipulation because the data frames have the matching column names.

6. The colomn names in the final data set were not sufficiently descriptive because they either started with t or f. These characters were substituted with time and freq (for frequency). I tried to further clarify the column labels but the columns became too wide and opted to comment out the extended labels so they would be available if needed.

    #### *x_all* is a tidy data set. ####

### Second Tidy Data Set: x_avg###

In this data set, rows are grouped by activity and subject and summarize with the mean of each measurement.

1. Melt the *x_all* data frame by the variables **activity** and **subject** and the measure variables. Assign the results into *melted*.

2. Calculate mean values by activity and subject by casting *x_all* Rearrange rows in ascending orders of activity and subject number. Assign this to the final data set **x_avg**

3. Append the label *GrpAvg.* to the the labels of the measurement columns in *x_avg*. 

     #### *x_avg* is a tidy data set. ####

4. Write *x_avg* into the text file ***tidy_data.txt*** and save in the *proj_data* directory

## Code Scipt: run_analysis.R ##

Note: Switch eval to TRUE to to evaluate the code and include its results.

```{r eval=FALSE}
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
# The following two files are for general information on the study and the measurement vectors. They are 
# not part of the data construct of the tidy data set.
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


```







 
 
