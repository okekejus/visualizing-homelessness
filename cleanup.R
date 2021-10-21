# Title: 
# Author: Justin Okeke
# Objective: Evaluating the difference in homelessness between 2010-2020 in the US. 

library(pacman)
p_load(tidyverse, openxlsx)


# Loading Raw Data, file gotten from 
# (https://www.hudexchange.info/resource/6291/2020-ahar-part-1-pit-estimates-of-homelessness-in-the-us/)
# Information on homeless populations of different states in the US. 

raw.data.2020 <- read.xlsx("data/2007-2020-PIT-Estimates-by-state.xlsx", sheet = "2020")



# Selecting relevant columns (state, number of COCs, Overall Homeless populaton, broken down homeless populations)
names.2020 <- names(raw.data.2020)
names.2020 <- names.2020[c(1:18)]



# Narrowing down to relevant columns
raw.data.2020 <- raw.data.2020 %>%
  select(all_of(names.2020)) %>%
  tibble()


# Check 
raw.data.2020

# Column 1, 2 and 3 are in the right format, everything else is a number in character form. Need to change them to 
# doubles as well. 

# Using iteration to solve this, convert each column from character to double to allow computations. 
# easier to make the new titles the names of the output columns. 


new_names <- c("State", "Total.Population","CoC", "Total.Homeless", "Homeless.U18", "Homeless.18.to.24", 
              "Homeless.Over.24", "Homeless.Female", "Homeless.Male", "Homeless.Trans", 
              "Homeless.NC", "Homeless.Non.Lat", "Homeless.Lat", "Homeless.White", 
              "Homeless.Black", "Homeless.Asian", "Homeless.Indian", "Homeless.Native")

# Create empty output for loop (15 columns, because only rows 4-18 are being altered.)

output <- tibble(a = rep(0, length(raw.data.2020$State)), 
                b = rep(0, length(raw.data.2020$State)),
                c = rep(0, length(raw.data.2020$State)),
                d = rep(0, length(raw.data.2020$State)),
                e = rep(0, length(raw.data.2020$State)), 
                f = rep(0, length(raw.data.2020$State)),
                g = rep(0, length(raw.data.2020$State)), 
                h = rep(0, length(raw.data.2020$State)),
                i = rep(0, length(raw.data.2020$State)), 
                j = rep(0, length(raw.data.2020$State)), 
                k = rep(0, length(raw.data.2020$State)), 
                l = rep(0, length(raw.data.2020$State)), 
                m = rep(0, length(raw.data.2020$State)), 
                n = rep(0, length(raw.data.2020$State)), 
                o = rep(0, length(raw.data.2020$State)))


shrink <- raw.data.2020 %>%
  select(c(4:18))


for (i in seq_along(shrink)) {
  output[[i]] <- as.numeric(shrink[[i]])
}

shrink <- cbind(raw.data.2020[1], raw.data.2020[2], raw.data.2020[3], output) %>%
  tibble()

names(shrink) <- new_names

new.data.2020 <- shrink

remove(raw.data.2020, output)


# Edit: combining the under 18 and 18 to 24 groups so the categories are under 24 and over 24. 
new.data.2020 <- new.data.2020 %>%
  mutate(Homeless.Under.24 = Homeless.U18 + Homeless.18.to.24) %>%
  select(-c(Homeless.U18, Homeless.18.to.24)) %>%
  select(State:Homeless.Over.24, Homeless.Under.24, everything())



# Including Regions ---------------------------------------------------------------------------

regions = read_csv("data/Regions.csv")

# csv file separating each state into regions. Data collected myself using Wikipedia and Census 
# information.

# Will be removing the "Total" column as it makes things slightly difficult, and can easily 
# be calculated with a colSums() function.

new.data.2020 = new.data.2020[-c(57), ]


new.data.2020 = merge(new.data.2020, regions) %>%
  tibble()
 
remove(regions)
# Create new files ----------------------------------------------------------------------------

write.csv(new.data.2020, "data/New.Data.2020.csv")

