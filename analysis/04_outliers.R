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
datafile <- "wilcoxon.csv"
outfile <- "outliers.csv"

# columns that represent factors to be sorted by, not numbers
fac_cols <- c("ko_pos", "rep", "K")

# ------------------------#
#        Load file        #
#-------------------------#

df <- read.csv(paste(data_path, datafile, sep=""))

# convert appropriate columns to factors
df[fac_cols] <- lapply(df[fac_cols], as.factor)

outliers <- df %>% filter(W>3500)

write.csv(outliers, paste(data_path, outfile, sep=""), row.names=FALSE)