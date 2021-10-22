# Coding for prescreening -----------------------------------------------------
#
# Last update: 20211021
#
# WORKFLOW
# - Import google doc (link: )
# - Create 'coder' column
# - Evenly distribute coder names in list
# - Export to github_markdown with clickable cells
#
# -----------------------------------------------------------------------------




# Setup -----------------------------------------------------------------------

# libs
library("tidyverse")
library("googlesheets4")
library("here")
library("glue")

# -----------------------------------------------------------------------------




# Import ----------------------------------------------------------------------

# Get sheets
my_url <- "https://docs.google.com/spreadsheets/d/1leiJlZTiyhKGYOrQJedaRSQ0xsNpgGZ0lTE5PHTPfuk/edit#gid=0"

# Load data intro R
cooder_pre_s <- read_sheet(my_url)

# Take a look to see if it worked
glimpse(cooder_pre_s)

# Save to .csv
file_tag  <- "cooder_prescreen_backup"                # store file prefix
file_date <- format(Sys.time(), "%Y_%m_%d")           # store data date
file_name <- paste0(file_tag, "_", file_date, ".csv") # store filename

# Save as raw data backup
write_csv(cooder_pre_s, here("data", file_name))

# -----------------------------------------------------------------------------




# Assign coders ---------------------------------------------------------------

# Set seed for reproducibility
set.seed(20211021)

# Vector of coder IDs
coder_ids <- c("tr", "jc", "lk", "mr", "ab")

randomized_df <- cooder_pre_s %>% 
  # Keep only relevant articles 
  filter(first_code_include == "Yes") %>% 
  # There are 309 articles in the After-OS category and 301 in the Pre-OS 
  # category so we randomly sample 300 from each
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
file_name <- paste0("randomized_prescreen_df", "_", file_date, ".csv")
write_csv(randomized_df, here("data", file_name))

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

clipr::write_clip(md_rows)


# -----------------------------------------------------------------------------
