# Homelessness in the World 
# Author: Justin Okeke 
# Date: September 20th, 2021


library(pacman) # package manager

p_load(leaflet, # map creation
       tigris, # US Data 
       rgdal, # Edit shapefiles
       tidyverse, # data transformation/visualization
       viridis) # color pallettes 

# Creating the Maps ----------------------------------------------------------------------------------------------------

# United States 
united.states = states(cb = TRUE)

united.states %>%
    leaflet() %>%
    addTiles() %>%
    addPolygons(popup = ~NAME)


# Data ------------------------------------------------------------------------------------------------------------

us.data.2020 <- read_csv("data/New_Data_2020.csv") %>%
    select(-c(1)) 


# Map -------------------------------------------------------------------------------------------------

# United States 
us.data.2020$State %in% united.states$STUSPS # check the states match
united.states.merged.home <- geo_join(united.states, us.data.2020, "STUSPS", "State") # combine data and shapefile
united.states.merged.home <- subset(united.states.merged.home, !is.na(Total.Homeless)) # remove state with no data 

remove(united.states)


popup.home <- paste0(united.states.merged.home$NAME, # Popup values when clicked, per state.
                     "<br> Homelessness Rate: ", 
                     as.character(round(united.states.merged.home$Homeless.Rate, digits = 0)),
                     " in 10,000", "<br> Total Homeless: ", 
                     as.character(united.states.merged.home$Total.Homeless))

us.m <- leaflet(united.states.merged.home) %>%
    addProviderTiles("CartoDB.Positron") %>%
    setView(-96, 37.8, 4) # base map

us.m


bins <- c(0, 10, 20, 50, 70, 100, 400) # creating intervals for the colors. 
pal <- colorBin("plasma", domain = united.states.merged.home$Homeless.Rate, bins = bins, pretty = FALSE)


total.homeless.map <- us.m %>%
    addPolygons(fillColor = ~pal(Homeless.Rate), # colored shapes to represent data 
                weight = 2, 
                opacity = 1, 
                color = "white", 
                dashArray = "2", 
                fillOpacity = 0.7,
                smoothFactor = 0.2,
                popup = ~popup.home,
                highlightOptions = highlightOptions(
                    weight = 5, 
                    color = "grey",
                    dashArray = "", 
                    fillOpacity = 0.7,
                    bringToFront = TRUE)) %>%
    addLegend(pal = pal, # legend to describe colored shapes. 
              values = ~Homeless.Rate, 
              opacity = 0.7,
              title = "Homeless Rate", 
              position = "bottomleft")


total.homeless.map


# Gender  ------------------------------------------------------------------------------------------------------
summary(united.states.merged.home$Male.Rate)
bins <- c(0, 5, 10, 15, 25, 50, 100, 150)
pal <- colorBin("YlOrRd", domain = united.states.merged.home$Male.Rate, bins = bins, pretty = FALSE)


popup.male <- paste0(united.states.merged.home$NAME, 
                     "<br> Homeless, Male: ", 
                     as.character(round(united.states.merged.home$Male.Rate, digits = 0)),
                     " in 10,000")

male.homeless.map <- us.m %>%
    addPolygons(fillColor = ~pal(Male.Rate), 
                weight = 2, 
                opacity = 1, 
                color = "white", 
                dashArray = "2", 
                fillOpacity = 0.7,
                smoothFactor = 0.2,
                popup = ~popup.male,
                highlightOptions = highlightOptions(
                    weight = 5, 
                    color = "grey",
                    dashArray = "", 
                    fillOpacity = 0.7,
                    bringToFront = TRUE)) %>%
    addLegend(pal = pal,
              values = ~Male.Rate, 
              opacity = 0.7,
              title = "Rate", 
              position = "bottomleft")
male.homeless.map



# Female 
pal <- colorBin("YlOrRd", domain = united.states.merged.home$Female.Rate, bins = bins, pretty = FALSE)

popup.female <- paste0(united.states.merged.home$NAME, "<br> Homeless, Female: ", 
                       as.character(round(united.states.merged.home$Female.Rate, digits = 0)),
                       " in 10,000")

female.homeless.map <-  us.m %>%
    addPolygons(fillColor = ~pal(Female.Rate), 
                weight = 2, 
                opacity = 1, 
                color = "white", 
                dashArray = "2", 
                fillOpacity = 0.7,
                smoothFactor = 0.2,
                popup = ~popup.female,
                highlightOptions = highlightOptions(
                    weight = 5, 
                    color = "grey",
                    dashArray = "", 
                    fillOpacity = 0.7,
                    bringToFront = TRUE)) %>%
    addLegend(pal = pal,
              values = ~Female.Rate, 
              opacity = 0.7,
              title = "Rate", 
              position = "bottomleft")
female.homeless.map



# Ethnicity Map ---------------------------------------------------------------------------------------------------
summary(united.states.merged.home$White.Rate)

pal <- colorBin("BuPu", domain = united.states.merged.home$White.Rate, bins = bins, pretty = FALSE)

popup.white <- paste0(united.states.merged.home$NAME, "<br> Homeless, White: ", 
                      as.character(round(united.states.merged.home$White.Rate, digits = 0)),
                      " in 10,000")


white.homeless.map <- us.m %>%
    addPolygons(fillColor = ~pal(White.Rate), 
                weight = 2, 
                opacity = 1, 
                color = "white", 
                dashArray = "2", 
                fillOpacity = 0.7,
                smoothFactor = 0.2,
                popup = ~popup.white,
                highlightOptions = highlightOptions(
                    weight = 5, 
                    color = "grey",
                    dashArray = "", 
                    fillOpacity = 0.7,
                    bringToFront = TRUE)) %>%
    addLegend(pal = pal,
              values = ~White.Rate, 
              opacity = 0.7,
              title = "Rate", 
              position = "bottomleft")

white.homeless.map


# Black 
pal <- colorBin("BuPu", domain = united.states.merged.home$Black.Rate, bins = bins, pretty = FALSE)
popup.black <- paste0(united.states.merged.home$NAME, "<br> Homeless, Black: ", 
                      as.character(round(united.states.merged.home$Black.Rate, digits = 0)),
                      " in 10,000")

black.homeless.map <- us.m %>%
    addPolygons(fillColor = ~pal(Black.Rate), 
                weight = 2, 
                opacity = 1, 
                color = "white", 
                dashArray = "2", 
                fillOpacity = 0.7,
                smoothFactor = 0.2,
                popup = ~popup.black,
                highlightOptions = highlightOptions(
                    weight = 5, 
                    color = "grey",
                    dashArray = "", 
                    fillOpacity = 0.7,
                    bringToFront = TRUE)) %>%
    addLegend(pal = pal,
              values = ~Black.Rate, 
              opacity = 0.7,
              title = "Rate", 
              position = "bottomleft")
black.homeless.map


# Indian 
summary(united.states.merged.home$Indian.Rate)

bins <- c(0, 3, 5, 7, 12, 15)
pal <- colorBin("BuPu", domain = united.states.merged.home$Indian.Rate, bins = bins, pretty = FALSE)
popup.indian <- paste0(united.states.merged.home$NAME, "<br> Homeless, Indian: ", 
                       as.character(round(united.states.merged.home$Indian.Rate, digits = 0)),
                       " in 10,000")

indian.homeless.map <- us.m %>%
    addPolygons(fillColor = ~pal(Indian.Rate), 
                weight = 2, 
                opacity = 1, 
                color = "white", 
                dashArray = "2", 
                fillOpacity = 0.7,
                smoothFactor = 0.2,
                popup = ~popup.indian,
                highlightOptions = highlightOptions(
                    weight = 5, 
                    color = "grey",
                    dashArray = "", 
                    fillOpacity = 0.7,
                    bringToFront = TRUE)) %>%
    addLegend(pal = pal,
              values = ~Indian.Rate, 
              opacity = 0.7,
              title = "Rate", 
              position = "bottomleft")
indian.homeless.map


# Latino 
summary(united.states.merged.home$Lat.Rate)

pal <- colorBin("BuPu", domain = united.states.merged.home$Lat.Rate, bins = bins, pretty = FALSE)
popup.lat <- paste0(united.states.merged.home$NAME, "<br> Homeless, Latinx: ", 
                    as.character(round(united.states.merged.home$Lat.Rate, digits = 0)),
                    " in 10,000")

lat.homeless.map <- us.m %>%
    addPolygons(fillColor = ~pal(Lat.Rate), 
                weight = 2, 
                opacity = 1, 
                color = "white", 
                dashArray = "2", 
                fillOpacity = 0.7,
                smoothFactor = 0.2,
                popup = ~popup.lat,
                highlightOptions = highlightOptions(
                    weight = 5, 
                    color = "grey",
                    dashArray = "", 
                    fillOpacity = 0.7,
                    bringToFront = TRUE)) %>%
    addLegend(pal = pal,
              values = ~Lat.Rate, 
              opacity = 0.7,
              title = "Rate", 
              position = "bottomleft")
lat.homeless.map


# Native 
summary(united.states.merged.home$Native.Rate)
bins <- c(0, 5, 10, 30, 50, 200)

pal <- colorBin("BuPu", domain = united.states.merged.home$Native.Rate, bins = bins, pretty = FALSE)
popup.native <- paste0(united.states.merged.home$NAME, "<br> Homeless, Native: ", 
                       as.character(round(united.states.merged.home$Native.Rate, digits = 0)),
                       " in 10,000")

native.homeless.map <- us.m %>%
    addPolygons(fillColor = ~pal(Native.Rate), 
                weight = 2, 
                opacity = 1, 
                color = "white", 
                dashArray = "2", 
                fillOpacity = 0.7,
                smoothFactor = 0.2,
                popup = ~popup.native,
                highlightOptions = highlightOptions(
                    weight = 5, 
                    color = "grey",
                    dashArray = "", 
                    fillOpacity = 0.7,
                    bringToFront = TRUE)) %>%
    addLegend(pal = pal,
              values = ~Native.Rate, 
              opacity = 0.7,
              title = "Rate", 
              position = "bottomleft")
native.homeless.map




