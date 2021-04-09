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

#Get tweets
boson <- userTimeline("BosonProtocol", n=100)
apis <- userTimeline("_theAPIS_", n=100)
converg <- userTimeline("ConvergenceFin", n=100)
cookfin <- userTimeline("cook_finance", n=100)
totem <- userTimeline("TotemFi", n=100)

#write in to a csv
tweets<- tibble(map_df(c(boson,apis,converg,cookfin,totem),as.data.frame))  
write.csv(tweets, file="tweets.csv", row.names=FALSE)  

#read data
tweets<-read.csv("tweets.csv")