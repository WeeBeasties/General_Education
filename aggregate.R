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
	thisDataSet$Order = i
	cleanData <- rbind(cleanData, thisDataSet)
	rm(thisDataSet)
	file.remove(paste("./data/",fileList[i],sep=""))
	print(paste("Processed file",i))
}

# Clean up extraneous parameters, remove personally identifiable information, and randomize row order
source("./sanitize.R")
cleanData <- FERPAnate(cleanData)


# Save output for later analysis
#saveRDS(cleanData, file = "./processed/cleanData.rds")
write.csv(cleanData, file = "./deIdentifiedData.csv", row.names = FALSE)
