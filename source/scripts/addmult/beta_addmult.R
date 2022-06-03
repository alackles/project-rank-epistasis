# Acacia Ackles
# Created for rank epistasis project

# ------------------------#
#        Setup            #
#-------------------------#

# path set

proj_path <- "/home/acacia/Documents/research/project-rank-epistasis/"
data_path <- paste(proj_path, "data/", sep = "")

# library load

library(dplyr)
library(rstatix)

# files to process
datafile <- "merged_addmult.csv"
outfile <- "beta_addmult.csv"

# ------------------------#
#        Load file        #
#-------------------------#

df <- read.csv(paste(data_path, datafile, sep = "")) %>%
  rename(pos_A=pos_REF,
         pos_B=pos_MUT,
         W_0=score_WT,
         W_A=score_REF,
         W_AB=score_MUT,
         allele_A=allele_REF,
         allele_B=allele_MUT) # renamed to make more consistent with beta metric

# convert appropriate columns to factors
fac_cols = c("rep", "pos_A", "pos_B", "allele_A", "allele_B")
df[fac_cols] <- lapply(df[fac_cols], as.factor)

# add column for WB to compute across rows

df_A <- df %>%
  group_by(rep, pos_A) %>%
  mutate(mean.W_A = mean(W_A)) %>% # average score across all single mutants
  ungroup() %>%
  group_by(rep, pos_A, pos_B) %>% 
  mutate(mean.W_AB = mean(W_AB)) %>% # average score across all double mutants
  select(-c(W_A, W_AB, allele_A, allele_B)) %>% # drop columns after averaging
  unique() %>%
  ungroup()# get only the summarized data 
  
df_meansort <- df_A %>%
  select(rep, pos_B, mean.W_A) %>%
  group_by(rep) %>%
  arrange(pos_B) %>%
  ungroup()

df_avg <- df_A %>%
  mutate(mean.W_B = df_meansort$mean.W_A)

# additive and multiplicative epistasis

df_eps <- df_avg %>%
  group_by(rep) %>%
  mutate(eps_add=log((W_0*mean.W_AB)/(mean.W_A)*mean.W_B)) %>%
  mutate(eps_mult=((W_0*mean.W_AB) - (mean.W_A * mean.W_B))/(W_0*W_0))


write.csv(df_eps, paste(data_path, outfile, sep=""), row.names=FALSE)