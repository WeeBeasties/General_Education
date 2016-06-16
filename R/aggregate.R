#############################################################################
#  aggregate.R                                                              #
#  A script to load all raw data files, concatenate the rows, and           #
#  remove personally identifying information. Save dataset as rds.          #
#  Dr. Clifton Franklund                                                    #
#  April 2015                                                               #
#############################################################################

library(xlsx)
# Figure out what raw data files are present
fileList <- list.files(path = "./data", pattern = "xlsx", include.dirs = TRUE)

# Sequentially add raw data to one new master file
cleanData <- NULL
for (i in 1:as.numeric(length(fileList))){
	thisDataSet <- read.xlsx(paste("./data/",fileList[i],sep=""), sheetName="scores", header=TRUE)
	thisDataSet <- thisDataSet[!is.na(thisDataSet$User.ID),]
	cleanData <- rbind(cleanData, thisDataSet)
	rm(thisDataSet)
}

# Encode the student IDs and remove names
source("./R/sanitize.R")
cleanData <- FERPAnate(cleanData)

# Save output for later analysis
saveRDS(cleanData, file = "./processed/cleanData.rds")
