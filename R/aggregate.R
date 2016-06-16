######################################################################################################################
#  aggregate.R                                                                                                       #
#  A script to load all raw data files, concatenate the rows, and remove personally identifying information.         #
#  The resulting dataset is saved as an rds file for downstream analysis                                             #
#  Created: April 2015                                                                                               #
#  Last modified: June 2016                                                                                          #
#                                                                                                                    #
#  MIT License (MIT)                                                                                                 #
#  Copyright (c) 2015 Dr. Clifton Franklund                                                                          #
#  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated      #
#  documentation files (the "Software"), to deal in the Software without restriction, including without limitation   #
#  the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and  #
#  to permit persons to whom the Software is furnished to do so, subject to the following conditions:                #
#                                                                                                                    #
#  The above copyright notice and this permission notice shall be included in all copies or substantial portions     #
#  of the Software.                                                                                                  #
#                                                                                                                    #
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO  #
#  THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE    #
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF         #
#  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS #
#  IN THE SOFTWARE.                                                                                                  #
######################################################################################################################

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
