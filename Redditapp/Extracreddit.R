#Working directory, set your working directory path and app name using setwd
#setwd("C:/Users/####/####/Redditapp/") or your preferred path

#install RedditExtractor
#install.packages(RedditExtractoR") for first time use
library("RedditExtractoR") #load RedditExtractor app
# https://cran.r-project.org/web/packages/RedditExtractoR/RedditExtractoR.pdf

library("tidyverse") # collection of some data science R packages https://www.tidyverse.org/

#Extract required reddit links using this command in this case i am searching for "kingston" 
# Number of pages to be searched for the given term is 2 in this case
#Adjust number of pages based on your interest
# if looking for specific subreddit use get_reddit command
kingstonlinks <- reddit_urls(search_terms   = "kingston",page_threshold = 2)
#write into a csv or save as csv file format
write.csv(kingstonlinks,"kingstonlinks.csv")

#read the csv data
file <- read.csv("kingstonlinks.csv")

# Url with maximum number of comments
max_comurl <- file %>% filter(num_comments == max(num_comments))

# download url content of max comment url from the downloaded data
url_content <- reddit_content(max_comurl$URL, wait_time = 2)
write.csv(url_content$comment, "comment_cont.csv", row.names = FALSE)
file2<-read.csv("comment_cont.csv")
