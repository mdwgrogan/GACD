library(data.table)

dsUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dsName <- "UCI_HAR_Dataset.zip"

# check if we've already downloaded the data, and download if we haven't
if (!(file.exists(dsName))) {download.file(dsUrl, dsName)}

# unzip the archive
if (!(dir.exists("UCI HAR Dataset"))) {unzip(dsName)}

# get the unaliased activity descriptions
unalias <- fread('UCI HAR Dataset/activity_labels.txt', col.names = c("alias", "activity"), header=F)
feature_names <- fread('UCI HAR Dataset/features.txt', col.names = c("alias", "featureName"), header=F)[, featureName]

# bind the subject IDs and activity names to the accelerometer data
bound_datasets <- function (data_dir) {
  target <- paste('UCI HAR Dataset/', data_dir, sep = "");
  
  # load the full vector (X) data set into a data frame
  X <- paste(target, '/X_', data_dir, '.txt', sep = "");
  dtBase <- fread(X, col.names = feature_names, header = F);
  
  # load the subject data into a data frame
  subj <- paste(target, '/subject_', data_dir, '.txt', sep = "");
  dtSubj <- fread(subj, col.names = "subj_id");
  
  # load the activity (Y) data set
  Y <- paste(target, '/y_', data_dir, '.txt', sep = "");
  dtAlias <- merge(fread(Y, col.names = "alias"), unalias, by = "alias");
  
  # bind the columns together
  dtDir <- cbind(dtSubj, dtAlias, dtBase);
  return(dtDir)
}

dtTrain <- bound_datasets('train')
dtTest <- bound_datasets('test')

# rbind the data sets, since we have different subjects we don't need to remove duplicates
dtCombined <- rbind(dtTrain, dtTest)

# use grep to find the only the columns we're interested in
keepCols <- c(1, 3, grep('-mean[()]{2}|-std[()]{2}', colnames(dtCombined)))
dtFiltered <- dtCombined[, keepCols, with=FALSE]

# make a tidy data set grouped BY=subj_id, activity
dtTidy <- dtFiltered[, lapply(.SD, mean, na.rm=TRUE), by=c("subj_id", "activity")]

# export the result to a file
write.table(dtTidy, file="tidy.txt", row.names = FALSE)