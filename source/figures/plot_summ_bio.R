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
fig.height = 6

# library load
library(ggplot2)
library(viridis)
library(dplyr)

# files to process
datafile <- "summary_bio.csv"

# ------------------------#
#        Load file        #
#-------------------------#

df <- read.csv(paste(data_path, datafile, sep=""))

bio_plot <- ggplot(data=df, aes(x=gen_MUT, y=W, color=mean.ep)) + 
  geom_point(size=3) 

bio_plot_2 <- ggplot(data=df, aes(x=gen_MUT, y=mean.ep, color=W)) + 
  geom_point(size=3) 

# bio_plot <- ggplot(data=subset(df, nktype==nkvar), aes(x=gen_MUT, y=mean.W, ymin=lo.W, ymax=hi.W, color=pos.K, fill=pos.K)) +
#     geom_point() +
#     theme_bw() +
#     xlab("\n Genome Position") +
#     ylab("W\n") +
#     scale_color_viridis(discrete=TRUE)+
#     scale_x_discrete(breaks=seq(0,99,10)) +
#     theme(axis.title=element_text(size=14)) +
#     theme(strip.text = element_text(size=14)) +
#     theme(strip.background=element_rect(fill="white"))
# }

ggsave(plot=bio_plot, filename=paste(fig_path, "summary_bio_re.pdf", sep=""), width=fig.width, height=fig.height)
ggsave(plot=bio_plot_2, filename=paste(fig_path, "summary_bio_trad.pdf", sep=""), width=fig.width, height=fig.height)
