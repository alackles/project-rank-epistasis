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

firstrep = 0
lastrep = 3
mabepath = "./third-party/MABE2/build/MABE"
runpath = "./third-party/MABE2/settings/NKRank.mabe"
dirpath = "../data/"

digs = len(str(lastrep-firstrep))

for i in range(firstrep, lastrep):
    randseed = i
    dirname = dirpath + "SEED_" + str(i).rjust(digs, '0') + "/" 
    Path(dirname).mkdir(parents=True, exist_ok=True)
    randseed_var = "random_seed=" + str(randseed)
    outpath_var = 'output.filename=\\"' + dirname + 'output.csv\\"'
    kopath_var = 'eval_nkrank.knockout_file=\\"' + dirname + 'knockout.csv\\"'
    settings = randseed_var + "\;" + outpath_var + "\;" + kopath_var
    os.system(mabepath + " -f " + runpath + " -s " + settings)
    print(settings)
