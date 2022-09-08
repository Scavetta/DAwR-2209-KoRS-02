# Element 7: Tidyverse -- tidyr ----

# Load packages ----
# This should already be loaded if you executed the commands in the previous file.
library(tidyverse)

# Get a play data set:
PlayData <- read_tsv("data/PlayData.txt")

names(PlayData)
# ID variables: "type"   "time"  (i.e. categorical variables)
# MEASURE variables: "height" "width"

# Let's see the scenarios we discussed in class:
# Scenario 1: Transformation height & width
PlayData$height/PlayData$width


# Scenario 2: Transformation across time
# type A time1/time2 for height 10/20 = 0.5
# type A time1/time2 for width 50/60 = 0.83
# type B time1/time2 for height 30/40 = 0.75
# type B time1/time2 for width 70/80 = 0.875

# select "type", filter for A, then do division on "height"
# Going in the right direction, but not quite right:
PlayData |> 
  filter(type == "A") |> 
  select(height) |> 
  summarise(diff = diff(height))

# bare-bones solutions:
PlayData$height[1]/PlayData$height[2] # a bit dangerous

# Explicit, tedious - REALLY want to avoid stuff like this!!!
PlayData$height[PlayData$type == "A" & PlayData$time == 1]/PlayData$height[PlayData$type == "A" & PlayData$time == 2]
PlayData$height[PlayData$type == "B" & PlayData$time == 1]/PlayData$height[PlayData$type == "B" & PlayData$time == 2]
PlayData$width[PlayData$type == "A" & PlayData$time == 1]/PlayData$width[PlayData$type == "A" & PlayData$time == 2]
PlayData$width[PlayData$type == "B" & PlayData$time == 1]/PlayData$width[PlayData$type == "B" & PlayData$time == 2]

# (wrong) tidyverse way, but tedious
PlayData |> 
  group_by(type) |> 
  summarise(ratio_h = height[time == 1]/height[time == 2],
            ratio_w = width[time == 1]/width[time == 2])

# For the other scenarios, tidy data would be a 
# better starting point:
# 4 arguments
# 1 - data
# 2,3 - key,value pair - i.e. name for OUTPUT
# 4 - the ID or the MEASURE variables

# using ID variables ("exclude" using -)
pivot_longer(PlayData, 
             names_to = "key",
             values_to = "value",
             -c("type", "time"))

# using MEASURE variables
PlayData_t <- pivot_longer(PlayData, 
                           names_to = "key", 
                           values_to = "value", 
                           c("height", "width"))


PlayData |> 
  pivot_longer(-c("type", "time"),
             names_to = "key",
             values_to = "value") -> PlayData_t

# Scenario 2: Transformation across time 1 & 2
# difference from time 1 to time 2 for each type and key
# time 2 - time 1
# we only want one value as output
# e.g. time 1/time 2 as above
PlayData_t |> 
  group_by(type, key) |> 
  summarise(ratio = value[time == 1] / value[time == 2])

# How does R see the data
PlayData_t |> 
  group_split(type, key)

# standardize to time 1 (e.g. relative to time 1)
PlayData_t |> 
  group_by(type, key) |> 
  mutate(fold_inc = value / value[time == 1]) |> 
  arrange(type, key) -> FC

ggplot(FC, aes(x = time, y = fold_inc, color = type)) +
  geom_line() +
  facet_grid(cols = vars(key))



# Scenario 3: Transformation across type A & B
# A/B for each time and key

