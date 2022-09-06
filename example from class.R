# An example of indexing with different methods




# find significant hits for H/M ratio (i.e. Ratio.H.M.Sig < 0.05)

# The tidyverse way -> dplyr::filter()
# With contaminants included, 108 rows
protein_df |> 
  as_tibble() |> 
  filter(Ratio.H.M.Sig < 0.05)

protein_df$Ratio.H.M.Sig < 0.05

# using subset
# Also 108 rows
subset(protein_df, protein_df$Ratio.H.M.Sig < 0.05) |> 
  glimpse()

# using [] we get 486, except if we also filter for actual numbers only
protein_df[protein_df$Ratio.H.M.Sig < 0.05 & !is.na(protein_df$Ratio.H.M.Sig),c("Uniprot", "Ratio.H.M.Sig")] |> 
  glimpse()

