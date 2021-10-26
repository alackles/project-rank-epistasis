
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
kvals =  [(0, 1), (1, 2), (1, 8), (2, 2), (2, 4), (2, 8), (4, 8)]
first_rep = 1
last_rep = 99
reps = [str(x).rjust(3, '0') for x in range(first_rep,last_rep+1)]

knockout_filename = "mutants.csv"

source_datapath = "../../data/reps/mixed/"
final_datapath = "../../data/"

# list of the columns that we want to keep
df_columns = {'org_ID','pos_REF','pos_MUT', 'score_REF','score_MUT'}

# time to do the merging
def merge_my_file(filename):
    merged_file = pd.DataFrame(columns=df_columns)
    for kpair in kvals: 
        ka = kpair[0]
        kb = kpair[1]
        for rep in reps:
            globpath = source_datapath + "SEED_" + rep + "__KA_" + ka + "__KB_" + kb + "/"
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
            filemerge["Ka"] = ka
            filemerge["Kb"] = kb
            # add to our list of dataframes for each k
            merged_file = merged_file.append(filemerge, sort=False)
    filepath = final_datapath + "merged_mixed_" + filename
    merged_file.to_csv(filepath,index=False)


files = [knockout_filename]
for fname in files:
    merge_my_file(fname)