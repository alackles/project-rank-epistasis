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
outfile <- "wilcoxon.csv"

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


# perform wilcox SRS 

rank_epistasis <- function(dframe, ko) {
  df_wilcox <- dframe %>%
    filter(ko_pos == ko) %>%
    group_by(rep, K) %>%
    mutate(rank_ref = rank(rank_ref, ties.method="average")) %>%   # because there is one fewer rank; we have to move everything up one
    mutate(rank_new = rank(score_KO, ties.method="average")) %>%
    gather(key = "rank_group", value = "rank", rank_ref, rank_new) %>%
    wilcox_test(rank ~ rank_group, paired=TRUE) %>%
    rename(W=statistic) %>%
    mutate(ko_pos = as.factor(ko)) %>%
    select(ko_pos, rep, K, W) %>%
    {.}
  print(paste("KO Position:", ko))
  return(df_wilcox)
}


df_re <- data.frame(
  ko_pos=factor(),
  rep=factor(),
  K=factor(),
  W=numeric()
  )

for (ko in unique(df$ko_pos)) {
  df_re <- add_row(df_re, rank_epistasis(df, ko))
}

write.csv(df_re, paste(data_path, outfile, sep=""))
