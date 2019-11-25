# 
# 
# Author: Jonathan de Bruin
# Project: Trump tweets
# Creation date: 2019-10-27
# Modification date: 2019-10-27
# 
# Description: Helper script to generate the dataset
# 
# Based on https://towardsdatascience.com/random-forest-text-classification-trump-v-obama-c09f947173dc

library(tidyverse)
library(rvest)

speeches <- lapply(paste0('https://www.presidency.ucsb.edu/documents/the-presidents-weekly-address-', 251:451), function(url){
  url %>% read_html() %>%
    html_nodes(".field-docs-content") %>%
    html_text()
})
name <- lapply(paste0('https://www.presidency.ucsb.edu/documents/the-presidents-weekly-address-', 251:451), function(url){
  url %>% read_html() %>%
    html_nodes(".diet-title") %>%
    html_text()
})
date <- lapply(paste0('https://www.presidency.ucsb.edu/documents/the-presidents-weekly-address-', 251:451), function(url){
  url %>% read_html() %>%
    html_nodes(".date-display-single") %>%
    html_text()
})


# combine lists into data frame
speech_data <- do.call(rbind, Map(data.frame, id=251:451, date=date, name=name, speech=speeches))
# split data into Trump and Obama
obama_speeches <- subset(speech_data, speech_data$name == 'Barack Obama')
trump_speeches <- subset(speech_data, speech_data$name == 'Donald J. Trump')

write_csv(speech_data, "data/speeches.csv")
