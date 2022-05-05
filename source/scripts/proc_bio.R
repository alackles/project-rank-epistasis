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
library(tidyverse)
# files to process
datafile <- "bio/khan_etal_2011.csv"
outfile <- "merged_bio.csv"

df <- read.csv(paste(data_path, datafile, sep=""))

single_df <- df %>%
  filter(nchar(genotype) == 1) %>%
  rename(gen_REF=genotype, score_REF=rel_fitness)

double_df <- df %>%
  filter(nchar(genotype) == 2) %>%
  rename(gen_MUT=genotype, score_MUT=rel_fitness) %>%
  separate(gen_MUT, sep=c(1), c("first_char", "second_char"), remove=FALSE)

df_a <- merge(x=single_df, y=double_df, by.x = "gen_REF", by.y = "first_char") %>%
  mutate(first_char=NA)

df_b <- merge(x=single_df, y=double_df, by.x = "gen_REF", by.y = "second_char") %>%
  mutate(second_char=NA)

df_final <- rbind(df_a, df_b) %>%
  mutate(gen_MUT=coalesce(first_char,second_char)) %>%
  select(-ep_mag.x, -ep_rel.x, -first_char, -second_char) %>%
  rename(ep_mag=ep_mag.y, ep_rel=ep_rel.y) %>% 
  arrange(gen_REF)

write.csv(df_final, paste(data_path, outfile, sep=""), row.names = FALSE)
``