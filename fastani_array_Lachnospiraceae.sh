#!/usr/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --partition=batch
#SBATCH --job-name=fastani_array
#SBATCH --output=logs/fastani_%A_%a.log
#SBATCH --time=24:00:00

module load fastani/1.34

# Define input and output directories
INPUT_DIR="/bigdata/stajichlab/shared/projects/Herptile/Metagenome/Fecal/Lachnospiraceae_input"
OUTPUT_DIR="/bigdata/stajichlab/shared/projects/Herptile/Metagenome/combo_MAG/fastani_Lachnospiraceae_output"
mkdir -p $OUTPUT_DIR

# Get list of fasta files
FILES=($INPUT_DIR/*.fa)
NUM_FILES=${#FILES[@]}

# Get the chunk index and size from command line arguments
CHUNK_INDEX=$1
CHUNK_SIZE=$2

# Calculate the start and end indices for this chunk
START_IDX=$((CHUNK_INDEX * CHUNK_SIZE))
END_IDX=$((START_IDX + CHUNK_SIZE - 1))

# Get the current job array index
ARRAY_IDX=${SLURM_ARRAY_TASK_ID}
GLOBAL_IDX=$((START_IDX + ARRAY_IDX))

# Calculate the file pair for this job
k=0
for ((i=0; i<NUM_FILES; i++)); do
    for ((j=i+1; j<NUM_FILES; j++)); do
        if [ $k -eq $GLOBAL_IDX ]; then
            FILE1=${FILES[$i]}
            FILE2=${FILES[$j]}
            BASENAME1=$(basename $FILE1 .fa)
            BASENAME2=$(basename $FILE2 .fa)

            # Check if the input files are not empty
            if [ ! -s $FILE1 ]; then
                echo "Error: File $FILE1 is empty or does not exist." >&2
                exit 1
            fi
            if [ ! -s $FILE2 ]; then
                echo "Error: File $FILE2 is empty or does not exist." >&2
                exit 1
            fi

            # Print debugging information
            echo "Running FastANI on $FILE1 and $FILE2"

            # Run FastANI
            fastANI -q $FILE1 -r $FILE2 -o $OUTPUT_DIR/${BASENAME1}_${BASENAME2}_ani.txt --threads 4 --fragLen 1000 --minFraction 0.05

            # Check if the output file was created and is not empty
            if [ ! -s $OUTPUT_DIR/${BASENAME1}_${BASENAME2}_ani.txt ]; then
                echo "Error: Output file $OUTPUT_DIR/${BASENAME1}_${BASENAME2}_ani.txt is empty or was not created." >&2
                exit 1
            fi

            exit 0
        fi
        k=$((k + 1))
    done
done

# If we reach here, the GLOBAL_IDX was out of range
echo "Index $GLOBAL_IDX out of range. No comparison performed."
exit 1

