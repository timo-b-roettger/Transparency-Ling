# Transparency in Linguistics Information

Code, data, and result folders are labeled according to the step of project. They are matched across these folders to ensure consistency and readabiblity. 

## `01_scopus-selection` 

- `01_sampling.R`:
  - This file creates our random list of articles pulled from Scopus for coding purposes. Please note that the articles chosen are the reproducible, but the original ID codes are randomized with each run for the original data file `prescreening_list_2021-07-04.txt`. 

## `02_coding`:

- `02_prescreening_info.Rmd`:
  - After creating a sample of potential articles, Several people were involved in hand coding articles for pre-screening. This step involved a simple check if they should be used for coding for the article. This file summarizes the results of two-stages of pre-screening. It should be noted that the first stage of pre-screening was used to inform how many articles to sample that was implemented in the first sampling step. The sampling file was used to create a smaller sample (found in `prescreening_pilot.csv`) - and these were assigned a random number and 50 were selected. Based on the results, we realized we would need to do a larger sample to acquire our target number of articles. The sampling code was used again to create the final pre-screening list. 
- `03_random_coding_assignment.R`: 
  - This file takes the pre-screening information and randomly assigns articles to coders who completed the article coding step. The output found in the results matches our original data files `randomized_prescreen_df_2021_10_21.csv` and `randomized_prescreen_df_rnd2_2022_03_14.csv`. 
  
## `03_analyses`:

- `04_data_coding.Rmd`:
  - This file imports data and results from previous steps and cleans up the files. The coder agreement is examined and fixed when coders disagreed. 
- `05_raw_results.Rmd`:
  - This file creates a document of the results before combining open text fields and other coding decisions made for the final manuscript. In our pre-registration, we said we would present the raw results before doing exploratory combinations. Therefore, this document represents the raw results and exports a dataset that fixes the issues with JIF and Open Access coding from the raw results (they were originally half coded by the coding team, but then were recoded by one person each who had access to the right systems to get this information). 
- `06_cleaned_results.Rmd`: 
  - This file represents the bulk of our analyses and should somewhat closely match the manuscript. The manuscript was written collaboratively in google docs, and this document was used to create the results section with tweaks and changes from the rest of the team. THe numbers presented here should match the manuscript. Tables are provided at the end to match the discussion section proportions reported. 
  
# Collaboration Information

Welcome: Are you a collaborator? Than you are most likely looking for the [task managment board](https://github.com/troettge/Transparency-Ling/projects/1).

## Collaboration Agreement

### Transparency in Linguistics Collaboration Agreement

This agreement provides guidelines for publication(s) resulting from the Transparency in Linguistics collaboration. 

### Authorship Guidelines

**How do I become an author on a paper that results from this project?**

The current goal is to replicate the [Hardwicke et al. (2021)](https://journals.sagepub.com/doi/10.1177/1745691620979806) paper focused on transparency in linguistics. This project should result in a paper for publication with the results from an investigation into publication and open science practices in linguistics. 

We will adhere to the [CRediT taxonomy](https://www.cell.com/pb/assets/raw/shared/guidelines/CRediT-taxonomy.pdf) to determine what counts as a “contribution”. Anyone who contributes to the project via data collection, project leadership, administration, or through some other role outlined in the taxonomy will have the chance to become an author on this paper.

**How do we handle authorship on secondary papers for this project?**

Other publication opportunities may arise from the discussions and exploration of the data created for this project. There is no expectation of authorship on these papers; however, the person conceptualizing ideas for a new collaboration can propose a project that can be added to this collaboration agreement. For example, while exploring the publication lists produced by this project, you may uncover a trend in publications you wish to write about. There is no expectation that others involved in the main project are authors, but you can offer collaboration if you wish. 

**What constitutes authorship?**

All authors on a particular paper must make contributions to writing - mostly commonly through review and editing. A “contribution” to this category can be as small as reading the manuscript and approving it. In addition, all authors must make contributions to at least one other category of the [CRediT taxonomy](https://www.cell.com/pb/assets/raw/shared/guidelines/CRediT-taxonomy.pdf). Deviations to this rule may be made at the discretion of the project leadership team. Most authors will contribute to “Investigation” (a category which includes contributions to data collection) and “Writing - Review & Editing.” If one of the papers is a Registered Report, people contributing to data collection (and thus the “Investigation” category) will receive authorship based on the assumption that they fulfill their data collection obligations.

Principal Investigators (PIs) of contributing labs are responsible for their students and staff working on the project. This includes: honestly reporting the contributions of their lab members, evaluating whether contributions merit authorship according to the above paragraph and the CRediT table, and verifying that contributions are correctly described in any formal publication. PIs are also responsible for showing this agreement to lab members who will be authors and making sure they agree to it.

Author contributions will be reported on research products using the [CRediT taxonomy](https://www.cell.com/pb/assets/raw/shared/guidelines/CRediT-taxonomy.pdf). The [Tenzing app](https://osf.io/preprints/metaarxiv/b6ywe/) may be a helpful tool to collect this contributorship information.

**How will authorship order be determined?**

Authorship order will be organized into the following sections, with order determined as listed below. Authorship order will be an active discussion, as contributions may move individuals into different sections. At the end of the project, each contributor will fill out a form indicating their contribution to the project.

*Section 1 (Proposing Team and Admin Team)*. The proposing/conceptualizing teams will be listed together in the first section. If proposers feel they each have equal contribution, their order will be randomized, and a note describing this randomization procedure will be added to the author notes. Special consideration will be made for the first author and/or shared first authorship, based on group discussion. 

An example of the randomization procedure in R:

```
> set.seed(589343)
> names <- c("person1", "person2", "person3")
> sample(names, length(names))
> [1] "person3" "person1" "person2"
```

*Section 2 (Contributions beyond data collection)*. We acknowledge that there are many ways to contribute to projects. This section will include members who assist with more CRediT contributions than data collection and writing. 

*Section 3 (Data collection or processing team)*. Order determined at random.
