#!/usr/bin/bash -l

#SBATCH -p batch --mem 32gb -N 1 -n 1 -c 32  --out logs/phyling.%A.log

module load phyling/2.0


ALIGN_DIR=/bigdata/stajichlab/lshad003/Lachnospiraceae/phyling/align


phyling tree -I $ALIGN_DIR -m iqtree -t 16
