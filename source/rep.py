#
#  @note This file is part of MABE, https://github.com/mercere99/MABE2
#  @copyright Copyright (C) Michigan State University, MIT Software license; see doc/LICENSE.md
#  @date 2021
#
#  @file  rep.py
#  @brief Quick & dirty way to run multiple replicates in MABE and save the data.
#

import os
from pathlib import Path 

buildpath = "./third-party/MABE2/build/"
runpath = buildpath + "MABE"
reppath = "../data/reps/"

genfile = "./third-party/MABE2/settings/NKRank.gen"
mabefile = "./third-party/MABE2/settings/NKRank.mabe"

firstrep = 101
lastrep = 200
kvals = [0, 1, 2, 4, 8]



digs = len(str(lastrep-firstrep))

# clean build of MABE
os.system("cd " + buildpath + "&& make clean && make && cd ../../../")

for k in kvals:
    k_var = "eval_nkrank.K=" + str(k)
    for rep in range(firstrep, lastrep):
        randseed = rep
        dirname = reppath + "SEED_" + str(randseed).rjust(digs, '0') + "__K_" + str(k) +  "/" 
        Path(dirname).mkdir(parents=True, exist_ok=True)
        randseed_var = "random_seed=" + str(randseed)
        outpath_var = 'output.filename=\\"' + dirname + 'output.csv\\"'
        mutpath_var = 'eval_nkrank.mutant_file=\\"' + dirname + 'mutants.csv\\"'
        nkpath_var = 'eval_nkrank.nk_file=\\"' + dirname + 'nk.csv\\"'
        settings = k_var + "\;" + randseed_var + "\;" + outpath_var + "\;" + mutpath_var + "\;" + nkpath_var
        os.system(runpath + " -f " + mabefile + " -s " + settings)