##############################################################
##############################################################
##############################################################

### Project 4 Group 7

get_text <- function(file_path) {
  text_lines <- readLines(file_path, warn=FALSE, encoding = "UTF-8")
  text_oneline <- paste0(text_lines, collapse = " ")
  #text_words <- unlist(strsplit(text_oneline," "))
  return(text_oneline)
  #return(text_words)
}  

clean_text <- function(oneline) {
  cleaned_oneline <- clean(oneline)
  matches <- gregexpr("[^A-Za-z[:space:]]",cleaned_oneline)
  regmatches(cleaned_oneline,matches) <- ''
  corpus <- VCorpus(VectorSource(cleaned_oneline))%>%
    tm_map(content_transformer(tolower))%>%
    #tm_map(removePunctuation)%>%
    #tm_map(removeNumbers)%>%
    tm_map(removeWords, character(0))%>%
    tm_map(stripWhitespace)
  cleaned_oneline <- corpus[[1]][[1]]
  if (substr(cleaned_oneline,1,1)==" ") {
    cleaned_oneline <- substring(cleaned_oneline, 2)
  }
  text_word <- unlist(strsplit(cleaned_oneline," "))
  return(text_word)
}

sort_by_length <- function(words) {
  text_word_length <- sapply(words, nchar)
  k <- 0
  text_by_length <- list()
  len <- c()
  for (i in levels(factor(text_word_length))) {
    k <- k+1
    len[k] <- i
    text_by_length[[k]] <- words[text_word_length==i]
  }
  names(text_by_length) <- paste0("l_",len)
  return(text_by_length)
}