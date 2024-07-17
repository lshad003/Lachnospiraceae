import os

# Path to the input file
input_file_path = "/bigdata/stajichlab/lshad003/Lachnospiraceae/blast/output_name.txt"

# Base path for the directories
base_path = "/bigdata/stajichlab/shared/projects/Herptile/Metagenome/Fecal/results_bins_gtkdb"

# Function to extract taxonomy
def extract_taxonomy(file_name):
    # Extract the directory name using the first part of the file name
    dir_name = file_name.split('_')[0]
    
    # Build the path to the classification file
    classify_path = os.path.join(base_path, dir_name, "classify", "gtdbtk.bac120.summary.tsv")
    
    print(f"Looking for file: {classify_path}")

    if not os.path.exists(classify_path):
        print(f"Classification file not found for: {classify_path}")
        return "No classification file"

    with open(classify_path, 'r') as f:
        for line in f:
            columns = line.strip().split('\t')
            if columns[0] == file_name:
                return columns[1]
    return "Unclassified"

# Read the input file
with open(input_file_path, 'r') as f:
    file_names = f.readlines()

# Extract taxonomy for each file and store results
results = []
for file_name in file_names:
    file_name = file_name.strip()
    taxonomy = extract_taxonomy(file_name)
    results.append(f"{file_name}\t{taxonomy}")

# Write results to an output file
output_file_path = "/bigdata/stajichlab/lshad003/Lachnospiraceae/blast/output_with_taxonomy.txt"
with open(output_file_path, 'w') as f:
    for result in results:
        f.write(result + '\n')

print(f"Results written to {output_file_path}")



























extract_taxonomy(file_name): This function takes a file name as input and returns its taxonomic classification.
dir_name = file_name.split('_')[0]: Extracts the directory name from the file name by splitting it at the underscore and taking the first part.
classify_path = os.path.join(base_path, dir_name, "classify", "gtdbtk.bac120.summary.tsv"): Constructs the path to the classification file by combining the base path, directory name, and the specific classification file name.
if not os.path.exists(classify_path): Checks if the classification file exists.
with open(classify_path, 'r') as f: Opens the classification file for reading.
for line in f: Iterates through each line of the file.
columns = line.strip().split('\t'): Splits the line into columns based on tabs.
if columns[0] == file_name: Checks if the first column (genome name) matches the file name.
return columns[1]: Returns the classification if found.
return "Unclassified": Returns "Unclassified" if no matching file name is found in the classification file.
