# Acacia Ackles
# Created for rank epistasis project

# ------------------------#
#        Setup            #
#-------------------------#

# path set

proj_path <- "/home/acacia/Documents/research/project-rank-epistasis/"
data_path <- paste(proj_path, "data/bio/", sep="")

# library load

#install.packages(dplyr)  #uncomment if tidyverse not installed
library(tidyverse)
# files to process
datafile <- "khan_etal_2011.csv"

df <- read.csv(paste(data_path, datafile, sep=""))

single_df <- df %>%
  filter(nchar(genotype) == 1) %>%
  rename(gen_REF=genotype, score_REF=rel_fitness)

double_df <- df %>%
  filter(nchar(genotype) == 2) %>%
  rename(gen_MUT=genotype, score_MUT=rel_fitness) %>%
  separate(gen_MUT, sep=c(1), c("first_char", "second_char"), remove=FALSE)

df_a <- merge(x=single_df, y=double_df, by.x = "gen_REF", by.y = "first_char") %>%
  select(-second_char)

df_b <- merge(x=single_df, y=double_df, by.x = "gen_REF", by.y = "second_char") %>%
  select(-first_char)

df_final <- rbind(df_a, df_b) %>%
  select(-ep_mag.x, -ep_rel.x) %>%
  rename(ep_mag=ep_mag.y, ep_rel=ep_rel.y) %>%
  arrange(gen_REF)

