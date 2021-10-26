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

mabefile_canon = "./third-party/MABE2/settings/NKRank.mabe"
mabefile_vari = "./third-party/MABE2/settings/NKVar.mabe"

firstrep = 0
lastrep = 99
 
# canonical NK 
kvals =  0, 1, 2, 4, 8

# variant NK
kpairs =  [(0, 1), (1, 2), (1, 8), (2, 2), (2, 4), (2, 8), (4, 8)]
nktypes = ["half", "mixed"]

digs = len(str(lastrep-firstrep))

# clean build of MABE
os.system("cd " + buildpath + "&& make clean && make && cd ../../../")

for k in kvals:
      k_var = 'eval_nkrank.K='+ str(k)
      for rep in range(firstrep, lastrep+1):
          randseed = rep
          dirname = reppath + "canon/SEED_" + str(randseed).rjust(digs, '0') + "__K_" + str(k) + "/"
          print(dirname)
          Path(dirname).mkdir(parents=True, exist_ok=True)
          randseed_var = "random_seed=" + str(randseed)
          outpath_var = 'output.filename=\\"' + dirname + 'output.csv\\"'
          mutpath_var = 'eval_nkrank.mutant_file=\\"' + dirname + 'mutants.csv\\"'
          nkpath_var = 'eval_nkrank.nk_file=\\"' + dirname + 'nk.csv\\"'
          genpath_var = 'eval_nkrank.genome_file=\\"' + dirname + 'ref_genome.csv\\"'
          settings = k_var + "\;" + randseed_var + "\;" + outpath_var + "\;" + mutpath_var + "\;" + nkpath_var + "\;" + genpath_var
          os.system(runpath + " -f " + mabefile_canon + " -s " + settings)

for kpair in kpairs:
    ka = kpair[0]
    kb = kpair[1]
    ka_var = 'eval_nkvar.K_a='+ str(ka)
    kb_var = 'eval_nkvar.K_b=' + str(kb)
    for nk in nktypes:
        nk_var = 'eval_nkvar.nk_type=\\"' + nk + '\\"'
        print(nk_var)
        for rep in range(firstrep, lastrep+1):
            randseed = rep
            dirname = reppath + nk + "/SEED_" + str(randseed).rjust(digs, '0') + "__KA_" + str(ka) + "__KB_" + str(kb) +  "/" 
            print(dirname)
            Path(dirname).mkdir(parents=True, exist_ok=True)
            randseed_var = "random_seed=" + str(randseed)
            outpath_var = 'output.filename=\\"' + dirname + 'output.csv\\"'
            mutpath_var = 'eval_nkvar.mutant_file=\\"' + dirname + 'mutants.csv\\"'
            nkpref_var = 'eval_nkvar.nk_prefix=\\"' + dirname + 'nk\\"'
            genpath_var = 'eval_nkvar.genome_file=\\"' + dirname + 'ref_genome.csv\\"'
            settings = nk_var + "\;" + ka_var + "\;" + kb_var + "\;" + randseed_var + "\;" + outpath_var + "\;" + mutpath_var + "\;" + nkpref_var + "\;" + genpath_var
            os.system(runpath + " -f " + mabefile_vari + " -s " + settings)