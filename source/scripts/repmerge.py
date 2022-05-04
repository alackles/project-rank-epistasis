############################
# repmerge.py
#
# Author: Acacia Ackles
#
# Purpose:
# This script outputs a single long data format file of merged replicates and conditions.
#############################


######## Code #############

# import required modules

import pandas as pd
import glob

from repparse import parameters

knockout_filename = "mutants.csv"

final_datapath = "../../data/"

params = parameters()

# list of the columns that we want to keep
df_columns = {'org_ID','pos_REF','pos_MUT', 'score_REF','score_MUT'}

# time to do the merging
def merge(filename):
    canon_file = var_file = pd.DataFrame(columns=df_columns)
    for param in params:
        globpath = param["path"]
        datapath = "".join(glob.glob(globpath + filename))
        with open(datapath) as f:
            print(datapath)
            filemerge = pd.read_csv(f, sep=",", usecols=lambda c: c in df_columns)

        # let's merge them into one tidy file to output for later
        filemerge["rep"] = param["rep"]

        # check which file we're dealing with
        if param["nktype"] == "canon":
            filemerge["k"] = param["k"]
            canon_file = pd.concat([canon_file, filemerge])
        else:
            filemerge["ka"], filemerge["kb"] = param["k"].split("_")
            filemerge["nktype"] = param["nktype"]
            var_file = pd.concat([var_file, filemerge])
    
    canonpath = final_datapath + "merged_canon.csv"
    varpath = final_datapath + "merged_var.csv"
    canon_file.to_csv(canonpath, index=False)
    var_file.to_csv(varpath, index=False)

merge(knockout_filename)