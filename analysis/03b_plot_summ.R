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
library(viridis)

# files to process
datafile <- "summary.csv"

# columns that represent factors to be sorted by, not numbers
fac_cols <- c("ko_pos", "K")

# ------------------------#
#        Load file        #
#-------------------------#

df <- read.csv(paste(data_path, datafile, sep=""))

# convert appropriate columns to factors
df[fac_cols] <- lapply(df[fac_cols], as.factor)


plot <- ggplot(data=df, aes(x=ko_pos, y=mean.W, ymin=lo.W, ymax=hi.W, color=K, fill=K)) + 
  geom_pointrange() + 
  theme_bw() + 
  xlab("\n Genome Position") + 
  ylab("W\n") + 
  scale_fill_viridis(discrete=TRUE,option="plasma") +
  scale_color_viridis(discrete=TRUE,option="plasma") +
  scale_x_discrete(breaks=seq(0,99,10)) +
  theme(axis.title=element_text(size=14)) +
  theme(strip.text = element_text(size=14)) +
  theme(strip.background=element_rect(fill="white"))
