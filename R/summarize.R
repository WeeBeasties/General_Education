library(dplyr)
library(ggplot2)

myData <- readRDS("./processed/cleanData.rds")

prefix <- c("BIOL", "CHEM", "GEOL")

analysis <- myData %>%
	filter(Prefix %in% prefix) %>%
	group_by(Prefix,Level) %>%
	summarise(Average = mean(NS1), StDev = sd(NS1), Met = sum(NS1 >= 3), Not.Met = sum(NS1 <3))
