# Acacia Ackles
# Created for rank epistasis project

# ------------------------#
#        Setup            #
#-------------------------#

# path set

proj_path <- "/home/acacia/Documents/research/project-rank-epistasis/"
data_path <- paste(proj_path, "data/", sep="")
fig_path <- paste(proj_path, "figs/", sep="")
fig.width = 12
fig.height = 8

# library load
library(ggplot2)
library(viridis)

# files to process
datafile <- "summary_var.csv"

# columns that represent factors to be sorted by, not numbers
fac_cols <- c("pos_MUT", "ka", "kb", "nktype", "group", "pos.K")

# ------------------------#
#        Load file        #
#-------------------------#

df <- read.csv(paste(data_path, datafile, sep=""))

# convert appropriate columns to factors
df[fac_cols] <- lapply(df[fac_cols], as.factor)

var_plot <- function(nkvar) {
  half_plot <- ggplot(data=subset(df, nktype==nkvar), aes(x=pos_MUT, y=mean.W, ymin=lo.W, ymax=hi.W, color=pos.K, fill=pos.K)) +
    geom_pointrange() + 
    facet_wrap(~group) +
    theme_bw() + 
    xlab("\n Genome Position") + 
    ylab("W\n") + 
    scale_color_viridis(discrete=TRUE)+
    scale_x_discrete(breaks=seq(0,99,10)) +
    theme(axis.title=element_text(size=14)) +
    theme(strip.text = element_text(size=14)) +
    theme(strip.background=element_rect(fill="white"))
}

half_plot <- var_plot("half")
mixed_plot <- var_plot("merged")

ggsave(plot=half_plot, filename=paste(fig_path, "summary_half.pdf", sep=""), width=fig.width, height=fig.height)
ggsave(plot=mixed_plot, filename=paste(fig_path, "summary_mixed.pdf", sep=""), width=fig.width, height=fig.height)
