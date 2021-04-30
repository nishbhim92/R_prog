#set the working directory where the pdf files or located
setwd("C################")

#install.packages("pdftools")
library(pdftools)
#install.packages("purrr")
library(purrr)
#install.packages("tm")
library("tm")


#list all the files with pdf extension and store

file_list <- list.files(".", full.names = TRUE, pattern = '.pdf$')

s_pdf_text <- safely(pdf_text) # helps catch errors

walk(file_list, ~{                                     # iterate over the files
  
  res <- s_pdf_text(.x)                                # try to read it in
  if (!is.null(res$result)) {                          # if successful
    
    message(sprintf("Processing [%s]", .x))
    
    txt_file <- sprintf("%stxt", sub("pdf$", "", .x))  # make a new filename
    
    unlist(res$result) %>%                             # cld be > 1 pg (which makes a list)
      tolower() %>%                                    
      paste0(collapse="\n") %>%                        # make one big text block with line breaks
      cat(file=txt_file)                               # write it out
    
  } else {                                             # if not successful
    message(sprintf("Failure converting [%s]", .x))    # show a message
  }
  
})

#store all the .txt files
all.the.data <- list.files(pattern = "txt$")

#make a corpus of files

corp <- Corpus(URISource(all.the.data))
corp <- tm_map(corp, removePunctuation, ucp = TRUE)
#make a term document matrix
opinions.tdm <- TermDocumentMatrix(corp, 
                                   control = 
                                     list(removePunctuation = TRUE,
                                          stopwords = TRUE,
                                          tolower = TRUE,
                                          stemming = TRUE,
                                          removeNumbers = TRUE,
                                          bounds = list(global = c(3, Inf)))) 

#inspect files
inspect(opinions.tdm[1:10,]) 
# find frequent terms with low frequenct 100
findFreqTerms(opinions.tdm, lowfreq = 100, highfreq = Inf)

# find frequent terms with low frequenct 500 and store
ft <- findFreqTerms(opinions.tdm, lowfreq = 500, highfreq = Inf)
as.matrix(opinions.tdm[ft,]) 
ft.tdm <- as.matrix(opinions.tdm[ft,])

# sort the terms by frequency
sort(apply(ft.tdm, 1, sum), decreasing = TRUE)

