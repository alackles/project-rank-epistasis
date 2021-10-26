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
datafile <- "summary_mixed.csv"

# columns that represent factors to be sorted by, not numbers
fac_cols <- c("pos_MUT", "Ka", "Kb", "group", "pos.K")

# ------------------------#
#        Load file        #
#-------------------------#

df <- read.csv(paste(data_path, datafile, sep=""))

# convert appropriate columns to factors
df[fac_cols] <- lapply(df[fac_cols], as.factor)
df <- subset(df, group!="2_8") # drop one of them just to have 3 by 2


plot <- ggplot(data=df, aes(x=pos_MUT, y=mean.W, ymin=lo.W, ymax=hi.W, color=pos.K, fill=pos.K)) +
  geom_pointrange() + 
  facet_wrap(~group) +
  theme_bw() + 
  xlab("\n Genome Position") + 
  ylab("W\n") + 
  scale_x_discrete(breaks=seq(0,99,10)) +
  theme(axis.title=element_text(size=14)) +
  theme(strip.text = element_text(size=14)) +
  theme(strip.background=element_rect(fill="white"))



ggsave(plot=plot, filename=paste(fig_path, "summary_mixed.pdf", sep=""), width=fig.width, height=fig.height)
