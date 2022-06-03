# Generate and analyze a simple genome for the rank epistasis project

import random
import copy
import csv

def fitness_func(gen, result_sum=True):
    # avoid integer overflow problems; numpy's sum/prod functions default to int32 and are a pain to change
    n = len(gen)
    n_sum = n//2

    res_sum = 0
    res_prod = 1
    
    for i in range(0, n_sum):
        res_sum += gen[i]
    for i in range(n_sum, n):
        res_prod *= gen[i]

    return res_sum + res_prod if result_sum else res_sum * res_prod

def mutants(gen, alleles, randseed=0):
    # Create single mutants for every number at every site
    filelines = []
    mut_gen = copy.deepcopy(gen) # figure this out...
    fitness_wt = fitness_func(mut_gen)
    for i, ival in enumerate(gen):
        pos_ref = i
        for allele_ref in alleles:           # pick which allele to mutate to
            if allele_ref != ival:    
                mut_gen[i] = allele_ref      # create single mutant of this allele
                fitness_ref = fitness_func(mut_gen)  # record its fitness
                for j, jval in enumerate(gen):
                    pos_mut = j
                    for allele_mut in alleles:
                        if allele_mut != jval and j != i:
                            mut_gen[j] = allele_mut
                            fitness_mut = fitness_func(mut_gen)
                            mut_gen[j] = jval
                            line = [randseed, pos_ref, pos_mut, fitness_wt, fitness_ref, fitness_mut, allele_ref, allele_mut]
                            filelines.append([str(x) for x in line])
                mut_gen[i] = ival
    return filelines


def make_genome(n=20, randseed=0, minval=1, maxval=4):
    random.seed(randseed)
    genome = [random.randint(minval, maxval) for _ in range(n)]
    alleles = list(range(minval, maxval+1))
    return genome, alleles

def main():

    num_reps = 100

    dirpath = "../../../data/"
    filename = "merged_addmult.csv"

    filepath = dirpath + filename

    filehead = ["rep","pos_REF","pos_MUT","score_WT","score_REF","score_MUT","allele_REF","allele_MUT"]
    filelines = [filehead]

    for i in range(num_reps):
        genome, alleles = make_genome(randseed=i)
        filelines = filelines + mutants(genome, alleles, randseed=i)
        print("Seed: ", i)

    with open(filepath, 'w') as f:
        write = csv.writer(f)
        write.writerows(filelines)

if __name__=="__main__":
    main()
    