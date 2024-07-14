import os
import pandas as pd

# Define the base directory
base_dir = "/bigdata/stajichlab/shared/projects/Herptile/Metagenome/Fecal/results_bins_gtkdb"

# List of directories to process
directories = [
    "Alig_mis", "STP248.12601", "STP294.12602", "STP51B.12603", "STP572.12604", 
    "STP672.12605", "STP701.12606", "STP748.12607", "UHM102.10840", "UHM1073.23039", 
    "UHM1080.23066", "UHM1088.23067", "UHM1110.23068", "UHM1171.23069", "UHM1210.23070", 
    "UHM1225.23071", "UHM1228.23072", "UHM1327.23073", "UHM17.10826", "UHM18.10827", 
    "UHM20.10828", "UHM207.23041", "UHM245.23042", "UHM27.10829", "UHM298.23040", 
    "UHM31.10830", "UHM33.10831", "UHM36.10832", "UHM38.10833", "UHM40.10834", 
    "UHM41.10835", "UHM43.10836", "UHM44.10837", "UHM45.10838", "UHM440.10834", 
    "UHM467.23049", "UHM56.10839", "UHM892.23050", "UHM893.23051", "UHM896.23052", 
    "UHM897.23053", "UHM899.23043", "UHM902.23054", "UHM904.23055", "UHM905.23056", 
    "UHM906.23057", "UHM907.23058", "UHM909.23059", "UHM967.23060", "UHM969.23061", 
    "UHM973.23044", "UHM975.23062", "UHM978.23063", "UHM979.23045", "UHM982.23046", 
    "UHM984.23047", "UHM989.23064", "UHM993.23065", "UHM997.23048"
]

# Initialize a list to store bin names in the family Lachnospiraceae
Lachnospiraceae_bins = []

# Function to read the gtdbtk.bac120.summary.tsv file and extract relevant bin names
def process_summary_file(file_path):
    df = pd.read_csv(file_path, sep='\t')
    Lachnospiraceae_rows = df[df['classification'].str.contains('f__Lachnospiraceae', na=False)]
    Lachnospiraceae_bins.extend(Lachnospiraceae_rows['user_genome'].tolist())

# Iterate through each directory and process the gtdbtk.bac120.summary.tsv file if it exists
for dir_name in directories:
    summary_file_path = os.path.join(base_dir, dir_name, "classify", "gtdbtk.bac120.summary.tsv")
    if os.path.exists(summary_file_path):
        process_summary_file(summary_file_path)

# Define the output path
output_path = "/bigdata/stajichlab/lshad003/combo_Leila/fastani/Lachnospiraceae/Lachnospiraceae_bins.tsv"

# Write the results to a TSV file
with open(output_path, 'w') as file:
    for bin_name in Lachnospiraceae_bins:
        file.write(f"{bin_name}\n")

print(f"Bin names in the family Lachnospiraceae have been written to {output_path}")


#Bin names in the family Lachnospiraceae have been written to /bigdata/stajichlab/lshad003/combo_Leila/fastani/Lachnospiraceae/Lachnospiraceae_bins.tsv

import os
import shutil

# Define the base directory containing the project directories and the output directory
base_dir = "/bigdata/stajichlab/shared/projects/Herptile/Metagenome/Fecal/results"
output_dir = "/bigdata/stajichlab/shared/projects/Herptile/Metagenome/Fecal/Lachnospiraceae_input"

# Create the output directory if it doesn't exist
os.makedirs(output_dir, exist_ok=True)

# Path to the file containing the list of bin names
bin_list_path = "/bigdata/stajichlab/lshad003/combo_Leila/fastani/Lachnospiraceae/Lachnospiraceae_bins.tsv"

# Read the list of bin names
with open(bin_list_path, 'r') as file:
    bin_names = [line.strip() for line in file]

# Function to find and copy the fasta files
def copy_fasta_files():
    for dir_name in os.listdir(base_dir):
        dir_path = os.path.join(base_dir, dir_name)
        if os.path.isdir(dir_path):
            bins_path = os.path.join(dir_path, "bins")
            if os.path.exists(bins_path):
                for bin_name in bin_names:
                    fasta_file_name = bin_name + ".fa"
                    fasta_file_path = os.path.join(bins_path, fasta_file_name)
                    if os.path.exists(fasta_file_path):
                        shutil.copy(fasta_file_path, output_dir)
                        print(f"Copied {fasta_file_name} to {output_dir}")

# Copy the fasta files
copy_fasta_files()

print("Copying of fasta files completed.")
