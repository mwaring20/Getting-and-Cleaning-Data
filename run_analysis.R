# Pull in data 
features <- read.table("features.txt")
x_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")

# Label the data 
names(x_train) <- features$V2
names(x_test) <- features$V2
names(y_train) <- "Activity"
names(y_test) <- "Activity"
names(subject_train) <- "Subject"
names(subject_test) <- "Subject"

# Merge
train_data <- cbind(subject_train, y_train, x_train)
test_data <- cbind(subject_test, y_test, x_test)
full_data <- rbind(train_data, test_data)

# Extract Mean & Std Dev for each measurement 
mean_std_features <- grep("mean\\(\\)|std\\(\\)", features$V2, value = TRUE)
selected <- full_data[, c("Subject", "Activity", mean_std_features)]

# Name the activities and clean the variable names
activity_labels <- read.table("activity_labels.txt")
selected$Activity <- factor(selected$Activity, levels = activity_labels$V1, labels = activity_labels$V2)
names(selected) <- gsub("^t", "Time", names(selected))
names(selected) <- gsub("^f", "Frequency", names(selected))
names(selected) <- gsub("Acc", "Accelerometer", names(selected))
names(selected) <- gsub("Gyro", "Gyroscope", names(selected))
names(selected) <- gsub("Mag", "Magnitude", names(selected))
names(selected) <- gsub("BodyBody", "Body", names(selected))
names(selected) <- gsub("\\()", "", names(selected))
names(selected) <- gsub("-mean", "Mean", names(selected))
names(selected) <- gsub("-std", "Std", names(selected))
names(selected) <- gsub("[-]", "", names(selected))

# Create second tidy data set and write to a .txt file
tidy_data <- aggregate(. ~ Subject + Activity, selected, mean)
tidy_data <- tidy_data[order(tidy_data$Subject, tidy_data$Activity), ]
write.table(tidy_data, "tidy_dataset.txt", row.names = FALSE)
