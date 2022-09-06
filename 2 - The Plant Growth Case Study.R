# Plant Growth Case Study ----

# Load packages ----
# This should already be loaded if you executed the commands in the previous file.
library(tidyverse)

# A built-in data set ----
data(PlantGrowth)

# 1. Descriptive Statistics ----
# The "global mean", e.g. ANOVA Null hypothesis
mean(PlantGrowth$weight)

# group-wise stats
# Here, using functions from dplyr, a part of the Tidyverse
# Thus, using Tidyverse notation
# %>% is the "the pipe operator"
# Pronounce it as "... and then ..."
# Type it using shift + ctrl + m
# The native pipe operator: |> 
# summarise(group_by(PlantGrowth, group), avg = mean(weight), stdev = sd(weight))
PlantGrowth |> 
  group_by(group) |> 
  summarise(avg = mean(weight),
            # global_avg = mean(PlantGrowth$weight),
            stdev = sd(weight))


# PlantGrowth |> 
#   group_by(group)

# 2. Data Visualization ----
# Here, using functions from ggplot2, a part of the Tidyverse
# 3 essential components
# 1 - The data
# 2 - Aesthetics - "mapping" variables onto scales
# scales: x, y, color, size, shape, linetype
# 3 - Geometry - how the plot will look

# box plot
ggplot(PlantGrowth, aes(x = group, y = weight)) +
  geom_boxplot()

# "dot plot"
ggplot(PlantGrowth, aes(x = group, y = weight)) +
  geom_jitter(width = 0.25, alpha = 0.5)

# Q-Q plot (useful, but a bit more advanced):
ggplot(PlantGrowth, aes(sample = weight)) +
  geom_qq() +
  geom_qq_line(color = "red") +
  facet_wrap(~ group, scales = "free_y")

# 3. Inferential Statistics ----
# first step: define a linear model
# ~ means "described by"
plant_lm <- lm(weight ~ group, data = PlantGrowth)
plant_lm

# t-tests
# Typically, use t.test(), but here, we can use:
summary(plant_lm) # p-values are labeled Pr(>|t|)

# 1-way ANOVA
anova(plant_lm)

# For all pair-wise comparisons use 
plant_aov <- aov(weight ~ group, data = PlantGrowth)
TukeyHSD(plant_aov)