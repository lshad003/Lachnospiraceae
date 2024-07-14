import os
import pandas as pd
import ast

# Define paths
checkm_results_dir = "/bigdata/stajichlab/shared/projects/Herptile/Metagenome/Fecal/results_bins_checkm"
input_bins_dir = "/bigdata/stajichlab/shared/projects/Herptile/Metagenome/Fecal/Lachnospiraceae_input"
filtered_bins_dir = "/bigdata/stajichlab/shared/projects/Herptile/Metagenome/Fecal/Lachnospiraceae_input_filtered"

# Create output directory if it doesn't exist
os.makedirs(filtered_bins_dir, exist_ok=True)

# Function to parse CheckM results and filter bins
def filter_bins(checkm_dir):
    filtered_bins = []
    for root, _, files in os.walk(checkm_dir):
        if 'bin_stats_ext.tsv' in files:
            tsv_path = os.path.join(root, 'bin_stats_ext.tsv')
            df = pd.read_csv(tsv_path, sep='\t', index_col=0)
            print(f"Processing {tsv_path}")
            for bin_id, stats_str in df.iterrows():
                stats = ast.literal_eval(stats_str[0])
                if 'Completeness' in stats and 'Contamination' in stats:
                    if stats['Completeness'] > 70 and stats['Contamination'] < 10:
                        filtered_bins.append(bin_id)
    return filtered_bins

# Get filtered bins
filtered_bins = filter_bins(checkm_results_dir)

# Function to copy filtered bins to the new directory
def copy_filtered_bins(filtered_bins, input_dir, output_dir):
    for bin_file in filtered_bins:
        bin_path = os.path.join(input_dir, f"{bin_file}.fa")
        if os.path.exists(bin_path):
            os.system(f"cp {bin_path} {output_dir}")

# Copy filtered bins
copy_filtered_bins(filtered_bins, input_bins_dir, filtered_bins_dir)

print(f"Filtered bins copied to {filtered_bins_dir}")


Explanation:
Reading and Parsing:
Instead of evaluating stats_str.name, the code now evaluates stats_str[0], which contains the dictionary string in the first column.
Filtering:
The script checks if 'Completeness' and 'Contamination' are in the parsed dictionary and applies the filtering criteria.
Copying:
The script copies the filtered bins to the specified directory.
