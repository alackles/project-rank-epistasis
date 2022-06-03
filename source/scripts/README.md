This folder contains the scripts necessary for data pre-processing for the metric.

Follow this guide to execute scripts in the appropriate order.
# Rank Epistasis on NK Landscapes

## Generate Data & Tidify
1. `rep.py` : generates data (=> data/reps/SEED_*/mutants.csv)
2. `repmerge.py` : merges data to long format (data/reps/SEED_*/mutants.csv => data/merged_*.csv)

## Select an Experimental Condition

Each of the following sections must be performed on the scripts in either the `canon/` or `var/` directory based on which set of results you want to generate. Only one set of steps is provided as running the scripts is identical for each but the content of the scripts differ.
## Generate Summary Data

1. `wilcoxon_*.R` : generates rank epistasis metric $$\omega$$ (data/merged_*.csv => data/wilcoxon_*.csv)
2. `summary_*.R` : creates summary of wilcoxon metric across replicates (data/wilcoxon_*.csv => data/summary_*.csv)

## Visualize Results

1. `plot_summary_*.R` : generates graph of results (data/summary_*.csv => figs/summary_*.csv)

# Rank Epistasis and Additive/Multiplicative Comparison

## Generate Data

1. `addmult/addmult.py` : generates data for additive/multiplicative comparison (=> data/merged_addmult.csv)
## Generate Summary Data

1. `wilcoxon_addmult.R` : generates rank epistasis metric $$\omega$$ (data/merged_addmult.csv => data/wilcoxon_addmult.csv)
2. `eps_addmult.R` : generates standard epistasis metric $$\epsilon$$ (data/merged_addmult.csv => data/eps_addmult.csv)
3. `summary_addmult.R` : creates tidy summary of wilcoxon and epsilon metric across replicates (data/wilcoxon_addmult.csv => data/summary_addmult.csv)

## Visualize Results

1. `plot_summary_addmult.R` : generates graph of results (data/summary_addmult.csv => figs/summary_addmult.csv)