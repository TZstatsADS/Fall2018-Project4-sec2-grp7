########################
# OCR Model
########################

OCR_model <- function(word, data){

  # This is a text processing function borrowed from a 
  # CMU Data mining course professor
  strip.text <- function(txt) {
    # remove apostrophes
    txt <- gsub("'","",txt)
    # convert to lowercase
    txt <- tolower(txt)
    # change other non-alphanumeric characters to spaces
    txt <- gsub("[^a-z0-9]"," ",txt)
    # change digits to #
    txt <- gsub("[0-9]+"," ",txt)
    # split and make one vector
    txt <- unlist(strsplit(txt," "))
    # remove empty words
    txt <- txt[txt != ""]
    return(txt)
  }
  
  # Edits zero or one letter away from "word"
  Replaces1 <- function(word = FALSE) {
    N <- nchar(word) 
    out <- list()
    for (letter in letters) {
      out[[letter]] <- rep(word, N)
      for (i in 1:N) {
        out[[letter]][i] <- sub(substr(word,i,i),letter, word)
      }
    }
    out <- unique(unlist(out))
    return(out)
  }
  
  # Edits zero, one or two letters away from "word"
  Replaces2 <- function(word = FALSE) {
    N <- nchar(word) 
    out <- c()
    word.new <- Replaces1(word)
    for(w in word.new){
      for(l in letters){
        for(i in which(unlist(strsplit(word,"")) %in% unlist(strsplit(word.new,"")))){
          out <- c(out,sub(substr(word,i,i),l, w))
        }
      }
    }
    out <- unique(out)
    return(out)
  }
  
  # Words found in corpus
  Known <- function(word, known_words){
    out <- ifelse(word%in%known_words,word,NA)
    out <- out[!is.na(out)]
    return(out)
  }
  
  # Possible corrections based on known words
  Candidates <- function(word, known_words){
    return(Known(Replaces2(word),known_words))
  }
  
  # Probability as determined by our corpus.
  Probability <- function(word, known_words, word_ct) {
    N <- sum(word_ct)
    word.number <- which(known_words == word)
    count <- word_ct[word.number]
    pval <- count/N
    return(pval)
  }
  
  # Output function
  Output <- function(word, known_words, word_ct){
    candidates <- Candidates(word, known_words)
    probabilities <- sapply(candidates, Probability, known_words, word_ct)
  return(probabilities)
  }
    
  # Final output
  return(Output(word, data$word, data$count))
}
