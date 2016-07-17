######################################################################################################################
#  aggregate.R                                                                                                       #
#  A script to load all raw data files, concatenate the rows, and remove personally identifying information.         #
#  The resulting dataset is saved as an rds file for downstream analysis                                             #
#  Created: April 2015                                                                                               #
#  Last modified: June 2016                                                                                          #
#                                                                                                                    #
#  MIT License (MIT)                                                                                                 #
#  Copyright (c) 2015 Dr. Clifton Franklund                                                                          #
######################################################################################################################

library(xlsx)
# Figure out what raw data files are present
fileList <- list.files(path = "./data", pattern = "xlsx", include.dirs = TRUE)

# Sequentially add raw data to one new master file
cleanData <- NULL
for (i in 1:as.numeric(length(fileList))){
	thisDataSet <- read.xlsx(paste("./data/",fileList[i],sep=""), sheetName="scores", header=TRUE)
	thisDataSet <- thisDataSet[!is.na(thisDataSet$Student.Name),]
	thisDataSet$file = i
	cleanData <- rbind(cleanData, thisDataSet)
	rm(thisDataSet)
}

# Remove personally identifiable information and randomize row order
cleanData$User.ID <- NULL
cleanData$Student.Name <- NULL
cleanData <- cleanData[sample(nrow(cleanData)),]

# Remove points columns if they exist
cleanData$PT1 = cleanData$PT2 = cleanData$PT3 = cleanData$PT4 = NULL

# Save output for later analysis
#saveRDS(cleanData, file = "./processed/cleanData.rds")
write.csv(cleanData, file = "./deIdentifiedData.csv", row.names = FALSE)
