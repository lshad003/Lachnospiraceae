import os
import glob

# Directory containing FastANI output files
output_dir = "/bigdata/stajichlab/shared/projects/Herptile/Metagenome/combo_MAG/fastani_Lachnospiraceae_output"
threshold = 95.0
high_ani_pairs = []

# Read each FastANI output file
for filepath in glob.glob(os.path.join(output_dir, "*_ani.txt")):
    with open(filepath, 'r') as f:
        for line in f:
            parts = line.strip().split()
            query = parts[0]
            reference = parts[1]
            ani = float(parts[2])
            if ani >= threshold:
                high_ani_pairs.append((query, reference))

# Write high ANI pairs to a file
output_path = "/bigdata/stajichlab/lshad003/combo_Leila/fastani/high_ani_pairs_Lachnospiraceae_1.txt"
os.makedirs(os.path.dirname(output_path), exist_ok=True)
with open(output_path, 'w') as out_file:
    for pair in high_ani_pairs:
        out_file.write(f"{pair[0]}\t{pair[1]}\n")



import networkx as nx
import os

# Load high ANI pairs
high_ani_pairs = []
input_path = "/bigdata/stajichlab/lshad003/combo_Leila/fastani/high_ani_pairs_Lachnospiraceae_1.txt"
with open(input_path, 'r') as f:
    for line in f:
        parts = line.strip().split()
        high_ani_pairs.append((parts[0], parts[1]))

# Create a graph and add edges for high ANI pairs
G = nx.Graph()
G.add_edges_from(high_ani_pairs)

# Find connected components (each component is a set of highly similar MAGs)
components = list(nx.connected_components(G))

# Write clusters to a file
output_path = "/bigdata/stajichlab/lshad003/combo_Leila/fastani/genome_clusters_Lachnospiraceae_1.txt"
os.makedirs(os.path.dirname(output_path), exist_ok=True)
with open(output_path, 'w') as out_file:
    for i, component in enumerate(components):
        out_file.write(f"Cluster {i+1}:\n")
        for genome in component:
            out_file.write(f"{genome}\n")
        out_file.write("\n")




import networkx as nx
import os

# Load high ANI pairs
high_ani_pairs = []
input_path = "/bigdata/stajichlab/lshad003/combo_Leila/fastani/high_ani_pairs_Lachnospiraceae_1.txt"
with open(input_path, 'r') as f:
    for line in f:
        parts = line.strip().split()
        high_ani_pairs.append((parts[0], parts[1]))

# Create a graph and add edges for high ANI pairs
G = nx.Graph()
G.add_edges_from(high_ani_pairs)

# Find connected components (each component is a set of highly similar MAGs)
components = list(nx.connected_components(G))

# Select one representative per component
representatives = []
for component in components:
    representatives.append(next(iter(component)))

# Write unique MAGs to a file
output_path = "/bigdata/stajichlab/lshad003/combo_Leila/fastani/unique_mags_Lachnospiraceae_1.txt"
os.makedirs(os.path.dirname(output_path), exist_ok=True)
with open(output_path, 'w') as out_file:
    for mag in representatives:
        out_file.write(f"{mag}\n")
