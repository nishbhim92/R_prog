### libraries
library(wordcloud)
library(RColorBrewer)
library(plyr)
## library for text manipulation
library(tm)
#read data from 
tweets <- read.csv("tweets.csv")
#create a corpus (collection of articles)
twitterCorpus <-Corpus(VectorSource(tweets$text))
inspect(twitterCorpus[1:10])
twitterCorpus<- tm_map(twitterCorpus, content_transformer(tolower))
twitterCorpus<- tm_map(twitterCorpus,removeWords,stopwords("en"))
twitterCorpus<- tm_map( twitterCorpus,removeNumbers)
twitterCorpus<- tm_map( twitterCorpus,removePunctuation)

removeURL<- function(x) gsub("http[[:alnum:]]*", "", x)   
twitterCorpus<- tm_map(twitterCorpus,content_transformer(removeURL))

removeURL<- function(x) gsub("edua[[:alnum:]]*", "", x)   
twitterCorpus<- tm_map(twitterCorpus,content_transformer(removeURL))
# remove non "American standard code for information interchange (curly quotes and ellipsis)"
#  using function from package "textclean"            
removeNonAscii<-function(x) textclean::replace_non_ascii(x) 
twitterCorpus<-tm_map(twitterCorpus,content_transformer(removeNonAscii))
twitterCorpus<- tm_map(twitterCorpus,removeWords,c("amp","ufef",
                                                   "ufeft","uufefuufefuufef","uufef","s"))  
twitterCorpus<- tm_map(twitterCorpus,stripWhitespace)

inspect(twitterCorpus[1:10])

tc_tdm <- TermDocumentMatrix(twitterCorpus)
tc_m <- as.matrix(tc_tdm)
#dimensions
dim(tc_m)
#sorts and shows which words come up most
tc_sort <- sort(rowSums(tc_m),decreasing = TRUE)
#create a dataframe
tc_d <- data.frame(word=names(tc_sort),freq=tc_sort)

#wordcloud
pal2 <- brewer.pal(8,"Dark2")
png("ico.png", width = 1920, height = 1080)
  wordcloud(tc_d$word,tc_d$freq,scale = c(8,2),min.freq = 3,
            max.words = Inf,random.order = FALSE,rot.per = 15, colors = pal2)
  
  dev.off()
  
  
  
  
  
  
  
  stop = "STOP"