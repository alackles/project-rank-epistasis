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
fig.height= 8

# library load
library(ggplot2)
library(viridis)
library(dplyr)

# files to process
datafile <- "summary_canon.csv"

# columns that represent factors to be sorted by, not numbers
fac_cols <- c("pos_MUT", "k", "colorscale")

# ------------------------#
#        Load file        #
#-------------------------#

df <- read.csv(paste(data_path, datafile, sep=""))


colscale <- viridis_pal(option="plasma")(17)
df <- df %>%
  mutate(colorscale = case_when(
    k == "0" ~ colscale[1],
    k == "1" ~ colscale[5],
    k == "2" ~ colscale[9],
    k == "4" ~ colscale[13],
    k == "8" ~ colscale[16]
  ))

# convert appropriate columns to factors
df[fac_cols] <- lapply(df[fac_cols], as.factor)



plot <- ggplot(data=df, aes(x=pos_MUT, y=mean.W, ymin=lo.W, ymax=hi.W, color=k, fill=k)) +
  geom_pointrange() + 
  theme_bw() + 
  xlab("\n Genome Position") + 
  ylab("Epistasis Detected (\u03c9) \n") + 
  labs(color="K",fill="K") +
  scale_color_manual(values=levels(df$colorscale)) +
  scale_x_discrete(breaks=seq(0,99,10)) +
  theme(legend.title = element_text(size=16)) +
  theme(legend.text = element_text(size=12)) +
  theme(axis.title=element_text(size=16)) +
  theme(strip.text = element_text(size=16)) +
  theme(strip.background=element_rect(fill="white"))


ggsave(plot=plot, filename=paste(fig_path, "summary_canon.pdf", sep=""), width=fig.width, height=fig.height, device=cairo_pdf)
