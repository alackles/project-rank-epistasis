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

genfile = "./third-party/MABE2/settings/NK.gen"
mabefile = "./third-party/MABE2/settings/NK.mabe"

firstrep = 0
lastrep = 2
 
# canonical NK 
kvals =  0, 1, 2, 4, 8

# variant NK
kpairs =  [(0, 1), (1, 2), (1, 8), (2, 2), (2, 4), (2, 8), (4, 8)]
nktypes = ["half", "mixed"]

digs = len(str(lastrep-firstrep))

# clean build of MABE
os.system("cd " + buildpath + "&& make clean && make && cd ../../../")

for k in kvals:
      k_var = 'eval_nk.K='+ str(k)
      for rep in range(firstrep, lastrep):
          randseed = rep
          dirname = reppath + "canon/SEED_" + str(randseed).rjust(digs, '0') + "__K_" + str(k) + "/"
          print(dirname)
          Path(dirname).mkdir(parents=True, exist_ok=True)
          randseed_var = "random_seed=" + str(randseed)
          outpath_var = 'output.filename=\\"' + dirname + 'output.csv\\"'
          mutpath_var = 'eval_nk.mutant_file=\\"' + dirname + 'mutants.csv\\"'
          nkpath_var = 'eval_nk.nk_file=\\"' + dirname + 'nk.csv\\"'
          genpath_var = 'eval_nk.genome_file=\\"' + dirname + 'ref_genome.csv\\"'
          settings = k_var + "\;" + randseed_var + "\;" + outpath_var + "\;" + mutpath_var + "\;" + nkpath_var + "\;" + genpath_var
          os.system(runpath + " -f " + mabefile + " -s " + settings)

for kpair in kvals:
    ka = kpair[0]
    kb = kpair[1]
    ka_var = 'eval_nkmixed.K_a='+ str(ka)
    kb_var = 'eval_nkmixed.K_b=' + str(kb)
    for nk in nktypes:
        nk_var = 'eval_nkmixed.nk_type=' + nk
        for rep in range(firstrep, lastrep):
        randseed = rep
        dirname = reppath + nk + "/SEED_" + str(randseed).rjust(digs, '0') + "__KA_" + str(ka) + "__KB_" + str(kb) +  "/" 
        print(dirname)
        Path(dirname).mkdir(parents=True, exist_ok=True)
        randseed_var = "random_seed=" + str(randseed)
        outpath_var = 'output.filename=\\"' + dirname + 'output.csv\\"'
        mutpath_var = 'eval_nkmixed.mutant_file=\\"' + dirname + 'mutants.csv\\"'
        nkpath_var = 'eval_nkmixed.nk_file=\\"' + dirname + 'nk.csv\\"'
        genpath_var = 'eval_nkmixed.genome_file=\\"' + dirname + 'ref_genome.csv\\"'
        settings = ka_var + "\;" + kb_var + "\;" + randseed_var + "\;" + outpath_var + "\;" + mutpath_var + "\;" + nkpath_var + "\;" + genpath_var
        os.system(runpath + " -f " + mabefile + " -s " + settings)