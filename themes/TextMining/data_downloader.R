# 
# 
# Author: Jonathan de Bruin
# Project: Trump tweets
# Creation date: 2019-10-27
# Modification date: 2019-10-27
# 
# Description: Helper script to generate the dataset
#

library(tidyverse)

download.file(
  "https://github.com/mkearney/trumptweets/blob/master/data/trumptweets-1515775693.rds?raw=true",
  "data/trumptweets-1515775693.rds"
)

trump_tweets = read_rds(
  "data/trumptweets-1515775693.rds"
) %>% filter(!is_quote & !is_retweet)

write_csv(
  trump_tweets[, c(1,2,5, 13, 14)], 
  "data/trumptweets-1515775693.csv"
)
