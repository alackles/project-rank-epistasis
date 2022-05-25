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
datafile <- "merged_bio.csv"
outfile <- "wilcoxon_bio.csv"

# columns that represent factors to be sorted by, not numbers
fac_cols <- c("gen_REF", "gen_MUT", "mut_stat")

# ------------------------#
#        Load file        #
#-------------------------#

df <- read.csv(paste(data_path, datafile, sep="")) 

# convert appropriate columns to factors
df[fac_cols] <- lapply(df[fac_cols], as.factor)

# process the ranking

df_ref <- df %>%
  select(gen_REF, score_REF) %>%
  unique() %>%
  mutate(rank_ref = rank(score_REF, ties.method="average"))
df <- left_join(df, df_ref)

rank_epistasis <- function(dframe, mut) {
  df_wilcox <- dframe %>%
    filter(gen_MUT == mut) %>%
    mutate(rank_ref = rank(rank_ref, ties.method="average")) %>%   # because there is one fewer rank; we have to move everything up one
    mutate(rank_target = rank(score_MUT, ties.method="average")) %>%
    gather(key = "rank_group", value = "rank", rank_ref, rank_target) %>%
    wilcox_test(rank ~ rank_group, paired=TRUE) %>%
    rename(W=statistic) %>%
    mutate(gen_MUT = as.factor(mut)) %>%
    select(gen_MUT, W) %>%
    {.}
  print(paste("MUT Position:", mut))
  return(df_wilcox)
}



# collate all individual scores
df_re <- data.frame(
  gen_MUT=factor(),
  W=numeric()
)

for (mut in unique(df$gen_MUT)) {
  df_re <- add_row(df_re, rank_epistasis(df, mut))
}

write.csv(df_re, paste(data_path, outfile, sep=""), row.names=FALSE)