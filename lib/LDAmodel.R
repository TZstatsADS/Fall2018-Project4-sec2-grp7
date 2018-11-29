########################
# LDA Model with 5 topics
########################

LDA_MODEL<-function(text){
  the_path = '../data/ground_truth/'
  filenames <- list.files(path = the_path, pattern="*.txt")
  #Remove punctuation - replace punctuation marks with " "
  docs <- tm_map(text, removePunctuation)
  #Transform to lower case
  docs <- tm_map(docs,content_transformer(tolower))
  #Strip digits
  docs <- tm_map(docs, removeNumbers)
  #Remove stopwords from standard stopword list 
  docs <- tm_map(docs, removeWords, stopwords("english"))
  #Strip whitespace (cosmetic?)
  docs <- tm_map(docs, stripWhitespace)
  #Stem document to ensure words that have same meaning or different verb forms of the same word arent duplicated 
  docs <- tm_map(docs,stemDocument)
  #Create document-term matrix
  dtm <- DocumentTermMatrix(docs)
  rownames(dtm) <- filenames
  
  
  #Load Topic models
  library(topicmodels)
  #Run Latent Dirichlet Allocation (LDA) using Gibbs Sampling
  #set burn in
  burnin <-1000
  #set iterations
  iter<-2000
  #thin the spaces between samples
  thin <- 500
  #set random starts at 5
  nstart <-5
  #use random integers as seed 
  seed <- list(254672,109,122887,145629037,2)
  # return the highest probability as the result
  best <-TRUE
  #set number of topics 
  k <-5
  #run the LDA model
  ldaOut <- LDA(dtm,k, method="Gibbs", control=list(nstart=nstart, seed = seed, best=best, burnin = burnin, iter = iter, thin=thin))
  
  # Final Result
  termprob<-as.matrix(posterior(ldaOut)$terms)
  Words<-apply(termprob,2,sum)
  return(Words)
}
  
