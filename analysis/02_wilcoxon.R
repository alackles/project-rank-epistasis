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
library(rstatix)

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
  group_by(rep, K) %>%
  select(-c(ko_pos, score_KO)) %>%
  unique() %>%
  mutate(rank_ref = rank(score_MT, ties.method="average"))
df <- left_join(df, df_ref)


# function for ranking Ks 

rank_epistasis <- function(dframe, ko) {
  df <- dframe %>%
    group_by(rep, K) %>%
    filter(ko_pos == ko) %>%
    mutate(rank_ref = rank(rank_ref, ties.method="average")) %>%   # because there is one fewer rank; we have to move everything up one
    mutate(rank_new = rank(score_KO, ties.method="average")) %>%
    wilcox_test()
    {.}
  return(df)
}

df_re <- rank_epistasis(df, 1)

