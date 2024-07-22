# Load necessary libraries
library(ape)
library(ggtree)
library(phangorn)
library(dplyr)
library(ggplot2)
library(viridis)
library(ggnewscale)
library(RColorBrewer)

# Define the path to the tree file
tree_file <- "/bigdata/stajichlab/lshad003/Lachnospiraceae/phyling/phyling-tree-20240715-170051-0700/final_tree.nw"
metadata_file <- "/bigdata/stajichlab/lshad003/Lachnospiraceae/phyling/cut134_tip_names_with_animal_feedinghabit.tsv"

# Read the tree file
phylo_tree <- read.tree(tree_file)

# Read the metadata files
metadata <- read.table(metadata_file, header = TRUE, sep = "\t", fill = TRUE, quote = "")

# Define species-bin mapping with bin names ending in .aa
species_bins <- data.frame(
  Species = c("Species1", "Species1", "Species1", "Species1", "Species1", "Species1", "Species1",
              "Species2", "Species2", "Species2", "Species2", "Species2",
              "Species3", "Species3", "Species3", "Species3",
              "Species4", "Species4", "Species4", "Species4", "Species4", "Species4", "Species4",
              "Species5", "Species5", "Species5", "Species5",
              "Species6", "Species6", "Species6", "Species6",
              "Species7", "Species7", "Species7", "Species7", "Species7", "Species7", "Species7", "Species7", "Species7",
              "Species8", "Species8", "Species8", "Species8", "Species8",
              "Species9", "Species9", "Species9", "Species9",
              "Species10", "Species10", "Species10", "Species10",
              "Species11", "Species11", "Species11", "Species11", "Species11",
              "Species12", "Species12", "Species12", "Species12"),
  Bin = c("UHM27.10829_R.bin.15.aa", "UHM36.10832_R.bin.36.aa", "UHM245.23042_R.bin.35.aa", "UHM20.10828_R.bin.51.aa", "UHM40.10834_R.bin.33.aa", "UHM909.23059_R.bin.35.aa", "UHM56.10839_R.bin.46.aa",
          "UHM982.23046_R.bin.57.aa", "UHM975.23062_R.bin.181.aa", "UHM969.23061_R.bin.137.aa", "UHM1080.23066_R.bin.71.aa", "UHM984.23047_R.bin.125.aa",
          "UHM984.23047_R.bin.131.aa", "UHM978.23063_R.bin.88.aa", "UHM979.23045_R.bin.235.aa", "UHM1080.23066_R.bin.63.aa",
          "UHM979.23045_R.bin.174.aa", "UHM982.23046_R.bin.100.aa", "UHM993.23065_R.bin.20.aa", "UHM967.23060_R.bin.148.aa", "UHM975.23062_R.bin.198.aa", "UHM1073.23039_R.bin.159.aa", "UHM1088.23067_R.bin.96.aa",
          "UHM979.23045_R.bin.54.aa", "UHM993.23065_R.bin.174.aa", "UHM982.23046_R.bin.75.aa", "UHM978.23063_R.bin.27.aa",
          "UHM978.23063_R.bin.21.aa", "UHM967.23060_R.bin.139.aa", "UHM979.23045_R.bin.141.aa", "UHM975.23062_R.bin.126.aa",
          "UHM979.23045_R.bin.166.aa", "UHM967.23060_R.bin.182.aa", "UHM1073.23039_R.bin.32.aa", "UHM969.23061_R.bin.151.aa", "UHM984.23047_R.bin.80.aa", "UHM993.23065_R.bin.195.aa", "UHM978.23063_R.bin.19.aa", "UHM1080.23066_R.bin.200.aa", "UHM975.23062_R.bin.131.aa",
          "UHM967.23060_R.bin.124.aa", "UHM969.23061_R.bin.109.aa", "UHM1080.23066_R.bin.48.aa", "UHM982.23046_R.bin.59.aa", "UHM989.23064_R.bin.159.aa",
          "UHM1080.23066_R.bin.82.aa", "UHM984.23047_R.bin.78.aa", "UHM1073.23039_R.bin.7.aa", "UHM993.23065_R.bin.82.aa",
          "UHM1088.23067_R.bin.13.aa", "UHM975.23062_R.bin.50.aa", "UHM978.23063_R.bin.70.aa", "UHM1080.23066_R.bin.232.aa",
          "UHM989.23064_R.bin.175.aa", "UHM967.23060_R.bin.112.aa", "UHM978.23063_R.bin.72.aa", "UHM969.23061_R.bin.113.aa", "UHM979.23045_R.bin.6.aa",
          "UHM1088.23067_R.bin.91.aa", "UHM984.23047_R.bin.160.aa", "UHM975.23062_R.bin.184.aa", "UHM969.23061_R.bin.28.aa")
)

# Create a manually defined color palette for the species
species_colors <- c(
  "Species1" = "#1f77b4", # blue
  "Species2" = "#ff7f0e", # orange
  "Species3" = "#2ca02c", # green
  "Species4" = "#d62728", # red
  "Species5" = "#9467bd", # purple
  "Species6" = "#8c564b", # brown
  "Species7" = "#e377c2", # pink
  "Species8" = "#7f7f7f", # gray
  "Species9" = "#bcbd22", # yellow
  "Species10" = "#17becf", # cyan
  "Species11" = "#1f78b4", # slightly different blue
  "Species12" = "#ff7f0e"  # slightly different orange
)

# Merge the species_bins data with the phylo_tree tip labels
tip_data <- data.frame(label = phylo_tree$tip.label)
tip_data <- left_join(tip_data, species_bins, by = c("label" = "Bin"))

# Ensure the Species column exists in the tip_data
if (!"Species" %in% colnames(tip_data)) {
  stop("Species column not found in tip_data")
}

# Check if the bootstrap values are present
if (!is.null(phylo_tree$node.label)) {
  # Root the tree (midpoint rooting)
  rooted_tree <- midpoint(phylo_tree)
  
  # Create a ggtree object with bootstrap values in a circular layout
  base_tree <- ggtree(rooted_tree, layout = "circular") %<+% tip_data +
    geom_tiplab(aes(label = label, color = Species), size = 10, align = FALSE) +
    geom_text2(aes(subset = !isTip, label = label), hjust = -0.3, size = 5) +
    scale_color_manual(values = species_colors, name = "Species") +
    theme_tree2() +
    theme(legend.position = "right",
          legend.text = element_text(size = 80),  # Increase legend text size
          legend.title = element_text(size = 90)) # Increase legend title size
  
  # Merge tree data with metadata
  tree_data <- data.frame(Bin = rooted_tree$tip.label, y = 1:length(rooted_tree$tip.label))
  colnames(metadata) <- c("Bin", "Animal", "FeedingHabit")  # Ensure metadata column names match
  final_merged_data <- merge(tree_data, metadata, by = "Bin", all.x = TRUE)
  
  # Debugging: Print the first few rows of final_merged_data to verify content
  print(head(final_merged_data))
  
  # Ensure the merged data has the correct columns
  if (!all(c("Animal", "FeedingHabit") %in% colnames(final_merged_data))) {
    stop("The merged data does not contain the required columns: 'Animal', 'FeedingHabit'.")
  }
  
  # Manually define color palettes for Animal and FeedingHabit
  animal_colors <- c("Frog" = "#1b9e77", "Salamander" = "#d95f02", "Lizard" = "#7570b3", "Turtle" = "#e7298a", "Toad" = "#66a61e", "Tortoise" = "#e6ab02", "Snake" = "#a6761d", "Wood_frog" = "#666666")
  feedinghabit_colors <- c("Insectivore" = "#440154FF", "Carnivore" = "#31688EFF", "Herbivore" = "#35B779FF", "Omnivore" = "#DE725FFF")
  
  # Add tiles for Animal and FeedingHabit with increased radius
  base_tree <- base_tree + 
    geom_tile(data = final_merged_data, aes(x = 1, y = y, fill = Animal), width = 0.02, height = 1) +
    scale_fill_manual(values = animal_colors) +
    new_scale_fill() +
    geom_tile(data = final_merged_data, aes(x = 1.03, y = y, fill = FeedingHabit), width = 0.02, height = 1) +
    scale_fill_manual(values = feedinghabit_colors)
  
  # Display the plot
  print(base_tree)
} else {
  stop("Bootstrap values are not found in the tree object.")
}

