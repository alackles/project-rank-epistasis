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
datafile <- "merged_var.csv"
outfile <- "wilcoxon_var.csv"

# columns that represent factors to be sorted by, not numbers
fac_cols <- c("pos_REF", "pos_MUT", "rep", "nktype", "ka", "kb")

# ------------------------#
#        Load file        #
#-------------------------#

df <- read.csv(paste(data_path, datafile, sep="")) %>%
  select(-c("org_ID"))

# convert appropriate columns to factors
df[fac_cols] <- lapply(df[fac_cols], as.factor)

# process the ranking

df_ref <- df %>%
  group_by(rep, ka, kb) %>%
  select(-c(pos_MUT, score_MUT)) %>%
  unique() %>%
  mutate(rank_ref = rank(score_REF, ties.method="average"))
df <- left_join(df, df_ref)


# perform wilcox SRS 

rank_epistasis <- function(dframe, mut) {
  df_wilcox <- dframe %>%
    filter(pos_MUT == mut) %>%
    group_by(rep, nktype, ka, kb) %>%
    mutate(rank_ref = rank(rank_ref, ties.method="average")) %>%   # because there is one fewer rank; we have to move everything up one
    mutate(rank_target = rank(score_MUT, ties.method="average")) %>%
    gather(key = "rank_group", value = "rank", rank_ref, rank_target) %>%
    wilcox_test(rank ~ rank_group, paired=TRUE) %>%
    rename(W=statistic) %>%
    mutate(pos_MUT = as.factor(mut)) %>%
    select(pos_MUT, rep, nktype, ka, kb, W) %>%
    {.}
  print(paste("MUT Position:", mut))
  return(df_wilcox)
}


# collate all individual scores
df_re <- data.frame(
  pos_MUT=factor(),
  rep=factor(),
  Ka=factor(),
  Kb=factor(),
  W=numeric()
  )

for (mut in unique(df$pos_MUT)) {
  df_re <- add_row(df_re, rank_epistasis(df, mut))
}

write.csv(df_re, paste(data_path, outfile, sep=""), row.names=FALSE)
