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
  Replaces1 <- function(word, range) {
    N <- nchar(word) 
    out <- list()
    for (letter in letters) {
      out[[letter]] <- rep(word, N)
      for (i in range) {
        substr(out[[letter]][i], i, i) <- letter
      }
    }
    out <- unique(unlist(out))
    return(out)
  }
  
  # Edits zero, one or two letters away from "word"
  Replaces2 <- function(word) {
    N <- nchar(word)
    word.new <- Replaces1(word, 1:N)
    out <- lapply(word.new, Replaces1,
                  which(unlist(strsplit(word,"")) %in% unlist(strsplit(word.new,""))))
    out <- unique(unlist(out))
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
    prob <- count/N
    return(prob)
  }
  
  # Output function
  Output <- function(word, known_words, word_ct){
    candidates <- Candidates(word, known_words)
    if(length(candidates) > 0){
      probabilities <- sapply(candidates, Probability, known_words, word_ct)
    }
    else{
      probabilities <- 1
      names(probabilities) <- word
    }
  return(probabilities)
  }
    
  # Final output
  return(Output(word, data$word, data$count))
}
