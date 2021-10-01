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
  geom_point() + 
  theme_bw() + 
  xlab("\n Genome Position") + 
  ylab("W\n") + 
  scale_x_discrete(breaks=seq(0,99,10))
  pltheme(axis.title=element_text(size=14)) +
  theme(strip.text = element_text(size=14)) +
  theme(strip.background=element_rect(fill="white"))


plot2 <- ggplot(data=df, aes(x=K,y=W, fill=K, alpha=0.5, color=K)) +
  geom_violin(scale="width") +
  geom_boxplot(fill = NA,width=0.1, outlier.size=1, outlier.alpha = 1)+
  scale_fill_viridis(discrete=TRUE,option="plasma") +
  scale_color_viridis(discrete=TRUE,option="plasma") +
  stat_summary(fun=mean, geom="point", size=2, color="black") +
  theme_bw() +
  theme(legend.position = "none") +
  xlab("\nK (number of interacting sites)") +
  ylab("W (Wilcoxon Signed-Rank Sum)\n") +
  theme(axis.title=element_text(size=14)) +
  theme(axis.text=element_text(size=12)) +
  theme(strip.text = element_text(size=14)) +
  theme(strip.background=element_rect(fill="white"))
