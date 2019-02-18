#
# 0_start.R - set environment variables specifying path locations,
#			  load prerequistive libraries and our 
#			  score.sentiment() function from sentiment.R
#


# assumes we started R in the project's home directory
# or used setwd() to get there:

projectDir = getwd()

codeDir = file.path("~/Sentiment/R", 'R')
dataDir = file.path("~/data", 'data')
outputDir = file.path("~/output", 'output')

VERBOSE=TRUE

if (VERBOSE)
	print("Loading libraries and functions for project")

library(twitteR)
library(plyr)
library(ggplot2)

# load our score.sentiment() function:
source('~/Sentiment/R/4_sentiment.R')
