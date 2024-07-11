#!/usr/bin/bash -l

#SBATCH -p batch --mem 128gb -N 1 -n 1 -c 32  --out logs/phyling.%A.log

module load phyling/2.0

pep=/bigdata/stajichlab/shared/projects/Herptile/Metagenome/Fecal/Lachnospiraceae_input

align=/bigdata/stajichlab/lshad003/Lachnospiraceae/phyling



phyling align -I $pep -o $align -m HMM/firmicutes_odb10/hmms -t 16
