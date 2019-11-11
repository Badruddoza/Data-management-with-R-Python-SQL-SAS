# string parsing 
rm(list=ls())

pangram<-"The quick brown fox jumps over the lazy dog"
pangram
splitted<-strsplit(pangram, " ")[[1]]
splitted
unique(tolower(splitted))