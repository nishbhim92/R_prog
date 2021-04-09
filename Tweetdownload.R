#libraries
library("twitteR")
library("graphics")
library("purrr")
library("stringr")
library("tm")
library("syuzhet")
library("dplyr")

#connect to twitter
api_key <- 'XXXX'
api_keysecret <- 'XXXX'
access_key <- 'XXXX'
access_keysecret <- 'XXXX'
setup_twitter_oauth(api_key,api_keysecret,access_key,access_keysecret)
#Get tweets
boson <- userTimeline("BosonProtocol", n=100)
apis <- userTimeline("_theAPIS_", n=100)
converg <- userTimeline("ConvergenceFin", n=100)
cookfin <- userTimeline("cook_finance", n=100)
totem <- userTimeline("TotemFi", n=100)
#write in to a csv
tweets<- tbl_df(map_df(c(boson,apis,converg,cookfin,totem),as.data.frame))  
write.csv(tweets, file="tweets.csv", row.names=FALSE)  
#readdata
tweets<-read.csv("tweets.csv")