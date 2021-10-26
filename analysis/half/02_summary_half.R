# Acacia Ackles
# Created for rank epistasis project

# ------------------------#
#        Setup            #
#-------------------------#

# path set

proj_path <- "/home/acacia/Documents/research/project-rank-epistasis/"
data_path <- paste(proj_path, "data/", sep="")

# library load
library(dplyr)

# files to process
datafile <- "wilcoxon_half.csv"
outfile <- "summary_half.csv"

# columns that represent factors to be sorted by, not numbers
fac_cols <- c("pos_MUT", "rep", "Ka", "Kb")

# ------------------------#
#        Load file        #
#-------------------------#

df <- read.csv(paste(data_path, datafile, sep=""))

summary.loc <- df %>%
  group_by(pos_MUT, Ka, Kb) %>%
  summarise(mean.W = mean(W),
            sd.W = sd(W),
            n.W = n()) %>%
  mutate(pos.K = ifelse((pos_MUT < 50, Ka, Kb),
         group = as.factor(paste(as.character(Ka), as.character(Kb), sep="")),
         se.W = sd.W/ sqrt(n.W),
         lo.W = mean.W - qt(1-(0.05/2), n.W - 1) * se.W,
         hi.W = mean.W + qt(1-(0.05/2), n.W - 1) * se.W)

write.csv(summary.loc, paste(data_path, outfile, sep=""), row.names=FALSE)

