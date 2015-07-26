<<<<<<< HEAD
---
title: "Codebook template"  
author: "William F. Nicodemus"  
date: "July 23, 2015"  
output: html_document
keep_md: yes  
---
## Project Description ##

A tidy data set is created from the Human Activity Recognition Using Smartphones study data sets.  In this study Samsong smartphones recorded linear acceleration and angular velocity in 30 subjects performing six different activities. Eight files from this study were merged into one tidy data set. Each observation of this data set contains every 66 measurements for each activity and individual. From this data the final tidy data is created with the average of each measurement grouped by activity and subject.

## Study design and data processing ## 

The experiments was carried out with a group of 30 volunteers performing six activities (WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using the smartpone's accelerometer and gyroscope, the study captured the 3-axial linear acceleration and the 3-axial angular velocity at a constant rate of 50Hz. The experiments were video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

## Creating the tidy datafiles ##  

A data set was created from eight files in the smartphone and 66 of 561 measurement vectors are selected. The criteria for selecting these 66 measurements is every column name with the label "mean()" or "std()". Of the eight original data set files, two contain the measurement variables, namely, *x_test* and *x_train* depending on whether the volunteers were selected for generating the training data or the test data. After merging these two data sets together along with the two categorical columns derived from the other six data sets from the original study, the average by activity and subject is calculated for each measurement column for each the 66 measurements.

Details on obtaining the original data sets and on how to run the program that creates the tidy data set, see [link] https://github.com/billnic/GCD_project/blob/master/README.md 

### Files Downloaded ###

All files are text files (.txt) and are read into data frames. These data frames preserve the name of their original text file name.

>
File Name          | Description
-------------------|--------------------------------------
**x_test**           | 2947 rows by 561 columns of position measurements  
**x_train**          | 7352 rows by 561 columns  
**y_test**           | 2947 rows by 1 numerical column (1 to 6) identifying the activity  
**y_train**          | 7352 rows by 1 column  
**activity_labels**  |    6 rows by 1 column containing the activity labels  
**features**         |  561 rows by 2 columns with the measurement labels and their numeric column position    
**subject_test**     | 2947 rows by 1 numerical column identifying the 9 test subjects    
**subject_train**    | 7352 rows by 1 numerical column identifying the 21 train subjects    

These files are downloaded and processed into the final tidy data set in the program **run_analysis.R**

The program downloads for information purposed two other files, namely *features_info* and *README*

### Guide to create the tidy data file ### 

Run the R program **run_analysis.R**. The program does the following:  
 1. In your working directory, download the data to the diretory */proj_data/dataarchive.zip*  
 2. Unzip the file and place resulting files into */proj_data/UCI_HAR*  
 3. Merges the eight data frames described above into one data frame *x_all*  
 4. Calculates the average by activity and subject for each mean() and std() measurement and adds to each column name the label "GrpAvg_"  
 5. Create a text file **tidy_data.txt**  
 
### General Description of data in **tidy_data.txt** ### 

For each record in the dataset it is provided: 

1. An identifier of the subject who carried out the experiment.
2. Its activity label. 
3. Columns 3-68, are 66 measurements are time and frequency domain variables. These, measurements record:
    - Triaxial (x,y,z axis) acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
    - Triaxial Angular velocity from the gyroscope. 

    - The measurement columns for this database come from the accelerometer and gyroscope 3-axial raw signals timeAcc-XYZ and timeGyro-XYZ.      

    - Acceleration signal was then separated into body and gravity acceleration signals (timeBodyAcc-XYZ and timeGravityAcc-XYZ)  

    - Body linear acceleration and angular velocity were derived in time to obtain Jerk signals (timeBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).   

    - Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing freqBodyAcc-XYZ, freqBodyAccJerk-XYZ, freqBodyGyro-XYZ, freqBodyAccJerkMag, freqBodyGyroMag, freqBodyGyroJerkMag. (Note the 'freq' to indicate frequency domain signals).   

    - These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.  

## Description of variables in **tidy_data.txt** ##

This file contains with 10299 observations and 68 variables.
The first two columns are categorical variables and the all other 66 columns are numeric

### Categorical Variables###

**subject**

 Col 1, subject               - Factor w/ 30 levels "1","2",...,"30". Indicator for the 30 participant volunteers in the study
 
**activity**                             
                                        
 Col 2, activity              - Factor w/ 6 levels LAYING, SITTING, STANDING, WALKING, WALKING DOWNSTAIRS, WALKING DOWNSTAIRS

### Measurement Variable###

####Units of Measurement####

Coordinates of a movement between [-1,1] where positives are the opposite direction than negatives. Accelerometer detect magnitude and direction of the proper acceleration or g-force in meters per time squared. Gyroscopes measure rotational motion or angular velocity measured in degrees per second. 

####Abbreviations####

Abbreviation  | Description
--------------|-------
GrpAvg  | Leading every measurement column to indicate measurement is an average by activity and subject
time    | time domain signal
freq    | frequency domain signal
mean()  | mean of observed time or frequency signal
std()   | standard deviation of observed time or frequency signal
-x,-y,-z| coordinate axis
Acc     | accelerometer measurement
Gyro    | gyroscopic measurements
Body    | body movement.
Jerk    | acceleration from short duration shock, impact, or jerk novement
Mag     | magnitud of movement

There are 33 mean variables and 33 standard deviation variables. Columns are devided into time and frequency domainxs. The columns and their column position can be gruped as follows:

#### Body Accelerometer###

Colums Label          | Description
---------------------------|---------------------------
**timeBodyAcc-XYZ.axis**    |  time body accelerometer signal
**freqBodyAcc-XYZ.axis**    |  fast fourier transformation (FFT) applied to timeBodyAcc-XYZ.axis above
**timeBodyAccMag**           | magnitud of the 3-dimensional time body acceleration signal calculated using the Euclidean norm
**freqBodyAccMag**            | FFT applied to timeBodyAccMag above

#####Columns#####

Col 3, GrpAvg.timeBodyAcc-std()-X                   
Col 4, GrpAvg.timeBodyAcc-std()-Y                  
Col 5, GrpAvg.timeBodyAcc-std()-Z  
Col 36, GrpAvg.timeBodyAcc-mean()-X                   
Col 37, GrpAvg.timeBodyAcc-mean()-Y                  
Col 38, GrpAvg.timeBodyAcc-mean()-Z    
Col 23, GrpAvg.freqBodyAcc-std()-X                
Col 24, GrpAvg.freqBodyAcc-std()-Y                 
Col 25, GrpAvg.freqBodyAcc-std()-Z   
Col 56, GrpAvg.freqBodyAcc-mean()-X               
Col 57, GrpAvg.freqBodyAcc-mean()-Y               
Col 58, GrpAvg.freqBodyAcc-mean()-Z    
Col 18, GrpAvg.timeBodyAccMag-std()  
Col 32, GrpAvg.freqBodyAccMag-std()    
Col 51, GrpAvg.timeBodyAccMag-mean()     
Col 65, GrpAvg.freqBodyAccMag-mean()     

#### Body Gyroscope####

Colums Label          | Description
---------------------------|-----------------------------------------------------|---------------------------
**timeBodyGyro-XYZ.axis**  |     time body gyroscope signal  
**freqBodyGyro-XYZ.axis**   |    FFT appliet to timeBodyGyro-XYZ above  
**timeBodyGyroMag**          |   magnitud of the 3-dimensional time body gyroscope signal  
**freqBodyBodyGyroMag**       |  FFT applied to timeBodyGyroMag above  

#####Columns#####

Col 12, GrpAvg.timeBodyGyro-std()-X                  
Col 13, GrpAvg.timeBodyGyro-std()-Y                   
Col 14, GrpAvg.timeBodyGyro-std()-Z    
Col 45, GrpAvg.timeBodyGyro-mean()-X                    
Col 46, GrpAvg.timeBodyGyro-mean()-Y                  
Col 47, GrpAvg.timeBodyGyro-mean()-Z     
Col 29, GrpAvg.freqBodyGyro-std()-X                 
Col 30, GrpAvg.freqBodyGyro-std()-Y                  
Col 31, GrpAvg.freqBodyGyro-std()-Z     
Col 62, GrpAvg.freqBodyGyro-mean()-X                
Col 63, GrpAvg.freqBodyGyro-mean()-Y              
Col 64, GrpAvg.freqBodyGyro-mean()-Z   
Col 21, GrpAvg.timeBodyGyroMag-std()     
Col 34, GrpAvg.freqBodyBodyGyroMag-std()                              
Col 54, GrpAvg.timeBodyGyroMag-mean()    
Col 67, GrpAvg.freqBodyBodyGyroMag-mean()          

####Gravity Accelerometer####

Colums Label          | Description
---------------------------|------------------------------------------------------|---------------------------
*timeGravityAcc-XYZ.axis*   |  time gravity accelerometer signal  
*timeGravityAccMag*          | magnitud of the 3-dimensional time gravity aceleration signal calculated using the Euclidean norm  

#####Columns#####

Col 6, GrpAvg.timeGravityAcc-std()-X                 
Col 7, GrpAvg.timeGravityAcc-std()-Y                 
Col 8, GrpAvg.timeGravityAcc-std()-Z    
Col 39, GrpAvg.timeGravityAcc-mean()-X                  
Col 40, GrpAvg.timeGravityAcc-mean()-Y                 
Col 41, GrpAvg.timeGravityAcc-mean()-Z     
Col 19, GrpAvg.timeGravityAccMag-std()    
Col 52, GrpAvg.timeGravityAccMag-mean()    

####Body Accelerometer Jerk####

Colums Label               | Description  
---------------------------|------------------------------------------------------|---------------------------
*timeBodyAccJerk-XYZ.axis* |  jerk signals from body linear acceleration derived in time  
*freqBodyAccJerk-XYZ.axis* |   FFT applied to timeBodyAccJerk-XYZ.axis above  
*timeBodyAccJerkMag*       |  magnitud of the 3-dimensional jerk signals from body linear acceleration derived in time  
*freqBodyBodyAccJerkMag*     | FFT applied to timeBodyAccJerkMag above 

#####Columns#####

Col 9, GrpAvg.timeBodyAccJerk-std()-X              
Col 10, GrpAvg.timeBodyAccJerk-std()-Y              
Col 11, GrpAvg.timeBodyAccJerk-std()-Z  
Col 42, GrpAvg.timeBodyAccJerk-mean()-X               
Col 43, GrpAvg.timeBodyAccJerk-mean()-Y             
Col 44, GrpAvg.timeBodyAccJerk-mean()-Z   
Col 26, GrpAvg.freqBodyAccJerk-std()-X             
Col 27, GrpAvg.freqBodyAccJerk-std()-Y            
Col 28, GrpAvg.freqBodyAccJerk-std()-Z         
Col 59, GrpAvg.freqBodyAccJerk-mean()-X           
Col 60, GrpAvg.freqBodyAccJerk-mean()-Y           
Col 61, GrpAvg.freqBodyAccJerk-mean()-Z  
Col 20, GrpAvg.timeBodyAccJerkMag-std()  
Col 33, GrpAvg.freqBodyBodyAccJerkMag-std()       
Col 53, GrpAvg.timeBodyAccJerkMag-mean()                
Col 66, GrpAvg.freqBodyBodyAccJerkMag-mean() 

####Body Gyroscopic Jerk####
  
Colums Label               | Description  
---------------------------|------------------------------------------------------|---------------------------
*timeBodyGyroJerk-XYZ.axis* |  jerk signals from body angular velocity derived in time
*timeBodyGyroJerkMag*       | magnitud of the 3-dimensional jerk signals from body linear acceleration derived in time
*freqBodyBodyGyroJerkMag*    | FFT applied to timeBodyGyroJerkMag

#####Columns#####

Col 15, GrpAvg.timeBodyGyroJerk-std()-X              
Col 16, GrpAvg.timeBodyGyroJerk-std()-Y              
Col 17, GrpAvg.timeBodyGyroJerk-std()-Z    
Col 48, GrpAvg.timeBodyGyroJerk-mean()-X             
Col 49, GrpAvg.timeBodyGyroJerk-mean()-Y             
Col 50, GrpAvg.timeBodyGyroJerk-mean()-Z    
Col 22, GrpAvg.timeBodyGyroJerkMag-std()   
Col 35, GrpAvg.freqBodyBodyGyroJerkMag-std()      
Col 55, GrpAvg.timeBodyGyroJerkMag-mean()    
Col 68, GrpAvg.freqBodyBodyGyroJerkMag-mean()     

=======
codebook
>>>>>>> f0a1675b7d2861ba0531631588def174be6ab292
