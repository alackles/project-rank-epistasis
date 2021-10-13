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
lastrep = 1
k_a = [1, 2]
k_b = [4, 8]
nktypes = ["half"]
mabepath = "./third-party/MABE2/build/MABE"
runpath = "./third-party/MABE2/settings/NKMixed.mabe"
dirpath = "../data/reps/mixed/"

digs = len(str(lastrep-firstrep))

for a in k_a:
  for b in k_b: 
    ka_var = "eval_nkmixed.K_a=" + str(a)
    kb_var = "eval_nkmixed.K_b=" + str(b)
    for rep in range(firstrep, lastrep):
        randseed = rep
        dirname = dirpath + "SEED_" + str(randseed).rjust(digs, '0') + "__K_" + str(k_a) + "_" + str(k_b) + "/" 
        Path(dirname).mkdir(parents=True, exist_ok=True)
        randseed_var = "random_seed=" + str(randseed)
        outpath_var = 'output.filename=\\"' + dirname + 'output.csv\\"'
        kopath_var = 'eval_nkmixed.knockout_file=\\"' + dirname + 'knockout.csv\\"'
        settings = ka_var + "\;" + kb_var + "\;" + randseed_var + "\;" + outpath_var + "\;" + kopath_var
        os.system(mabepath + " -f " + runpath + " -s " + settings)
        print(settings)
