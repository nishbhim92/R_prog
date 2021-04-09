#libraries
library("twitteR")
library("ROAuth")
library("tidyverse")

#connect to twitter
api_key <- 'XXXXXXXXXXXXXXXXXXXXXX'
api_keysecret <- 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
access_key <- 'XXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
access_keysecret <- 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
setup_twitter_oauth(api_key,api_keysecret,access_key,access_keysecret)

#Get tweets of multiple users in this case I am taking tweets related to some ICOs
boson <- userTimeline("BosonProtocol", n=100)
apis <- userTimeline("_theAPIS_", n=100)
converg <- userTimeline("ConvergenceFin", n=100)
cookfin <- userTimeline("cook_finance", n=100)
totem <- userTimeline("TotemFi", n=100)

#combine these tweets to form a data frame
tweets<- tibble(map_df(c(boson,apis,converg,cookfin,totem),as.data.frame))  
#write in to a csv
write.csv(tweets, file="tweets.csv", row.names=FALSE)  
