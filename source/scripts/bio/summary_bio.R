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
mergefile <- "merged_bio.csv"
wilfile <- "wilcoxon_bio.csv"
outfile <- "summary_bio.csv"

# columns that represent factors to be sorted by, not numbers
fac_cols <- c("gen_REF", "gen_MUT")

# ------------------------#
#        Load file        #
#-------------------------#

df_merge <- read.csv(paste(data_path, mergefile, sep="")) 
df_wil <- read.csv(paste(data_path, wilfile, sep=""))

df_summary <- df_merge %>%
  transform(ep_abs = abs(ep_mag)) %>%
  group_by(gen_MUT) %>%
  summarise(mean.ep = mean(ep_abs),
            sd.ep = sd(ep_abs),
            n.ep = n()) %>%
  mutate(se.ep = sd.ep/ sqrt(n.ep),
         lo.ep = mean.ep - qt(1-(0.05/2), n.ep - 1) * se.ep,
         hi.ep = mean.ep + qt(1-(0.05/2), n.ep - 1) * se.ep)


df_final <- merge(df_summary, df_wil)

write.csv(df_final, paste(data_path, outfile, sep=""), row.names=FALSE)
