################################################################################
# Map - Figure 2
################################################################################

################################################################################
library(tidyverse) 
library(rgdal)
library(tmap)
library(leaflet)
library(sf)
################################################################################

################################################################################
# Load in the data
data(World)
dat <- readRDS(file = "pisa18_subset.rds") 

# Make dataframe I want to get
df <- data.frame(country = World$name, afkorting = World$iso_a3, afname = "Not participated")

# Retrieve the countries 
countries <- unique(dat$CNT)
# Assign the participating countries computer-administered
df$afname[df$afkorting %in% countries] <- "CBA"

# Correct some mistakes
df$afname[df$country == "Azerbaijan"] <- "CBA"
df$afname[df$country == "China"] <- "CBA"
df$afname[df$country == "Kosovo"] <- "CBA"

# Assign the countries that were paper-administered
df$afname[df$country == "Argentina"] <- "PBA"
df$afname[df$country == "Jordan"] <- "PBA"
df$afname[df$country == "Lebanon"] <- "PBA"
df$afname[df$country == "Moldova"] <- "PBA"
df$afname[df$country == "Macedonia"] <- "PBA"
df$afname[df$country == "Romania"] <- "PBA"
df$afname[df$country == "Saudi Arabia"] <- "PBA"
df$afname[df$country == "Ukraine"] <- "PBA"
df$afname[df$country == "Vietnam"] <- "PBA"

# Return to the World data as that is already an sf object
World$afname <- as.factor(df$afname)
World$afname <- ordered(World$afname, levels = c("CBA", "PBA", "Not participated"))
 
# Make my own color palette
mypalette <- c("#EE9FA9", "#9AC8D5", "#F9CA7F")

# Make the figure
mode_map <- tm_shape(World) +
  tm_fill("afname", id = "name", title = "Mode", palette = mypalette) +
  tm_borders("grey20") + 
  tm_layout(legend.bg.color = "white",
            legend.title.size = 1.5,
            legend.text.size = 1)

# Save the figure
tmap_save(tm = mode_map, file = "mode_map.png")
################################################################################
