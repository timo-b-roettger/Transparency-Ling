
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
df2008 <- tibble(read.csv("scopus_2008.csv"))
df2009 <- tibble(read.csv("scopus_2009.csv"))
df2018 <- tibble(read.csv("scopus_2018.csv"))
df2019 <- tibble(read.csv("scopus_2019.csv"))

# merge dfs
df <- rbind(df2008,df2009,df2018,df2019)

# check journals
unique(df$Source.title)

# get number of hits per journal
df_hits <- df %>%
  group_by(Source.title, Year) %>% 
  summarise(sum = n()) %>% 
  arrange(desc(sum))

print(df_hits, n = 20)

# set random seed
set.seed(999)

# create sample vector (1 = in sample, 0 = out of sample)
df$sample = 0

# subset data into pre-crisis and post-crisis
df$subset <- ifelse(df$Year %in% c(2008, 2009), "pre-crisis", "post-crisis")

df_pre <- df %>% 
  filter(subset == "pre-crisis")

df_post <- df %>% 
  filter(subset == "post-crisis")

# randomly sample 250 papers for each subset (plus 20 for pilot)
df_pre[sample(nrow(df_pre), 260), ]$sample  <- 1:260
df_post[sample(nrow(df_post), 260), ]$sample  <- 1:260

# merge
df_final <- full_join(df_pre, df_post)

# indicate pilot vs. critical papers
df_final$data_type <- ifelse(df_final$sample >= 251, "pilot", 
                             ifelse(df_final$sample == 0, "NA", "critical"))


