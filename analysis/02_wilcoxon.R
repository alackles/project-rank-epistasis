# Acacia Ackles
# Created for rank epistasis project

# ------------------------#
#        Setup            #
#-------------------------#

# path set

proj_path <- "/home/acacia/Documents/research/project-rank-epistasis/"
data_path <- paste(proj_path, "data/", sep="")

# library load

#install.packages(dplyr)  #uncomment if tidyverse not installed
library(dplyr)

# files to process
datafile <- "merged_knockout.csv"

# columns that represent factors to be sorted by, not numbers
fac_cols <- c("mt_pos", "ko_pos", "rep", "K")

# ------------------------#
#        Load file        #
#-------------------------#

df <- read.csv(paste(data_path, datafile, sep="")) %>%
  select(-c("org_ID"))

# convert appropriate columns to factors
df[fac_cols] <- lapply(df[fac_cols], as.factor)

# process the ranking

df_ref <- df %>%
  select(-c(ko_pos, score_KO)) %>%
  group_by(rep, K) %>%
  distinct() 

# function for ranking Ks 

rank_epistasis <- function(dframe, ko) {
  this_ref <- filter(df_ref, mt_pos != ko) %>%
    mutate(rank_ref = rank(score_MT, ties.method=c("average")))
  df_new <- dframe %>% 
    group_by(rep, K) %>%
    filter(ko_pos == ko) %>%
    mutate(rank_new = rank(score_KO, ties.method=c("average"))) %>%
    {.}
  df_comp <- right_join(this_ref, df_new) %>%
    select(-c(score_MT, score_KO, ko_pos)) %>%
    group_by(rep, K) %>%
    mutate(W=wilcox.test(x=rank_ref, y=rank_new, paired=TRUE)$statistic)
  return(df_comp)
}

df_re <- rank_epistasis(df, 0)
for (i in 0:max(as.numeric(df_re$mt_pos))) {
  W_compute <- rank_epistasis(df, i)
  df_re <- right_join(df_re, W_compute)
}

