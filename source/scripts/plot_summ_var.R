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
library(grid)
library(viridis)
library(dplyr)

# files to process
datafile <- "summary_var.csv"

# columns that represent factors to be sorted by, not numbers
fac_cols <- c("pos_MUT", "ka", "kb", "nktype", "group", "colorscale", "pos.K")

# ------------------------#
#        Load file        #
#-------------------------#

df <- read.csv(paste(data_path, datafile, sep=""))


# add positional k (for coloring)
# sorry about this
df <- df %>%
  mutate(pos.K = if_else((nktype== 'half' & as.numeric(pos_MUT) < 50) | (nktype == 'merged' & as.numeric(pos_MUT) %% 2 == 1), ka, kb))

# create color scale
colscale <- viridis_pal(option="plasma")(17)
df <- df %>%
  mutate(colorscale = case_when(
    pos.K == "0" ~ colscale[1],
    pos.K == "1" ~ colscale[5],
    pos.K == "2" ~ colscale[9],
    pos.K == "4" ~ colscale[13],
    pos.K == "8" ~ colscale[16]
  ))

# convert appropriate columns to factors
df[fac_cols] <- lapply(df[fac_cols], as.factor)

# https://stackoverflow.com/questions/22996454/arrange-n-ggplots-into-lower-triangle-matrix-shape
# check this

# manual grid arrangement


var_plot <- function(nkvar) {
  plot <- ggplot(data=subset(df, nktype==nkvar), aes(x=pos_MUT, y=mean.W, ymin=lo.W, ymax=hi.W, color=pos.K, fill=pos.K)) +
    geom_pointrange() + 
    facet_grid(kb ~ ka) +
    theme_bw() + 
    xlab("\n Genome Position") + 
    ylab("W\n") + 
    scale_color_manual(values=levels(df$colorscale)) +
    scale_x_discrete(breaks=seq(0,99,10)) +
    theme(axis.title=element_text(size=14)) +
    theme(strip.text = element_text(size=14)) +
    theme(strip.background=element_rect(fill="white"))
}

half_plot <- var_plot("half")
mixed_plot <- var_plot("merged")

ggsave(plot=half_plot, filename=paste(fig_path, "summary_half.pdf", sep=""), width=fig.width, height=fig.height)
ggsave(plot=mixed_plot, filename=paste(fig_path, "summary_mixed.pdf", sep=""), width=fig.width, height=fig.height)
