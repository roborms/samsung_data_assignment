# Get the training datasets
xtraining <- read.table("train/X_train.txt")
xtraining_sub <- read.table("train/subject_train.txt")
xtraining_mode <- read.table("train/y_train.txt")

# binding the training sets into one set adding the columning for activity and subject
xtraining_final <- cbind(xtraining,xtraining_sub,xtraining_mode)

# Get the test datasets
xtest <- read.table("test/X_test.txt")
xtest_sub <- read.table("test/subject_test.txt")
xtest_mode <- read.table("test/y_test.txt")

# binding the test sets into one set adding the columns for activity and subject
xtest_final <- cbind(xtest,xtest_sub,xtest_mode)

# combine the test and training sets into single set
combined_set <- rbind(xtest_final,xtraining_final)

# Adding the mean and standard deviation to each row of the single data set
combined_set$mean <- apply(combined_set[1:561], 1,mean)
combined_set$std <- apply(combined_set[1:561], 1,sd)

# subsetting to make a dataset pf Subject, activity, mean and sd
mean_std_set <- combined_set[562:565]

# changing the variable names to be more descriptive
colnames(mean_std_set) <- c("subject","activity","mean","standard_dev")


# need to make the activity meaningful in the dataset
#   1 WALKING
#   2 WALKING_UPSTAIRS
#   3 WALKING_DOWNSTAIRS
#   4 SITTING
#   5 STANDING
#   6 LAYING
#replacing the activity number with the description into the dataset
mean_std_set$activity = ifelse(mean_std_set$activity == '1',"WALKING", mean_std_set$activity)
mean_std_set$activity = ifelse(mean_std_set$activity == '2',"WALKING_UPSTAIRS", mean_std_set$activity)
mean_std_set$activity = ifelse(mean_std_set$activity == '3',"WALKING_DOWNSTAIRS", mean_std_set$activity)
mean_std_set$activity = ifelse(mean_std_set$activity == '4',"SITTING", mean_std_set$activity)
mean_std_set$activity = ifelse(mean_std_set$activity == '5',"STANDING", mean_std_set$activity)
mean_std_set$activity = ifelse(mean_std_set$activity == '6',"LAYING", mean_std_set$activity)


# Create a second, independent tidy data set with the 
# average of each mean grouped by subject and acitivty. 
library(plyr)
avg_by_activity_subject <- ddply(mean_std_set, .(mean_std_set$activity,mean_std_set$subject), summarize,avg = mean(mean))

# rename the columns
colnames(avg_by_activity_subject) <- c("activity","subject_id","avg_of_means")

# Write the data (avg_by_activity_subject) to file
library(MASS)
write.matrix(avg_by_activity_subject, file = "step_5_data.txt", sep = ",")
