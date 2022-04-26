# Table of Contents 

- Background 
- Objective 
- Tools and Packages 
- Data Collection & Processing
- Data Visualization 
- Results 
- Future Work 
- References 

## Background 
My friends and I were spending some time stressing about inflation rates and the rising prices of rent in our city (and our shared fear of homelessness as a result). We tried to look up rates of homelessness but were met with dull tables and graphs. I decided to try changing this. 


## Objective 
Create an appealing, informative visual detailing rates of homelessness in the United States. 

## Tools and Packages 
For this project, I used R in combination with the following packages: 
- shiny: Building interactive web apps 
- shinydashboard: Dashboard layouts for shiny apps
- openxlsx: Reading & writing Excel workbooks
- leaflet: JavaScript library for interactive maps 
- tigris: Downloading shapefiles 
- rgdal: Working with geospatial data
- tidyverse: Data manipulation & visualization
- viridis: Appealing color palettes 
- pacman: Package manager

I've included a cleanup.py file for....versatility purposes. 

## Data Collection & Processing 
I got the raw homelessness data from the [HUD Exchange](https://www.hudexchange.info/), and it contains information on different homeless populations of the different states in the U.S. After doing a little bit of research, I decided to show homelessness as a rate per 10,000 persons (scaled up to match populations in the hundred thousands, millions). 

There was a little confusion when trying to find a shapefile (digital vector format for storing geographical information), but luckily the tigris package allowed me to download a shapefile directly into R! 

The next step was to link the "polygons" which represent states to the relevant data. I then calculated different rates for different groups: group/total population * 10000 and fit these rates to color scale, which was then applied to the polygons. The polygons were also set to display the rate, state name, and total population when clicked on. 

These were then placed on a shiny app for hosting! 

## Results 
![image](https://user-images.githubusercontent.com/91495866/165198547-5ce70dff-1aef-4fec-9326-cd8f1ce47b0e.png)

The completed app can be viewed [here](https://sutnij.shinyapps.io/Visualizing_Homelessness/)

## Future Work 
The logical next step would be to update the app with data from other countries, and then keep this information updated as time goes on. 

