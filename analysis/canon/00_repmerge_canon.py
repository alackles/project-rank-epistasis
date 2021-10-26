
############################
# repMerge.py
#
# Author: Acacia Ackles
#
# Purpose:
# This script outputs a single long data format file of merged replicates and conditions.
#############################


######## Code #############

# import required modules

import pandas as pd
import csv
import glob

# constants, filenames, and other things like that

# conditions
kvals = [str(x) for x in [0, 1, 2, 4, 8]] 
first_rep = 0
last_rep = 99
reps = [str(x).rjust(2, '0') for x in range(first_rep,last_rep+1)]

knockout_filename = "mutants.csv"

source_datapath = "../../data/reps/canon/"
final_datapath = "../../data/"

# list of the columns that we want to keep
df_columns = {'org_ID','pos_REF','pos_MUT', 'score_REF','score_MUT'}

# time to do the merging
def merge_my_file(filename):
    merged_file = pd.DataFrame(columns=df_columns)
    for k in kvals: 
        for rep in reps:
            globpath = source_datapath + "SEED_" + rep + "__K_" + k + "/"
            datapath = glob.glob(globpath + filename)
            if len(datapath) == 1:
                datapath = "".join(datapath)
                # if everything's fine, open up the files
                with open(datapath) as f:
                    print(datapath)
                    filemerge = pd.read_csv(f, sep=",", usecols=lambda c: c in df_columns)
            elif not len(datapath):
                print("No files matched.")
                print("Path: ", globpath)
                pass

            # let's merge them into one tidy file to output for later
            filemerge["rep"] = rep
            filemerge["K"] = k
            # add to our list of dataframes for each k
            merged_file = merged_file.append(filemerge, sort=False)
    filepath = final_datapath + "merged_canon_" + filename
    merged_file.to_csv(filepath,index=False)


files = [knockout_filename]
for fname in files:
    merge_my_file(fname)