dsUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dsName <- "data/UCI_HAR_Dataset.zip"

# check if we've already downloaded the data, and download if we haven't
if (!(dir.exists('data'))) {dir.create('data')}
if (!(file.exists(dsName))) {download.file(dsUrl, dsName)}

# unzip the archive
unzip(dsName, exdir = 'data')

# get the unaliased activity descriptions
unalias <- fread('data/UCI HAR Dataset/activity_labels.txt', col.names = c("alias", "activity"), header=F)
feature_names <- fread('data/UCI HAR Dataset/features.txt', col.names = c("alias", "featureName"), header=F)[, featureName]

bound_datasets <- function (data_dir) {
  target <- paste('data/UCI HAR Dataset/', data_dir, sep = "");
  
  # load the full vector (X) data set into a data frame
  X <- paste(target, '/X_', data_dir, '.txt', sep = "");
  dtBase <- fread(X, col.names = feature_names, header = F);
  
  # load the subject data into a data frame
  subj <- paste(target, '/subject_', data_dir, '.txt', sep = "");
  dtSubj <- fread(subj, col.names = "subj_id");
  
  # load the activity (Y) data set
  Y <- paste(target, '/y_', data_dir, '.txt', sep = "");
  dtAlias <- merge(fread(Y, col.names = "alias"), unalias, by = "alias");
  
  # bind the rows together
  dtDir <- cbind(dtSubj, dtAlias, dtBase);
  return(data.table(dtDir))
}

dtTrain <- bound_datasets('train')
dtTest <- bound_datasets('test')