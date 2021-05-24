
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
library(ids)

# getting the path of your current open file
current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path))
setwd("../data/")

# load in data
df2008 <- tibble(read.csv("scopus_2008.csv"))
df2009 <- tibble(read.csv("scopus_2009.csv"))
df2018 <- tibble(read.csv("scopus_2018.csv"))
df2019 <- tibble(read.csv("scopus_2019.csv"))

# load in journal data from scopus
codes <- tibble(read.csv("../misc/scopus-journal-list-download/Scopus Sources October 2020-Table 1.csv"))
code_names <- tibble(read.csv("../misc/asjc-classification-codes.csv"))


# merge dfs
df <- rbind(df2008,df2009,df2018,df2019)


## Check and subset-------------------------------------------------------------

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

# randomly sample 500 papers for each subset
df_pre[sample(nrow(df_pre), 500), ]$sample  <- 1:500
df_post[sample(nrow(df_post), 500), ]$sample  <- 501:1000

# merge
df_final <- full_join(df_pre, df_post)

# indicate pilot vs. critical papers (16 from each time subset)
df_final$data_type <- ifelse(df_final$sample %in% (485:516), "pilot", 
                             ifelse(df_final$sample == 0, "NA", "critical"))

# create unique identifier
df_final$ID <- ids::random_id(nrow(df_final), 4)

# double check whether unique
length(unique(df_final$ID)) == length(df_final$ID)

# add column with clickable DOI
df_final$clickable_doi <- paste0("http://doi.org/", df_final$DOI)

# get number of hits per journal
df_final %>%
  filter(data_type == "critical") %>% 
  select(Source.title) %>% 
  group_by(Source.title) %>% 
  summarise(sum = n()) %>% 
  arrange(desc(sum))

# create coders
coders <- c("TR", "CH", "LK", "MR", "KM", "JC", "EB", "AB")

# sample each coder 3 times
coders_sample <- sample(coders, 8, replace = F)

# assign half to pre-crisis and post-crisis
df_final$coder <- "none"
df_final[df_final$data_type == "pilot" & df_final$subset == "pre-crisis",]$coder <- c(coders_sample, coders_sample)
df_final[df_final$data_type == "pilot" & df_final$subset == "post-crisis",]$coder <- c(coders_sample, coders_sample)


# extract and store pilot I (all PIs checking four papers)
pilot_list  <- df_final %>% 
  filter(data_type == "pilot") %>% 
  select(coder, ID, Authors, Title, Year, Source.title, Volume, Issue, DOI) %>% 
  arrange(coder)


# extract and store prescreening pilot II 
# (students checking whether identification of language papers can be done quickly)
prescreening_list  <- df_final %>% 
  filter(data_type == "critical") %>% 
  select(ID, Authors, Title, Year, Source.title, Volume, Issue, clickable_doi) 


# write to table
write.table(pilot_list, file = "pilot_list.txt", sep = "\t",
            row.names = FALSE)

write.table(prescreening_list, file = "prescreening_list.txt", sep = "\t",
            row.names = FALSE)



## Merge with Scopus journal code-----------------------------------------------

codes_detail <- codes %>% 
  # select relevant cols and rename
  select(Source.Title..Medline.sourced.journals.are.indicated.in.Green.,
         All.Science.Journal.Classification.Codes..ASJC.
         ) %>% 
  rename(Source.title = 'Source.Title..Medline.sourced.journals.are.indicated.in.Green.',
         Asjc.code = 'All.Science.Journal.Classification.Codes..ASJC.') %>% 
  # only extract those journals that we find in our data base
  filter(Source.title %in% unique(df_final$Source.title)) %>% 
  # seperate multiple entries
  separate(Asjc.code, into = c("1","2","3","4","5","6","7","8"), sep = ";") %>% 
  # make numeric
   mutate_at(c("1","2","3","4","5","6","7","8"), as.numeric) %>% 
  # into long format
  pivot_longer(cols = 2:9, names_to = "Dummy", values_to = "Code") %>% 
  # join with code_names
  full_join(code_names) %>% 
  # now delete Dummy, Code and Description and make wide according to supercode
  select(-Dummy, -Description, -Code) %>% 
  drop_na() %>% 
  mutate(dummy = 1) %>% 
  distinct() %>% 
  pivot_wider(names_from = Supergroup, values_from = dummy)

# define colnames
colnms <- colnames(codes_detail[,2:18])

# summarize supergroups over journals
colSums(codes_detail[,colnms], na.rm = TRUE)
  
# merge df_final with codes_detail
df_final_codes <- df_final %>% 
  full_join(codes_detail)

# summarize supergroups over articles
round(colSums(df_final_codes[,colnms], na.rm = TRUE) / nrow(df_final_codes), 2)


