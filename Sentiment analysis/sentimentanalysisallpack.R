#Set working directory
setwd("C:/")

#read the data
ICOtweets <- read.csv("ABCXYZ.csv")




###### Clean up data:
#install.packages("tm")
#load text mining librabry 
#tm is text mining library
library("tm") 



#Corpus is collection of texts
twitterCorpus <- Corpus(VectorSource(ICOtweets$text))

#display 1 to 10 tweets
inspect(twitterCorpus[1:10])

# convert the texts to lowercase
twitterCorpus <- tm_map(twitterCorpus, content_transformer(tolower))

#remove stopwords such as and, the etc., language english
twitterCorpus <- tm_map(twitterCorpus,removeWords,stopwords("en"))

#remove numbers from tweets
twitterCorpus <- tm_map( twitterCorpus,removeNumbers)

#remove punctuations 
twitterCorpus <- tm_map( twitterCorpus,removePunctuation)

#remove http urls 
removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)   
twitterCorpus <- tm_map(twitterCorpus,content_transformer(removeURL))

#remove remaining http functions
removeURL <- function(x) gsub("edua[[:alnum:]]*", "", x)   
twitterCorpus <- tm_map(twitterCorpus,content_transformer(removeURL))

# remove non "American standard code for information interchange (curly quotes and ellipsis)"
#  using function from package "textclean"            
removeNonAscii <- function(x) textclean::replace_non_ascii(x) 
twitterCorpus <- tm_map(twitterCorpus,content_transformer(removeNonAscii))

#remove some non essential words
#please include non essential words based on your requirement
twitterCorpus <- tm_map(twitterCorpus,removeWords,c("amp","rt","ufef",
                                                   "ufeft","uufefuufefuufef","uufef","s"))  
#remove white space
twitterCorpus <- tm_map(twitterCorpus,stripWhitespace)

# Now inspect the cleaned tweets
inspect(twitterCorpus[1:10])


#########Sentiment analysis:

#syuzhet is an sentiment analysis library contains dictionaries syuzhet, bing, afinn and nrc
#syuzhet is default dictionary
#install.packages("syuzhet")


library("syuzhet")


# find count of 8 emotions
emotions <- get_nrc_sentiment(twitterCorpus$content)
anger <- mean(emotions$anger)
anticipation <- mean(emotions$anticipation)
disgust <- mean(emotions$disgust)
fear <- mean(emotions$fear)
joy <- mean(emotions$joy)
sadness <- mean(emotions$sadness)
surprise <- mean(emotions$surprise)
trust <- mean(emotions$trust)
positive <- mean(emotions$positive)
negative <- mean(emotions$negative)


# sentiment positiviy rating
get_sentiment(twitterCorpus$content[1:10])

##afinn dictionary
afinn_sent<-get_sentiment(twitterCorpus$content,method="afinn")

##bing dictionary
bing_sent <- get_sentiment(twitterCorpus$content,method = "bing")

##nrc dictionary
nrc_sent <- get_sentiment(twitterCorpus$content,method = "nrc")

##syuzhet dictionary
syuzhet_sent <- get_sentiment(twitterCorpus$content, method = "syuzhet")
#sentimentTweets<-dplyr::bind_cols(ICOtweets,data.frame(sent))

# mean of sentiment positivity
afinn <- mean(afinn_sent)
bing <- mean(bing_sent)
nrc <- mean(nrc_sent)
syuzhet <- mean(syuzhet_sent)


## sentimentr dictionary uses a different package

#install.packages("sentimentr")
#load the library

library("sentimentr")

senti1 <- get_sentences(twitterCorpus$content)

#get sentiment scores

sentiscore<-sentiment(senti1)

##sentiment score
sentimentrsentiment <- mean(sentiscore$sentiment)

## display scores

cat("syuzhet\t",syuzhet,"\n")
cat("afinn\t",afinn,"\n")
cat("bing\t",bing,"\n")
cat("nrc\t",nrc,"\n")
cat("sentimentrsentiment\t",sentimentrsentiment,"\n")
cat("anger\t",anger,"\n")
cat("anticipation\t",anticipation,"\n")
cat("disgust\t",disgust,"\n")
cat("fear\t",fear,"\n")
cat("joy\t",joy,"\n")
cat("sadness\t",sadness,"\n")
cat("surprise\t",surprise,"\n")
cat("trust\t",trust,"\n")
cat("positive\t",positive,"\n")
cat("negative\t",negative,"\n")

# save the scores in dataframe
score <- tibble(a,syuzhet,afinn,bing,nrc,sentimentrsentiment,anger,anticipation,disgust,fear,joy,sadness,surprise,trust,positive,negative)

#copy the dataframe to clipboard to paste in excel
write.table(score, "clipboard", sep="\t", row.names=FALSE, col.names=FALSE)
