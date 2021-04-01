
############
### Info ###
############
#
## Authors:     Timo Roettger (timo.b.roettger @ gmail.com)
#
## Project:     Transparency in Linguistics
#          
## Description: Exploring the scopus output
#
## Date edited: 2021-04-01
#
#-------------------------------------------------------------------------------



## Set-up & preprocessing--------------------------------------------------------

# libraries
library(rstudioapi)
library(tidyverse)

# getting the path of your current open file
current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path))
setwd("../data/")

# load in data
df <- tibble(read.csv("scopus_dummy.csv"))

# check journals
unique(df$Source.title)

# get number of hits per journal
df_hits <- df %>%
  group_by(Source.title) %>% 
  summarise(sum = n()) %>% 
  arrange(desc(sum))

print(df_hits, n = 20)

