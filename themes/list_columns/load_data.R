# 
# ## Data gathering
# The data used in this presentation has been constructed from the interactive database tool hosted at: http://data.euro.who.int/cisid/ 
#   A selection was made for all available countries and all avaialable years, for the number of cases reported to the WHO for Whooping Cough - __Bordetella pertussis__ - infections.
# The file is available in CSV format in `./data/CISID_pertussis_10082018.csv`
# 
# ## Data characteristics
# 
# - The first few lines of the file have comments indicated with `#`
# - There are 53 countries in the dataset
# - There is data from 1991 to 2013 
# - The data is not in `tidy` format
# - Missing values are indicated with _`NA`_
# 
# ## **Discuss with your neighbour**
# 
# - What makes this data untidy?
#   - Why is it not a good idea to have a column name starting with a digit?
#   
# 



## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, 
                      warning = FALSE, 
                      message = FALSE, 
                      error = FALSE, 
                          fig.width = 6,
                          fig.height = 8)

## ---- root, include=FALSE------------------------------------------------
#require("rprojroot") || utils::install.packages("rprojroot")
#library(rprojroot)
#root <- find_root_file(criterion = is_rstudio_project)


## ---- echo=FALSE, dpi=200------------------------------------------------
#knitr::include_graphics(path = file.path(root,
#                                         "images",
#                                         "open_compaq.jpg"))

## ---- packages-----------------------------------------------------------
library(tidyverse)
library(modelr)
library(lubridate)
library(broom)

## ---- read_data----------------------------------------------------------
pertussis_data <- read_csv(
  file = file.path("data", 
                   "CISID_pertussis_10082018.csv"),
  comment = "#", 
  n_max = 53, 
  na = c("", " ")
  )

## ---- inspect_data-------------------------------------------------------
head(pertussis_data, n = 2)
names(pertussis_data)

## ------------------------------------------------------------------------
source(file = file.path("R",
                        "do_tidy_pertussis.R"))



