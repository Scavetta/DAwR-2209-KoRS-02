# SILAC Analysis
# Protein profiles during myocardial cell differentiation

# Load packages ----
library(tidyverse)
library(glue)

# Part 0: Import data ----
protein_df <- read.delim("data/Protein.txt", stringsAsFactors = FALSE)

# Examine the data:

str(protein_df)
glimpse(protein_df)


# Quantify the contaminants ----
sum(protein_df$Contaminant == "+")

# Alternative
# Make a contigency table (i.e. 2x2)
table(protein_df$Contaminant) # output is named vecto
# e.g. for other data
table(mtcars$cyl, mtcars$gear)



# Proportion of contaminants

# Percentage of contaminants (just multiply proportion by 100)

# Transformations & cleaning data ----

# Remove contaminants ====


# log 10 transformations of the intensities ====


# Add the intensities ====

# log2 transformations of the ratios ====

# Bare bones old school method:
protein_df$Ratio.H.M <- log2(protein_df$Ratio.H.M)
protein_df$Ratio.M.L <- log2(protein_df$Ratio.M.L)

# Some examples from class
# log2(protein_df$Ratio.H.M) -> protein_df$Ratio.H.M
# protein_df$Ratio.M.L <- log2(protein_df$Ratio.M.L)

# More efficient ways:
# select all the columns which we want to perform the transformation
# and then apply it only there
# i.e. all columns that begin with "R" and don't end with "Sig"

# find out how to select only the required columns:
protein_df |> 
  as_tibble() |> 
  select(starts_with("R"), -ends_with("Sig"))

# using across
protein_df <- read.delim("data/Protein.txt", stringsAsFactors = FALSE)
protein_df |> 
  as_tibble() |> 
  mutate(across(c(starts_with("R"), -ends_with("Sig")), log2))

## this will also work
protein_df %>% 
  mutate_at(vars(starts_with("Rat"),-ends_with("Sig")), log2) -> protein_df_mutate


# How to make tidy data:
# first work on the ratios
protein_df |> 
  as_tibble() |> 
  filter(Contaminant != "+") |> 
  select(Uniprot, starts_with("R"), -ends_with("Sig")) |> 
  pivot_longer(-Uniprot, names_to = "Ratio", values_to = "Exp") |>                                 # Specify the ID columns
  # pivot_longer(c(Ratio.M.L, Ratio.H.M, Ratio.H.L)) |>     # Specify the MEASURE columns
  mutate(Ratio = str_remove(Ratio, "Ratio."),
         Exp = log2(Exp)) -> Ratios_only

# Then work on the Inensities:
protein_df |> 
  as_tibble() |> 
  filter(Contaminant != "+") |> 
  select(Uniprot, starts_with("I")) |> 
  mutate(across(starts_with("I"), log10),
         Intensity.H.M = Intensity.H + Intensity.M,
         Intensity.M.L = Intensity.M + Intensity.L) |> 
  select(Uniprot, Intensity.H.M, Intensity.M.L) |> 
  pivot_longer(-Uniprot, names_to = "Ratio", values_to = "Int") |>                                 # Specify the ID columns
  mutate(Ratio = str_remove(Ratio, "Intensity.")) -> Intensity_only

Intensity_only |> 
  inner_join(Ratios_only) -> protein_df_tidy

# one plotting command:

ggplot(protein_df_tidy, aes(Exp, Int)) +
  geom_point() +
  facet_grid(cols = vars(Ratio))

# using the raw, messy data:
ggplot(protein_df, aes(Ratio.H.M, Intensity.H.M)) +
  geom_point()
ggplot(protein_df, aes(Ratio.M.L, Intensity.M.L)) +
  geom_point()

# Part 2: Query data using filter() ----
# Exercise 9.2 (Find protein values) ====

# See extra file "example from class.R"



# Exercise 9.3 (Find significant hits) and 10.2 ====
# For the H/M ratio column, create a new data 
# frame containing only proteins that have 
# a p-value less than 0.05


# Exercise 10.4 (Find top 20 values) ==== 


# Exercise 10.5 (Find intersections) ====

