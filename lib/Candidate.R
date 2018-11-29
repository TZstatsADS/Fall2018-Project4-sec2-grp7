########################
# Candidate Model
########################

Candidate_best<- function(a){

  ## Choose candidate list
  candidate<-function(a){
    
    unique_truth<-lapply(dic,unique)
    N<-nchar(a)
    raw_list<- unlist(unique_truth[N])
    names(raw_list)<-NULL
    
    vec<-raw_list
    names(vec)<-NULL
    numbers<-vector()
    if (length(vec) == 0){
      return("")
    }
    for(i in 1:length(vec)){
      b<-vec[i]
      numbers[i]<-sum(strsplit(c(a, b), split = "")[[1]]!=strsplit(c(a, b), split = "")[[2]])}
    
    final_list<-vec[numbers<=2]
    return(final_list)
    
  }
  
  
  ## Choose best candidate
  best_candidate <- function(word, candidates){
  	
    words_candidate_score <- list()
    word_len <- nchar(word)
    if (length(candidate(word)) == 0){
      return(list("best" = word, "candidate_score" = words_candidate_score))
    }
    for (candidate in candidates){
      if (!candidate %in% words_topic){
        words_candidate_score[[candidate]] = 0
      }
      else{
        score = words_pro[[candidate]]
        for(i in 1:word_len){
          word_char <- unlist(strsplit(word,"")) 
          candidate_char <- unlist(strsplit(candidate,""))
          if(word_char[i] != candidate_char[i]){
            score = score*prob[word_char[i],candidate_char[i]]
          }
        }
        words_candidate_score[[candidate]] = score
      }
    }
    if (max(unlist(words_candidate_score)) == 0){
      return(list("best" = word, "candidate_score" = words_candidate_score))
    }
    else{
      return(list("best" = names(words_candidate_score[which.max(unlist(words_candidate_score))]), "candidate_score" = words_candidate_score))
    }
  }
  
  return(best_candidate(a,candidate(a)))
}


#best_candidate(word="mast",candidates=c("must", "mask"))$best