library(RCurl)
library(twitteR)
library(ROAuth)

requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL = "http://api.twitter.com/oauth/access_token"
authURL = "http://api.twitter.com/oauth/authorize"

consumerKey <- "key"
consumerSecret <- "secret key"


Cred <- OAuthFactory$new(consumerKey=consumerKey,
                         consumerSecret=consumerSecret,
                         requestURL=requestURL,
                         accessURL=accessURL, 
                         authURL=authURL)

#The next command provides a URL which you will need to copy and paste into your favourite browser
#Assuming you are logged into Twitter you will then be provided a PIN number to type into the R command line
Cred$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl") )
# Checks that you are authorised
registerTwitterOAuth(Cred)

setup_twitter_oauth(consumerKey, consumerSecret)