#
# 1_load.R - loads Twitter data, Hu & Liu's opinion lexicon, and the ACSI scores from disk
#
#			 scrape.R should be run once to collect and cache tweets before running this script.
#

if (!file.exists(file.path(~/data, 'american.tweets.RData' )) )
{
	stop("Tweets not found on disk -- source('R/scrape.R') to scrape Twitter first")

} else {

	if (VERBOSE)
		print("Loading tweets from disk:")
	
	print( load( file.path("~/data", 'american.tweets.RData' ) ) )
	print( load( file.path("~/data", 'delta.tweets.RData' ) ) )
	print( load( file.path("~/data", 'jetblue.tweets.RData' ) ) )
# 	print( load( file.path("~/data", 'southwest.tweets.RData' ) ) )
# 	print( load( file.path("~/data", 'united.tweets.RData' ) ) )
# 	print( load( file.path("~/data", 'us.tweets.RData' ) ) )
}


if (VERBOSE)
	print("Loading Hu & Liu opinion lexicon")

hu.liu.pos = scan(file.path("~/data", 'opinion-lexicon-English', 'positive-words.txt'), what='character', comment.char=';')
hu.liu.neg = scan(file.path("~/data", 'opinion-lexicon-English', 'negative-words.txt'), what='character', comment.char=';')

# add a few twitter and industry favorites
pos.words = c(hu.liu.pos, 'upgrade')
neg.words = c(hu.liu.neg, 'wtf', 'wait', 'waiting', 'epicfail', 'mechanical')


if (VERBOSE)
	print("Loading ACSI airline scores")

print( load( file.path("~/data", 'acsi.df.RData')) )
