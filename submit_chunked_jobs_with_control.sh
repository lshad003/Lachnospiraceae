#!/usr/bin/bash -l

# Define constants
TOTAL_COMPARISONS=224115  # Correct number of pairwise comparisons for 670 files
CHUNK_SIZE=2000
NUM_CHUNKS=$(( (TOTAL_COMPARISONS + CHUNK_SIZE - 1) / CHUNK_SIZE ))
SMALL_ARRAY_SIZE=200  # Define smaller array size
MAX_RUNNING_JOBS=20  # Adjust this to the maximum number of jobs you are allowed to run concurrently
SLEEP_TIME=60  # Time in seconds to wait before checking job status

# Function to get the number of currently running jobs
get_running_jobs_count() {
    squeue -u $USER -h -t R,PD | wc -l
}

# Function to check if we can submit more jobs
can_submit_more_jobs() {
    local running_jobs=$(get_running_jobs_count)
    if [ "$running_jobs" -lt "$MAX_RUNNING_JOBS" ]; then
        return 0  # True: we can submit more jobs
    else
        return 1  # False: we cannot submit more jobs
    fi
}

# Submit job arrays in smaller chunks with control
for ((chunk=0; chunk<NUM_CHUNKS; chunk++)); do
    for ((sub_chunk=0; sub_chunk<CHUNK_SIZE; sub_chunk+=SMALL_ARRAY_SIZE)); do
        while ! can_submit_more_jobs; do
            echo "Maximum running jobs reached. Waiting..."
            sleep "$SLEEP_TIME"
        done

        start_index=$sub_chunk
        end_index=$((sub_chunk + SMALL_ARRAY_SIZE - 1))
        if [ $end_index -ge $CHUNK_SIZE ]; then
            end_index=$((CHUNK_SIZE - 1))
        fi

        job_id=$(sbatch --array=$start_index-$end_index fastani_array_Lachnospiraceae.sh $chunk $CHUNK_SIZE | awk '{print $NF}')
        if [ -n "$job_id" ]; then
            echo "Submitted job $job_id for chunk $chunk, sub-chunk $start_index-$end_index"
        else
            echo "Failed to submit job for chunk $chunk, sub-chunk $start_index-$end_index"
        fi

        # Wait a bit before submitting the next job to avoid rapid-fire submissions
        sleep 10
    done
done


#Key Points
#Total Comparisons: Ensure that the TOTAL_COMPARISONS is set correctly based on the number of files.
#Correct Index Calculation: The script should accurately calculate the indices for each job.
#Controlled Submissions: Ensure the script controls job submissions and waits appropriately to stay within the cluster's job submission limits.
#Usage
#Make the scripts executable:

#chmod +x submit_chunked_jobs_with_control.sh fastani_array_Lachnospiraceae.sh
#Run the submission script:

#./submit_chunked_jobs_with_control.sh
