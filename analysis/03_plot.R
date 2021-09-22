# Acacia Ackles
# Created for rank epistasis project

# ------------------------#
#        Setup            #
#-------------------------#

# path set

proj_path <- "/home/acacia/Documents/research/project-rank-epistasis/"
data_path <- paste(proj_path, "data/", sep="")
fig_path <- paste(proj_path, "figs/", sep="")

# library load
library(ggplot2)

# files to process
datafile <- "wilcoxon.csv"

# columns that represent factors to be sorted by, not numbers
fac_cols <- c("ko_pos", "rep", "K")

# ------------------------#
#        Load file        #
#-------------------------#

df <- read.csv(paste(data_path, datafile, sep=""))

# convert appropriate columns to factors
df[fac_cols] <- lapply(df[fac_cols], as.factor)


plot <- ggplot(data=df, aes(x=ko_pos, y=W, color=K, fill=K)) + 
  geom_point()

plot2 <- ggplot(data=df, aes(x=K,y=W)) +
  geom_jitter()
