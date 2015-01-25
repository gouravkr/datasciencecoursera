features <- read.table("UCI HAR Dataset/features.txt", header = F)
features$V2 <- gsub("-|,",".",features$V2)
features$V2 <- gsub("\\()","_",features$V2)
features$V2 <- gsub("_.","_",features$V2)
features$V2 <- make.names(features$V2, unique =T)
act_labels <- read.table("uci har dataset/activity_labels.txt")

x_test <- read.table("UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = F)

names(x_test) <- c(as.vector(features$V2))

y_test$labels <- act_labels$V2[match(y_test$V1, act_labels$V1)]
x_test <- cbind.data.frame(subject = subject_test$V1, activity = y_test$labels, x_test)

x_train <- read.table("UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = F)

names(x_train) <- c(as.vector(features$V2))

y_train$labels <- act_labels$V2[match(y_train$V1, act_labels$V1)]
x_train <- cbind.data.frame(subject = subject_train$V1, activity = y_train$labels, x_train)

alldata <- rbind(x_test, x_train)

# subjects <- 1:30
# activities <- as.vector(act_labels$V2)

# final_data <- data.frame(subject = sort(rep(1:30, 6)), activity = rep(activities, 6))
# 
# for (i in seq_along(alldata[3:563])){
#      row_num <- 1
#      for (j in seq_along(subjects)){
#           for (k in seq_along(activities)){
#                final_data[row_num,i+2] <- mean(alldata[data$subject == j & 
#                                                             alldata$activity == activities[k],i+2])
#                k <- k+1
#                row_num <- row_num+1
#           }
#           j <- j+1
#      }
#      names(final_data)[i+2] <- names(alldata[i+2])
# }

library(dplyr)
my_df <- tbl_df(alldata)
my_df %>% 
     select(subject, activity, contains("mean"),contains("std")) %>%
     group_by(subject, activity) %>% 
     summarise_each(funs(mean)) -> dat_sum
