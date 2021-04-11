#readdata
tweets<-read.csv("btweets.csv")
library("tm") 
# tm is text mining library
#Clean up data:
#Corpus is collection of texts
twitterCorpus <-Corpus(VectorSource(tweets$text))
#display 1 to 10 tweets
inspect(twitterCorpus[1:10])
# convert the texts to lowetcase
twitterCorpus<- tm_map(twitterCorpus, content_transformer(tolower))
#remove stopwords such as and, the etc., language english
twitterCorpus<- tm_map(twitterCorpus,removeWords,stopwords("en"))
#remove numbers from tweets
twitterCorpus<- tm_map( twitterCorpus,removeNumbers)
#remove punctuations 
twitterCorpus<- tm_map( twitterCorpus,removePunctuation)
#remove http urls 
removeURL<- function(x) gsub("http[[:alnum:]]*", "", x)   
twitterCorpus<- tm_map(twitterCorpus,content_transformer(removeURL))
#remove remaining http functions
removeURL<- function(x) gsub("edua[[:alnum:]]*", "", x)   
twitterCorpus<- tm_map(twitterCorpus,content_transformer(removeURL))
# remove non "American standard code for information interchange (curly quotes and ellipsis)"
#  using function from package "textclean"            
removeNonAscii<-function(x) textclean::replace_non_ascii(x) 
twitterCorpus<-tm_map(twitterCorpus,content_transformer(removeNonAscii))
#remove some non essential words
twitterCorpus<- tm_map(twitterCorpus,removeWords,c("amp","ufef",
                                                   "ufeft","uufefuufefuufef","uufef","s"))  
#remove white space
twitterCorpus<- tm_map(twitterCorpus,stripWhitespace)

# Now inspect the cleaned tweets
inspect(twitterCorpus[1:10])

#Sentiment analysis:
#syuzhet is an sentiment analysis library
library("syuzhet")

# find count of 8 emotions
emotions<-get_nrc_sentiment(twitterCorpus$content)
barplot(colSums(emotions),cex.names = .7,
        col = rainbow(10),
        main = "Sentiment scores for tweets"
)

# sentiment positiviy rating
get_sentiment(twitterCorpus$content[1:10])
sent<-get_sentiment(twitterCorpus$content)
sentimentTweets<-dplyr::bind_cols(tweets,data.frame(sent))

# mean of sentiment positivity
meanSent<-mean(sentimentTweets$sent)

#display the mean of 10000 tweets 
meanSent

