dsUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip";
dsName <- "data/UCI_HAR_Dataset.zip";

# check if we've already downloaded the data, and download if we haven't
if (!(dir.exists('data'))) {dir.create('data')};
if (!(file.exists(dsName))) {download.file(dsUrl, dsName)};

