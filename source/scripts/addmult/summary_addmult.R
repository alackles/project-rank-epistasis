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
datafile_re <- "wilcoxon_addmult.csv"
datafile_eps <- "beta_addmult.csv"
outfile <- "summary_addmult.csv"

# columns that represent factors to be sorted by, not numbers
fac_cols <- c("pos_MUT", "rep", "k")

# ------------------------#
#        Load file        #
#-------------------------#

df_re <- read.csv(paste(data_path, datafile_re, sep="")) %>%
  rename(pos=pos_MUT)

df_eps <- read.csv(paste(data_path, datafile_eps, sep="")) %>%
  rename(pos=pos_A)

# get df_re into the same summary state as df_eps
df_re <- df_re %>%
  group_by(rep, pos) %>%
  summarise(mean.W=mean(W))

df <- left_join(df_re, df_eps) %>%
  rename(rank=mean.W,
         additive=eps_add,
         multiplicative=eps_mult) %>%
  gather(key="metric", value="epistasis", c(rank, additive, multiplicative))

summary.loc <- df %>%
  group_by(pos, metric) %>%
  summarise(mean.epistasis = mean(epistasis, na.rm=TRUE),
            sd.epistasis = sd(epistasis, na.rm=TRUE),
            n = n()) %>%
  mutate(se.epistasis = sd.epistasis/ sqrt(n),
         lo.epistasis = mean.epistasis - qt(1-(0.05/2), n - 1) * se.epistasis,
         hi.epistasis = mean.epistasis + qt(1-(0.05/2), n - 1) * se.epistasis) 

write.csv(summary.loc, paste(data_path, outfile, sep=""), row.names=FALSE)

