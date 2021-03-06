
if (VERBOSE)
{
	print("Extracting text from tweets & calculating sentiment scores")
	flush.console()
}

# obviously, this is not an elegant way to repeat an operation, but
# we do end up with lots of objects in memory to play with (it _is_
# a tutorial, after all :)

american.text = laply(american.tweets, function(t) t$getText() )
american.text = str_replace_all(american.text,"[^[:graph:]]", " ") 
american.text
delta.text = laply(delta.tweets, function(t) t$getText() )
delta.text = str_replace_all(delta.text,"[^[:graph:]]", " ") 

jetblue.text = laply(jetblue.tweets, function(t) t$getText() )
jetblue.text = str_replace_all(jetblue.text,"[^[:graph:]]", " ") 

american.scores = score.sentiment(american.text, pos.words, neg.words, .progress='text')
delta.scores = score.sentiment(delta.text, pos.words, neg.words, .progress='text')
jetblue.scores = score.sentiment(jetblue.text, pos.words, neg.words, .progress='text')

american.scores$airline = 'Jet Airways'
american.scores$code = 'JA'
delta.scores$airline = 'IngiGo'
delta.scores$code = 'IG'
jetblue.scores$airline = 'Air India'
jetblue.scores$code = 'AI'

all.scores = rbind( american.scores, delta.scores, jetblue.scores) 
#southwest.scores, united.scores, us.scores

if (VERBOSE)
	print("Plotting score distributions")

# ggplot works on data.frames, always
g.hist = ggplot(data=all.scores, mapping=aes(x=score, fill=airline) )

# add a bar graph layer. Let it bin the data and compute frequencies
# (set binwidth=1 since scores are integers)
g.hist = g.hist + geom_histogram( binwidth=1 )

# make a separate plot for each airline
g.hist = g.hist + facet_grid(airline~.)

# plain display, nice colors
g.hist = g.hist + theme_bw() + scale_fill_brewer() 

print(g.hist)
ggsave(file.path("C:/Users/Public/Pictures/Sample Pictures", 'twitter_score_histograms.pdf'), g.hist, width=6, height=5.5)


if (VERBOSE)
	print("Comparing Twitter & ACSI data")

all.scores$very.pos.bool = all.scores$score >= 2
all.scores$very.neg.bool = all.scores$score <= -2

all.scores$very.pos = as.numeric( all.scores$very.pos.bool )
all.scores$very.neg = as.numeric( all.scores$very.neg.bool )

twitter.df = ddply(all.scores, c('airline', 'code'), summarise, 
                   very.pos.count=sum( very.pos ), 
                   very.neg.count=sum( very.neg ) )

twitter.df$very.tot = twitter.df$very.pos.count + 
                        twitter.df$very.neg.count

twitter.df$score = round( 100 * twitter.df$very.pos.count / 
                                twitter.df$very.tot )

require(doBy)
orderBy(~-score, twitter.df)

compare.df = merge(twitter.df, acsi.df, by=c('code', 'airline'), 
                   suffixes=c('.twitter', '.acsi'))
compare.df = merge(twitter.df, acsi.df, by=c('score', 'airline'))

# build scatter plot
g.scatter = ggplot( compare.df, aes(x=score.twitter, y=score.acsi) ) + 
			      geom_point( aes(color=airline), size=5 ) + 
			      theme_bw() + opts( legend.position=c(0.2, 0.85) )

# have ggplot2 fit and plot a linear model with R's lm() function
g.fit = g.scatter + geom_smooth(aes(group=1), se=F, method="lm")

print(g.scatter)
print(g.fit)

ggsave(file.path(outputDir, 'twitter_acsi_comparison.pdf'), g.scatter, width=7, height=7)
ggsave(file.path(outputDir, 'twitter_acsi_comparison_with_fit.pdf'), g.fit, width=7, height=7)
