## Pilot Prescreening

In the pilot prescreening, two coders (EMB, IAC) examined articles that
were found in a randomized set from the data selection procedure. 50
articles (25 pre-open science, 25 post-open science) were piloted to
examine the potential proportions of included versus excluded articles.
As shown in the code below, we found:

-   Pre-OS approximately 68% of the articles were included, post-OS only
    40% of articles were included.
-   Overall, this implies approximately 54% of articles would likely be
    included.
-   We can expect to not be able to find some articles, even after
    trying to get through the potential pay wall (10%).

<!-- -->

    pilot <- read.csv("prescreening_pilot.csv")

    # reduce just to articles piloted 
    pilot <- subset(pilot, !is.na(count))

    # number piloted
    nrow(pilot)

    ## [1] 50

    # create year variable
    pilot$year_split <- pilot$Year < 2015
    pilot$year_split <- factor(pilot$year_split, 
                               levels = c(TRUE, FALSE),
                               labels = c("Pre-OS", "After-OS"))
    table(pilot$year_split)

    ## 
    ##   Pre-OS After-OS 
    ##       25       25

    # examine yes/no/na 
    # note that NA means we couldn't find a copy of the article 
    table(pilot$year_split, pilot$erin.code, useNA = "ifany")

    ##           
    ##            no yes <NA>
    ##   Pre-OS    8  17    0
    ##   After-OS 10  10    5

    table(pilot$year_split, pilot$erin.code, useNA = "ifany")/25 * 100

    ##           
    ##            no yes <NA>
    ##   Pre-OS   32  68    0
    ##   After-OS 40  40   20

    # examine overall
    table(pilot$erin.code, useNA = "ifany")

    ## 
    ##   no  yes <NA> 
    ##   18   27    5

    table(pilot$erin.code, useNA = "ifany")/50 * 100

    ## 
    ##   no  yes <NA> 
    ##   36   54   10

## Create Real Screening List

After this pilot test, we again randomly selected articles based on the
overall data selection procedure. This file was originally printed here
and saved for the prescreening team to work on.

Print out the list for working with others:

    list_sub$year_split <- list_sub$Year < 2015
    list_sub$year_split <- factor(list_sub$year_split, 
                               levels = c(TRUE, FALSE),
                               labels = c("Pre-OS", "After-OS"))

    #write.csv(list_sub, "prescreening_list.csv", row.names = F)

## Prescreening (Round 1) Results

EMB, IAC, and KC completed the prescreening during Fall 2021. We first
assigned each person to screen 200 articles (100 pre, 100 post) for a
total of 600 articles screened (200 \* 3 people). We then examined the
proportions of included versus included articles and determined that we
may achieve coverage desired (300 articles in pre and post, therefore
600 total) if each person again coded 200 articles. Therefore, we did
two first round screenings of the data. We then examined our number of
articles coded by the first coder to include and determined we had
reached our goal of 600 articles. Therefore, we proposed to the
remainder of the team to include these articles and *not* perform second
round coding of the No/Unsure articles. The pre-registration said:

-   Any article marked by at least *one* person as “yes include” would
    be sent to the next round of data processing.
-   Articles marked No/Unsure would be coded by a second person to
    determine if it should be included.
-   We wished to achieve 600 articles total (300 pre, 300 post) with the
    goal that these may still have articles that the data processing
    team decides are not “linguistic”. The goal was to match the 250
    completed in the original paper.

The entire team discussed and decided that the coverage of included
articles was the ultimate goal, and we would not code the No/Unsure
articles for a second coder, *unless* the data processing team excluded
enough articles that a second round of prescreening became necessary.

During our (EMB, IAC, KC) discussions, we considered what articles
should be marked as no (reasons can be see in the prescreen results).
The common themes included: vision/perception research, translation
research, theater, teaching practices, religion, politics, philosophy,
literature discussions, history, and culture. The largest category was
literature reviews and works. We clarified that cognitive/social
psychology research that included language stimuli (usually words)
should not be included if the paper was not about language, just
happened to use language stimuli (for example, studies on memory). Items
that were considered somewhat of a “gray” area included: communication
studies, sociolinguistics-adjacent research, and cultural work.

    psR1 <- read.csv("prescreening_round1.csv")

    # original number of articles
    nrow(psR1)

    ## [1] 1500

    psR1 <- subset(psR1, first_code_initials != "")

    # total screened
    nrow(psR1)

    ## [1] 1200

Of the 1200 articles screened, we found 610 (50.8%) to include in
further data processing. 96 articles (8%) could not be found leaving the
remaining 494 (41.2%) as no or unsure if should be included.

    psR1$first_code_include <- gsub("\\s$", "", psR1$first_code_include)

    # raw counts
    table(psR1$first_code_include, useNA = "ifany")

    ## 
    ##        No No Access    Unsure       Yes 
    ##       432        96        62       610

    # percent counts
    table(psR1$first_code_include, useNA = "ifany") / sum(table(psR1$first_code_include, useNA = "ifany")) * 100

    ## 
    ##        No No Access    Unsure       Yes 
    ## 36.000000  8.000000  5.166667 50.833333

In this section, we examine if there are differences in coders for a
yes-no/unsure distinction. We drop articles with no access. Note that
articles not in English are included in the “no” category.

We find significant differences between coders using *α* &lt; .05 and a
chi-square test of independence. The effect appears small (Cramer’s V =
.06). An examination of the standardized residuals appears to indicate
that IAC was more likely to mark No while KC was more likely to mark Yes
using an absolute value *z*-score greater than 2 as an indicator.
Therefore, we found a slight difference between coders, but these appear
small.

    psR1$coder <- gsub("[0-9]", "", psR1$first_code_initials)
    table(psR1$coder)

    ## 
    ## emb  iac   kc  
    ##  400  400  400

    table(psR1$coder, psR1$first_code_include)

    ##       
    ##         No No Access Unsure Yes
    ##   emb  154        18     11 217
    ##   iac  138        58     37 167
    ##   kc   140        20     14 226

    psR1$yes_no <- psR1$first_code_include
    psR1$yes_no <- gsub("No Access", NA, psR1$yes_no)
    psR1$yes_no <- gsub("Unsure", "No", psR1$yes_no)

    table(psR1$coder, psR1$yes_no)

    ##       
    ##         No Yes
    ##   emb  165 217
    ##   iac  175 167
    ##   kc   154 226

    coder_diffs <- chisq.test(psR1$coder, psR1$yes_no)
    v <- sqrt(coder_diffs$statistic/(sum(coder_diffs$observed) * 2))

    coder_diffs

    ## 
    ##  Pearson's Chi-squared test
    ## 
    ## data:  psR1$coder and psR1$yes_no
    ## X-squared = 8.8167, df = 2, p-value = 0.01218

    v

    ##  X-squared 
    ## 0.06319077

    coder_diffs$stdres

    ##           psR1$yes_no
    ## psR1$coder         No        Yes
    ##       emb  -0.7546829  0.7546829
    ##       iac   2.8754986 -2.8754986
    ##       kc   -2.0429911  2.0429911

Second, we examined the differences in yes-no coding for pre and post
OS. No evidence was found for differences in yes-no coding and the year
of publication.

    table(psR1$year_split, psR1$first_code_include)

    ##           
    ##             No No Access Unsure Yes
    ##   After-OS 200        60     31 309
    ##   Pre-OS   232        36     31 301

    table(psR1$year_split, psR1$yes_no)

    ##           
    ##             No Yes
    ##   After-OS 231 309
    ##   Pre-OS   263 301

    year_diffs <- chisq.test(psR1$year_split, psR1$yes_no)
    v_year <- sqrt(year_diffs$statistic/(sum(year_diffs$observed) * 2))

    year_diffs

    ## 
    ##  Pearson's Chi-squared test with Yates' continuity correction
    ## 
    ## data:  psR1$year_split and psR1$yes_no
    ## X-squared = 1.5046, df = 1, p-value = 0.22

    v_year

    ##  X-squared 
    ## 0.02610462

    year_diffs$stdres

    ##                psR1$yes_no
    ## psR1$year_split        No       Yes
    ##        After-OS -1.287182  1.287182
    ##        Pre-OS    1.287182 -1.287182
