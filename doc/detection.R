
### load required packages
library(ngram)
library(NLP)
library(tm)
library(purrr)
library(qdap) # 
# library(reshape2)

### please change the working directory to the folder containing this file
setwd("/Users/hongru/Documents/GitHub/Fall2018-Project4-sec1proj4_grp6/Github/doc")

source("../lib/bigramize.R")
source("../lib/get_text.R")

#### ground truth ##############################################################
### read files
ground_truth_dir <-"../data/ground_truth"
ground_truth_file_name <- list.files(ground_truth_dir)
ground_truth_file_path <- paste0(ground_truth_dir,'/',ground_truth_file_name)
ground_truth_onelines <- lapply(ground_truth_file_path,get_text)

### clean the texts and sort the words by letter length
ground_truth_words_cleaned <- unlist(lapply(ground_truth_onelines,clean_text))
ground_truth_by_length <- sort_by_length(ground_truth_words_cleaned)

### bigramize the word from word length >= 3
### should be modified to include word length <= 2
num_len <- length(ground_truth_by_length)
ground_truth_bigram_from3 <- lapply(ground_truth_by_length[3:num_len],bigramize)
save(ground_truth_bigram_from3,file="../output/ground_truth_bigram_from3.Rdata")
# load("../output/ground_truth_bigram_from3.Rdata")
### romove duplicate bigrams
ground_truth_unibig_from3 <- lapply(ground_truth_bigram_from3,unique_bigram)
save(ground_truth_unibig_from3,file="../output/ground_truth_bigram_from3.Rdata") ### this is the final dictionary for error detection
#load("../output/ground_truth_bigram_from3.Rdata")

### include word length <= 2
ground_truth_bigram_from3$l_1$PD_1_1<-letters
ground_truth_bigram_from3$l_2$PD_1_2 <- unique(ground_truth_by_length[[2]])


#### tesseract #################################################################
### read files
tesseract_dir <- "../data/tesseract"
tesseract_file_name <- list.files(tesseract_dir)
tesseract_file_path <- paste0(tesseract_dir,'/',tesseract_file_name)
tesseract_onelines <- lapply(tesseract_file_path,get_text)
### clean the texts
tesseract_words_cleaned <- lapply(tesseract_onelines,clean_text)
save(tesseract_words_cleaned,file="../output/tesseract_words_cleaned.Rdata")
# load("../output/ground_truth_words_cleaned.Rdata")


#### error detection ###########################################################
### these codes will be convert to a function later.
tesseract_labels <- list()
for (i in 1:length(tesseract_words_cleaned)) {
  cat("current file number =",i,"\n")
  cur_tesseract <- tesseract_words_cleaned[[i]]
  # cur_file <- tesseract_words_cleaned[[i]]
  cur_labels <- c()
  for (j in 1:length(cur_tesseract)) {
    cur_word <- cur_tesseract[j]
    cur_length <- nchar(cur_word)
    cur_bigram <- bigramize_word(cur_word)
    cur_dic <- ground_truth_unibig_from3[[paste("l_",cur_length,sep="")]]
    tmp_lable <- c()
    # browser()
    for (k in 1:length(cur_bigram)){
      tmp_lable[k] <- cur_bigram[[k]]%in%cur_dic[[k]]
    }
    cur_tmp_lable <- as.numeric(sum(tmp_lable)==length(cur_bigram))
    cur_labels[j] <- cur_tmp_lable
  }
  tesseract_labels[[i]] <- cur_labels
}

error_rate <- 1-(sapply(tesseract_labels, sum)/sapply(tesseract_words_cleaned, length))
summary(error_rate)
   
save(tesseract_labels,file="../output/tesseract_labels.Rdata")


detected_words<-list()
for(i in 1:100){
  detected_words[[i]]<-tesseract_words_cleaned[[i]][!as.logical(tesseract_labels[[i]])]
}
save(detected_words,file="detected_words.Rdata")





