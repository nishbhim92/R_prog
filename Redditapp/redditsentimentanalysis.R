
#Install R and R studio 
# https://cran.r-project.org/bin/windows/base/
# https://www.rstudio.com/products/rstudio/download/ 

#Working directory, set your working directory path and app name using setwd
#setwd("C:/Users/####/####/Redditapp/") or your preferred path

#install RedditExtractor,tm,syuzhet using 
#install.packages(RedditExtractoR") for first time use
library("RedditExtractoR") #load RedditExtractor app
# https://cran.r-project.org/web/packages/RedditExtractoR/RedditExtractoR.pdf

library("tm") # tm is text mining library
# https://cran.r-project.org/web/packages/tm/tm.pdf

library("syuzhet") #syuzhet is an sentiment analysis library
# https://cran.r-project.org/web/packages/syuzhet/vignettes/syuzhet-vignette.html

library("igraph") #Network analysis library
# https://igraph.org/r/
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


# Network analysis of individual urls from the downloaded data
# download url content of url 1 from the downloaded data
url_content <- reddit_content(max_comurl$URL, wait_time = 2)
write.csv(url_content$comment, "comment_cont.csv", row.names = FALSE)
file2<-read.csv("comment_cont.csv")


###########################################################################################
# Text mining and sentiment analysis of reddit comment data
#Clean up data of titles:
#Corpus is collection of texts
RedditCorpus <- Corpus(VectorSource(file2$x))
#display 1 to 10 tweets
inspect(RedditCorpus[1:10])
# convert the texts to lowetcase
RedditCorpus<- tm_map(RedditCorpus, content_transformer(tolower))
#remove stopwords such as and, the etc., language english
RedditCorpus<- tm_map(RedditCorpus,removeWords,stopwords("en"))
#remove numbers from tweets
RedditCorpus<- tm_map( RedditCorpus,removeNumbers)
#remove punctuations 
RedditCorpus<- tm_map( RedditCorpus,removePunctuation)
#remove http urls 
removeURL<- function(x) gsub("http[[:alnum:]]*", "", x)   
RedditCorpus<- tm_map(RedditCorpus,content_transformer(removeURL))
#remove remaining http functions
removeURL<- function(x) gsub("edua[[:alnum:]]*", "", x)   
RedditCorpus<- tm_map(RedditCorpus,content_transformer(removeURL))
# remove non "American standard code for information interchange (curly quotes and ellipsis)"
#  using function from package "textclean"            
removeNonAscii<-function(x) textclean::replace_non_ascii(x) 
RedditCorpus<-tm_map(RedditCorpus,content_transformer(removeNonAscii))
#remove some non essential words
RedditCorpus<- tm_map(RedditCorpus,removeWords,c("amp","ufef",
                                                 "ufeft","uufefuufefuufef","uufef","s"))  
#remove white space
RedditCorpus<- tm_map(RedditCorpus,stripWhitespace)
# Now inspect the cleaned titles
inspect(RedditCorpus[1:10])



#Sentiment analysis:
# find count of 8 emotions
emotions<-get_nrc_sentiment(RedditCorpus$content)
barplot(colSums(emotions),cex.names = .7,
        col = rainbow(10),
        main = "Sentiment scores for Reddit titles"
)


# sentiment positive rating
get_sentiment(RedditCorpus$content[1:10])
sent<-get_sentiment(RedditCorpus$content)
# mean of sentiment positive score
meanSent<-mean(sent)

#display the mean of Reddit titles sentiment score
meanSent
##################################################################################################################
