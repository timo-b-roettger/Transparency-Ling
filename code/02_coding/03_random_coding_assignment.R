# Coding for prescreening -----------------------------------------------------
#
# Author: Joseph V. Casillas
# Last update: 20220212
#
# WORKFLOW
# - Import google doc (downloaded for consistency)
# - Create 'coder' column
# - Evenly distribute coder names in list (120 per coder, 60 for each year_split)
# - Export as github issue with clickable cells
#
# -----------------------------------------------------------------------------

# Setup -----------------------------------------------------------------------

# libraries
library("tidyverse")
library("googlesheets4")
library("here")
library("glue")
library("clipr")
library(rio)

# -----------------------------------------------------------------------------

# Import ----------------------------------------------------------------------

# Get sheets
# my_url <- "OLD LINK"
# 
# # Load data into R
# coder_pre_s <- read_sheet(my_url) %>% 
#   mutate(ID = as.character(ID))

# get new doc
coder_pre_s <- import("../../data/02_coding/google_doc_prescreen.xlsx") %>% 
  mutate(ID = as.character(ID))

# Take a look to see if it worked
glimpse(coder_pre_s)

# Save to .csv
file_tag  <- "cooder_prescreen_backup"                # store file prefix
file_date <- format(Sys.time(), "%Y_%m_%d")           # store data date
file_name <- paste0(file_tag, "_", file_date, ".csv") # store filename

# Save as raw data backup
# write_csv(coder_pre_s, here("data", file_name))

# -----------------------------------------------------------------------------

# Assign coders ---------------------------------------------------------------

# Set seed for reproducibility
set.seed(20211021)

# Vector of coder IDs
coder_ids <- c("tr", "jc", "lk", "mr", "ab")

randomized_df <- coder_pre_s %>% 
  # Keep only relevant articles 
  filter(first_code_include == "Yes") %>% 
  # There are 309 articles in the After-OS category and 301 in the Pre-OS 
  # category so we randomly sample 300 from each without replacement
  group_by(year_split) %>% 
  slice_sample(n = 300) %>% 
  # Randomly assign 120 articles to each coder (60 per year_split) 
  group_by(year_split) %>% 
  mutate(
    new_id = 1:300, # index shuffled rows
    coder = cut(new_id, breaks = length(coder_ids), labels = coder_ids)
    ) %>% 
  ungroup()

# Check to make sure each coder has 60 articles assigned
randomized_df %>% 
  group_by(year_split, coder) %>% 
  summarize(n = n())

# Save randomized_df just in case
file_name <- paste0("randomized_prescreen_df", "_", "2021_10_21", ".csv")
write_csv(randomized_df, paste0("../../results/02_coding/", file_name))

# -----------------------------------------------------------------------------

# Generate markdown list for workflow -----------------------------------------

md_rows <- randomized_df %>% 
  select(ID, clickable_doi, Title, year_split, coder) %>% 
  arrange(coder, desc(year_split)) %>% 
  mutate(pre = "- [ ] ", 
    ID = glue("{ID}, "), 
    clickable_doi = glue("[doi]({clickable_doi}), "), 
    title_short = str_sub(Title, 1, -1), 
    Title = glue('"{title_short}", '), 
    year_split = glue("{year_split}, ")) %>% 
  transmute(
    md_row = str_c(pre, ID, clickable_doi, Title, year_split, coder)
    )

# Save markdown formatted df to the clipboard so it can be pasted 
# into github issue (https://github.com/troettge/Transparency-Ling/issues/24)
clipr::write_clip(md_rows)

# -----------------------------------------------------------------------------

# Redistribute unfinished articles --------------------------------------------

# Vector of unfinished DOIs
unfinished_dois <- c(
  "2df0bfbc", "9e72d433", "da82dbe2", "d11947e0", "7c3ee583", "c1812adb", 
  "47b9d84d", "6e7fcfb0", "eb8f30c8", "ca306313", "381dbc12", "285c0f1d", 
  "a934b552", "4ad36a28", "5367f827", "4c17af36", "26d646f0", "50db91aa", 
  "0b0540e6", "e5d2bdaf", "e20aae7a", "cd4622f8", "ce16f889", "0a0f51a8", 
  "841e4719", "2e207f82", "d1df7e5e", "3c79ea11", "fdc9d6b4", "eb87300c", 
  "96f6b2bd", "149b3172", "98e604d4", "a2127c4e", "1a481136", "3935a75c", 
  "a5d06adb", "f1d5193c", "eeeca0ab", "1332a93f", "33f02c8f", "c6c513d7", 
  "77e82f80", "832b3f5a", "aa0f2804", "ea8e6f5f", "c4724409", "49cde95b", 
  "5408749b", "10012f27", "282ef69c", "f40502c8", "1219375f", "2c58c4ee", 
  "38c5c978", "c4de8978", "2d1d51f8", "9b2649ee", "a4756719", "0f760436", 
  "51173c44", "4d4b192f", "f48a3051", "d3ebac3a", "1eb53511", "7c7843aa", 
  "34bd38f5", "d2c4f7a0", "8328c7d1", "4cc96897", "6ba0d34a", "8.86e+11", 
  "c7908485", "a1d6bec3", "6a316045", "5e677635", "327d341b", "4b6296c5", 
  "30630572", "ddf2990d", "ea632f31", "be73e73d", "04a09446", "53ecc183", 
  "036ef9f2", "28825a50", "07641c49", "84326216", "18cf4788", "d9ea6abb", 
  "07193b56", "94ea02fe", "8df4b9ae", "30a32d49", "327416ec", "0f6d23ca", 
  "62eddcdc", "8ae2627d", "dc800c82")

# Load prescreen df of randomized coders, filter out all coders except MR, 
# and keep only rows in `unfinished_dois`
# Then randomly assign 98 articles to each coder (99 / 4) 
randomized_df <- read_csv(paste0("../../data/02_coding/", "randomized_prescreen_df_2021_10_21.csv")) %>% 
  mutate(ID = as.character(ID)) %>% 
  filter(coder == "mr", ID %in% unfinished_dois) %>% 
  slice_sample(n = 99, replace = F) %>% 
  mutate(
    new_id = 1:99, # index shuffled rows
    coder = cut(new_id, breaks = length(coder_ids) - 1, labels = c("tr", "jc", "lk", "ab"))
    ) %>% 
  ungroup()

# Check to make sure each coder has 24/25 articles assigned
randomized_df %>% 
  group_by(coder) %>% 
  summarize(n = n())

# Check to make sure remaining articles match `unfinished_dois` with no 
# repeats
sum(randomized_df$ID %in% unfinished_dois) == length(unfinished_dois)
setdiff(randomized_df$ID, unfinished_dois)

# Get new markdown list
new_md_rows <- randomized_df %>% 
  select(ID, clickable_doi, Title, year_split, coder) %>% 
  arrange(coder, desc(year_split)) %>% 
  mutate(pre = "- [ ] ", 
    ID = glue("{ID}, "), 
    clickable_doi = glue("[doi]({clickable_doi}), "), 
    title_short = str_sub(Title, 1, -1), 
    Title = glue('"{title_short}", '), 
    year_split = glue("{year_split}, ")) %>% 
  transmute(
    md_row = str_c(pre, ID, clickable_doi, Title, year_split, coder)
    )

# Save markdown formatted df to the clipboard so it can be pasted 
# into github issue (https://github.com/troettge/Transparency-Ling/issues/24)
clipr::write_clip(new_md_rows)

# -----------------------------------------------------------------------------

# Randomly assign 20% to new coder --------------------------------------------
#
# - Take original dataset used to assign articles
# - By coder, filter out articles they already coded randomly select X 
#   articles from those they have not seen
# - Repeat for each coder
#

# Get coded articles before redistributing
round_1 <- read_csv(paste0("../../data/02_coding/", "randomized_prescreen_df_2021_10_21.csv")) %>% 
  filter(!(ID %in% unfinished_dois)) %>% 
  select(ID, clickable_doi, Title, year_split, coder) %>% 
  mutate(clickable_doi = glue("[doi]({clickable_doi})"))

# Get redistributed articles
round_1_5 <- read_csv(paste0("../../data/02_coding/", "redistributed_articles.csv"))


# Combine DFs to get all coded articles and corresponding coders
coded_articles <- bind_rows(round_1, round_1_5)

# Details
n_articles    <- nrow(coded_articles)
n_4_recode    <- n_articles * .2
n_art_x_coder <- n_4_recode / 4

# For each coder, sample 30 articles without replacement from coded_articles 
# after filtering out articles coded by that individual. 
# Remaining articles available for next coder
# Repeat the process 4 times

# tr
set.seed(20220314)
round2_tr <- coded_articles %>% 
  filter(coder != "tr") %>% 
  sample_n(size = n_art_x_coder, replace = F) %>% 
  rename(round1_coder = coder) %>% 
  mutate(round2_coder = "tr")

# jc
set.seed(20220314)
round2_jc <- coded_articles %>% 
  filter(coder != "jc", !(ID %in% round2_tr$ID)) %>% 
  sample_n(size = n_art_x_coder, replace = F) %>% 
  rename(round1_coder = coder) %>% 
  mutate(round2_coder = "jc")

# lk
set.seed(20220314)
round2_lk <- coded_articles %>% 
  filter(coder != "lk", !(ID %in% round2_tr$ID), !(ID %in% round2_jc$ID)) %>% 
  sample_n(size = n_art_x_coder, replace = F) %>% 
  rename(round1_coder = coder) %>% 
  mutate(round2_coder = "lk")

# ab
set.seed(20220314)
round2_ab <- coded_articles %>% 
  filter(coder != "ab", !(ID %in% round2_tr$ID), !(ID %in% round2_jc$ID), 
    !(ID %in% round2_lk$ID)) %>% 
  sample_n(size = n_art_x_coder, replace = F) %>% 
  rename(round1_coder = coder) %>% 
  mutate(round2_coder = "ab")

if(T) {
# Combine and save round2 df for reproducibility
round_2 <- bind_rows(round2_tr, round2_jc, round2_lk, round2_ab) %>% 
  write_csv(paste0("../../results/02_coding/", "randomized_prescreen_df_rnd2_2022_03_14.csv"))
}

round_2 <- read_csv(paste0("../../data/02_coding/", "randomized_prescreen_df_rnd2_2022_03_14.csv"))

# Get new markdown list
round2_md_rows <- round_2 %>% 
  select(ID, clickable_doi, Title, year_split, round2_coder) %>% 
  arrange(round2_coder, desc(year_split)) %>% 
  mutate(pre = "- [ ] ", 
    ID = glue("{ID}, "), 
    title_short = str_sub(Title, 1, -1), 
    Title = glue(', {title_short}, '), 
    year_split = glue("{year_split}, ")) %>% 
  transmute(
    md_row = str_c(pre, ID, clickable_doi, Title, year_split, round2_coder)
    )

# Save markdown formatted df to the clipboard so it can be pasted 
# into github issue (https://github.com/troettge/Transparency-Ling/issues/27)
clipr::write_clip(round2_md_rows)

# -----------------------------------------------------------------------------
