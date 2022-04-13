import itertools as iter

def parameters(first=0, last=100):

    # List of dictionaries of parameters
    params = []

    # reps
    datapath = "./../../data/"
    reppath = datapath + "reps/"

    reps = [str(x).rjust(2, '0') for x in range(first, last)]
    
    kvals = ["0", "1", "2", "4", "8"]
    param_pairs = iter.product(reps, ["canon"], kvals)
    
    nkvars = ["half", "merged"]
    kpairs = ["_".join(x) for x in list(iter.combinations_with_replacement(kvals, r=2))]
    param_vals = iter.product(reps, nkvars, kpairs)
    
    parameters = list(param_vals) + list(param_pairs)
    
    for param in parameters:
        info = {}
        rep, nktype, k = param
        parampath = "SEED_" + rep + "__NK_" + nktype + "__K_" + k + "/"
        dirpath = reppath + parampath 
        info["path"] = dirpath
        info["rep"] = rep
        info["nktype"] = nktype
        info["k"] = k
        params.append(info)
    
    return params