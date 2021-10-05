############################
# repMerge.py
#
# Author: Acacia Ackles
#
# Purpose:
# This script reads the csv created by 04_outliers.R
# and prints out the relevant NK landscape table
#############################


######## Code #############

# import required modules

import pandas as pd
import numpy as np
import csv

# constants, filenames, and other things like that
datapath = "../data/"
reppath = datapath + "reps/"

outlier_filename = "outliers.csv"
nk_filename = "nk.csv"

#
nk_arr = []

outliers = pd.read_csv(datapath + outlier_filename)

for i, row in outliers.iterrows():
    pos = int(row["pos_MUT"])
    rep = int(row["rep"])
    k = int(row["K"])
    
    print("REPNUM: " + str(rep))
    print("K: " + str(k))
    
    # match up row names
    kbin = "0" + str(k+1) + "b"
    rownames = [format(i, kbin) for i in range(0, pow(2, k+1))]
    
    # create column names
    colnames = [str(n) for n in range(pos, pos+k+1)]

    pathname = "SEED_" + str(rep) + "__K_" + str(k) + "/"
    nkfile = reppath + pathname + nk_filename
    nk_tmp = np.genfromtxt(nkfile, delimiter=",")
    print(pd.DataFrame(nk_tmp[:100, pos:pos+k+1], columns=colnames, index=rownames))
    print('\n')
