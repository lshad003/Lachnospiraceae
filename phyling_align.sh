#!/usr/bin/bash -l


#SBATCH -p batch --mem 32gb -N 1 -n 1 -c 32  --out logs/phyling.%A.log

module load phyling/2.0

INPUT_DIR=/bigdata/stajichlab/lshad003/Lachnospiraceae/phyling/cleaned_annotation_Lachnospiraceae

ALIGN_DIR=/bigdata/stajichlab/lshad003/Lachnospiraceae/phyling/align
mkdir -p "$ALIGN_DIR"

phyling align -I "$INPUT_DIR" -o "$ALIGN_DIR" -m bacteria_odb10 -t 6
