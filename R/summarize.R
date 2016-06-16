######################################################################################################################
#  summarize.R                                                                                                       #
#  A script to summarize the assessment data based upon various meta-data fields.                                    #
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

library(dplyr)
library(ggplot2)

myData <- readRDS("./processed/cleanData.rds")

prefix <- c("BIOL", "CHEM", "GEOL")

analysis <- myData %>%
	filter(Prefix %in% prefix) %>%
	group_by(Prefix,Level) %>%
	summarise(Average = mean(NS1), StDev = sd(NS1), Met = sum(NS1 >= 3), Not.Met = sum(NS1 <3))
