#
#  @note This file is part of MABE, https://github.com/mercere99/MABE2
#  @copyright Copyright (C) Michigan State University, MIT Software license; see doc/LICENSE.md
#  @date 2021
#
#  @file  rep.py
#  @brief Quick & dirty way to run multiple replicates in MABE and save the data.
#

import multiprocessing as mp
import os
from pathlib import Path

from repparse import parameters 

def buildmabe(buildpath):
    os.system("cd " + buildpath + "&& make clean && make && cd ../../../scripts/")

def runmabe(exec, mabefile, params):
  # exec: path to MABE executable
  # params: command-line parameters
  # first: first replicate
  # last: last replicate (works like python, so not inclusive)
  os.system(exec + " -f " + mabefile + " -s " + params)

def make_settings(param):
    reppath = param["path"]
    seed = str(int(param["rep"])) # remove leading 0s
    nktype = param["nktype"]
    k = param["k"]

    eval_string = "eval_nkrank" if nktype == "canon" else "eval_nkvar"

    settings = []

    # RANDOM SEED
    settings.append('random_seed=\\"' + seed + '\\"')

    # OUTPUT
    settings.append('fit_file.filename=\\"' + reppath + 'fitness.csv\\"')
    settings.append('max_file.filename=\\"' + reppath + 'max_org.csv\\"')
    settings.append(eval_string + '.mutant_file=\\"' + reppath + 'mutants.csv\\"')
    settings.append(eval_string + '.genome_file=\\"' + reppath + 'ref_genome.csv\\"')

    if nktype != "canon":
        # K TYPE
        settings.append(eval_string + '.nk_type=\\"' + nktype + '\\"')       # mutation 'prob' (always on)
        settings.append(eval_string + '.nk_prefix=\\"' + reppath + 'nk\\"')

        # K VALUES
        ka, kb = k.split("_")
        settings.append(eval_string + '.K_a=\\"' + ka + '\\"')       # mutation 'prob' (always on)
        settings.append(eval_string + '.K_b=\\"' + kb + '\\"')       # mutation 'prob' (always on)
    else:
        settings.append(eval_string + '.K=\\"' + k + '\\"')       # mutation 'prob' (always on)
        settings.append(eval_string + '.nk_file=\\"' + reppath + 'nk\\"')
    return "\;".join(settings) 
    
def mabe_run(param):
    Path(param["path"]).mkdir(parents=True, exist_ok=True)
    setting = make_settings(param)
    if param["nktype"] == "canon":
        mabefile = mabepath + "settings/NKRank.mabe"
    else:
        mabefile = mabepath + "settings/NKVar.mabe"
    runmabe(runfile, mabefile, setting)

if __name__=="__main__":
    
    mabepath = "./../third-party/MABE2/"
    buildpath = mabepath + "build/"
    runfile = buildpath + "MABE"

    buildmabe(buildpath)

    params = parameters(first=0, last=2)
    print(params)
    #pool = mp.Pool()
    #pool.map(mabe_run, params)
