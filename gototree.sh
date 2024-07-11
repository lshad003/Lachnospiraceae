#!/usr/bin/bash -l
#SBATCH -p batch --mem 128gb -N 1 -n 1 -c 32  --out logs/gtotree.%A.log

module load gtotree


# Run GToTree
GToTree -a edited_assembly_result_4.txt -f my_Lachnospiraceae.txt -H /opt/linux/rocky/8.x/x86_64/pkgs/gtotree/1.8.1/share/gtot
ree/hmm_sets/Firmicutes.hmm -t -L Species -j 4 -o Syn-GToTree_6-out
