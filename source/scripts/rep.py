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

from repparse import parameters 

def buildmabe(buildpath):
    os.system("cd " + buildpath + "&& make clean && make && cd ../../../scripts/")

def runmabe(exec, mabefile, params):
  # exec: path to MABE executable
  # params: command-line parameters
  # first: first replicate
  # last: last replicate (works like python, so not inclusive)
  os.system(exec + " -f " + mabefile + " -s " + params)

def make_settings(param, mabepath):
    reppath = param["path"]
    seed = str(int(param["rep"])) # remove leading 0s
    nktype = param["nktype"]
    k = param["k"]

    eval_string = "eval_nkrank" if nktype == "canon" else "eval_nkvar"

    settings = []

    # RANDOM SEED
    settings.append('random_seed=\\"' + seed + '\\"')

    # OUTPUT
    settings.append('output.filename=\\"' + reppath + 'output.csv\\"')
    settings.append(eval_string + '.mutant_file=\\"' + reppath + 'mutants.csv\\"')
    settings.append(eval_string + '.nk_prefix=\\"' + reppath + 'nk\\"')
    settings.append(eval_string + '.genome_file=\\"' + reppath + 'ref_genome.csv\\"')

    if nktype != "canon":
        # K TYPE
        settings.append('eval_nkvar.nk_type=\\"' + nktype + '\\"')       # mutation 'prob' (always on)

        # K VALUES
        ka, kb = k.split("_")
        settings.append('eval_nkvar.K_a=\\"' + ka + '\\"')       # mutation 'prob' (always on)
        settings.append('eval_nkvar.K_a=\\"' + kb + '\\"')       # mutation 'prob' (always on)
    
    return "\;".join(settings) 
    

def main():
    mabepath = "./../third-party/MABE2/"
    buildpath = mabepath + "build/"
    runfile = buildpath + "MABE"

    params = parameters()
    
    buildmabe(buildpath)

    for param in params:
        Path(param["path"].mkdir(parents=True, exist_ok=True))
        setting = make_settings(param, mabepath)
        if param["nktype"] == "canon":
            mabefile = mabepath + "settings/NKRank.mabe"
        else:
            mabefile = mabepath + "settings/NKVar.mabe"
        runmabe(runfile, mabefile, setting)