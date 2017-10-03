library(stringr)
library(data.table)
#library(tidyverse)
# tidyverse includes dpylr, ggplot2
library(dplyr)
library(ggplot2)

library(rgeos)
library(rgdal)
library(RColorBrewer)

# Setting the working directory and then confirming it.
working_dir <- "/home/stoney/Desktop/cbsa_plot/R/"
setwd(working_dir)
getwd()

cbp_co_2015_df <- fread('../data/census/CBP/cbp15co.txt',
                          select=c("FIPSTATE","FIPSCTY","NAICS",
                                   "EMPFLAG", "EMP_NF","EMP"))

cbp_co_2015_ecom_df <- cbp_co_2015_df %>%
                         filter(NAICS == "454111" & EMP > 39) %>%
                         mutate(id = paste(FIPSTATE,FIPSCTY, sep=''))

# Population estimates for each core base statistical area
pop_est_2010to16_file <- '../data/census/cbsa-est2016-alldata.csv'
pop_est_2015_df <- fread(pop_est_2010to16_file,
                         select=c("CBSA",
                                  "STCOU",
                                  "POPESTIMATE2015",
                                  "RESIDUAL2015"),
                         colClasses=c(CBSA="character",
                                      STCOU="character",
                                      POPESTIMATE2015="numeric",
				      RESIDUAL2015="numeric"),
                         stringsAsFactors = FALSE)

cities_df <- fread('../data/cities.csv')

## Load a spatial dataframe of US counties from a US census 500k shapefile
## Convert it to a regular dataframe and use the GEOID
## Do this outside of the loop one time.
county_map_sdf <- readOGR(dsn = "../data/shapefiles/cb_2015_us_county_20m",
                          layer = "cb_2015_us_county_20m")

state_map_sdf <- readOGR(dsn = "../data/shapefiles/cb_2015_us_state_20m",
                          layer = "cb_2015_us_state_20m")
cbsa_map_sdf <-readOGR(dsn = "../data/shapefiles/cb_2015_us_cbsa_20m",
                    layer = "cb_2015_us_cbsa_20m")

# Remove polygons outside of continental US
# https://www.datascienceriot.com/mapping-us-counties-in-r-with-fips/kris/
#
#  Alaska(2), Hawaii(15), Puerto Rico (72),
#  Guam (66), Virgin Islands (78), American Samoa (60)
#  Mariana Islands (69), Micronesia (64),
#  Marshall Islands (68), Palau (70), Minor Islands (74)
#
county_map_sdf <- county_map_sdf[!county_map_sdf$STATEFP %in%
                                             c("02", "15", "72", "66",
                                               "78", "60", "69", "64",
                                               "68", "70", "74"),]
county_map_sdf <- county_map_sdf[!county_map_sdf$STATEFP %in%
                                             c("81", "84", "86", "87",
                                               "89", "71", "76", "95",
                                               "79"),]

state_map_sdf <- state_map_sdf[!state_map_sdf$STATEFP %in%
                                             c("02", "15", "72", "66",
                                               "78", "60", "69", "64",
                                               "68", "70", "74"),]
state_map_sdf <- state_map_sdf[!state_map_sdf$STATEFP %in%
                                             c("81", "84", "86", "87",
                                               "89", "71", "76", "95",
                                               "79"),]


# Convert geospatial object to dataframe
state_map_df <- fortify(state_map_sdf, region="GEOID")
county_map_df <- fortify(county_map_sdf, region="GEOID")
cbsa_map_df <- fortify(cbsa_map_sdf, region="GEOID")

county_ids <- as.character(county_map_sdf@data$GEOID)
county_centroids <- gCentroid(county_map_sdf, byid=TRUE)
county_longs <- county_centroids@coords[,1]
county_lats <- county_centroids@coords[,2]

county_centroids_df <- data.frame(county_ids,
                                   county_longs,
                                   county_lats,
                                   stringsAsFactors=FALSE)

county_centroids_2015_ecom_df <- left_join(cbp_co_2015_ecom_df,
                                             county_centroids_df,
                                             by=c("id"="county_ids"))

mod40 <- function (x) {
             x %/% 40
}

# Determine num of rows needed for target dataframe
df <- county_centroids_2015_ecom_df %>%
      select(id, EMP, county_longs, county_lats) %>%
      mutate(id,
             emp=EMP,
             long=county_longs,
             lat=county_lats)

markers <- vector("integer", nrow(df))
for ( i in 1:nrow(df)) {
   markers[i] <- mod40(df[i,]$emp)
}
num_rows <- sum(markers)

# pre allocate memory for target dataframe
emp40_df <- data.frame(id = character(num_rows),
                       long = numeric(num_rows),
                       lat = numeric(num_rows),
                       emp40 = numeric(num_rows),
                       instance = numeric(num_rows),
                       stringsAsFactors = FALSE)

# For each observation/row in original dataframe df
# create target dataframe observations/rows of 40 employees
# whose sum approaches the total number of employees df[i,]$EMP
index <- 1
for ( i in 1:nrow(df)) {
        for ( j in 1:markers[i]) {
                row_index <- index - 1 + j
                emp40_df[row_index,]$id <- df[i,]$id
                emp40_df[row_index,]$long <- df[i,]$long
                emp40_df[row_index,]$lat <- df[i,]$lat
                emp40_df[row_index,]$emp40 <- 40
                emp40_df[row_index,]$instance <- j
        }
        index <- index + markers[i]
}


# Minimal theme settings for ggplot2 
# http://docs.ggplot2.org/current/theme.html
#
theme_minimal <- theme(axis.line=element_blank(),
                       axis.text.x=element_blank(),
                       axis.text.y=element_blank(),
                       axis.ticks=element_blank(),
                       axis.title.x=element_blank(),
                       axis.title.y=element_blank(),
                       panel.grid.major = element_blank(),
                       panel.grid.minor = element_blank(),
                       panel.border = element_blank(),
                       panel.background = element_blank())

# Update the ggplot2 theme to center the plot title.
# The default is left aligned with ggplot 2.2.0 and later
theme_update(plot.title = element_text(hjust = 0.5))

cbsa_map_pop_df <- left_join(cbsa_map_df,
                             pop_est_2015_df,
                             by=c("id"="CBSA"))

cbsa_map_large_df <- cbsa_map_pop_df %>%
                     filter(POPESTIMATE2015 > 999999)

cbsa_map_medium_df <- cbsa_map_pop_df %>%
                      filter(POPESTIMATE2015 > 250000 & POPESTIMATE2015 < 1000000)

cities_df <- fread('../data/cities.csv')

# State boundaries of the continental US
state_layer <- ggplot(state_map_df) +
                 geom_polygon(aes(x=long, y=lat, group=group), # State map
                              color="white",
                              size = 0.20,
                              fill="#EBEBEB") 

# MSA w/ Population >= 1M 
cbsa_large_layer <- annotation_map(cbsa_map_large_df, 
                                   fill="#9AB7D6",
                                   color = "NA",
                                   alpha = 0.9)

# MSA w/ Population 250k to 1M
cbsa_medium_layer <- annotation_map(cbsa_map_medium_df, 
                                    fill="#CFDBEB",
                                    color = "NA",
                                    size = 0.10,
                                    alpha = 0.9)

# 40 ecommerce employees fill
ecom40_point_layer <- geom_point(data=emp40_df, 
                                 aes(x=long, y=lat),
                                 position=position_jitter(width=0.6,height=0.6),
                                 shape = 21,
                                 fill = "#FCBD62",
                                 color = "white",
                                 size = 2,
                                 stroke = 0.5,
                                 alpha = 1)

 # City points for highlighted MSA
city_points_layer <- geom_point(data=cities_df,
                                aes(x=lon, y=lat),
                                shape = 21,
                                fill = "black",
                                color = "white",
                                size = 2,
                                stroke = 1)

# City names for highlighted MSA
city_text_layer <- geom_text(data=cities_df,
                             aes(x=lon, y=lat, label=name,
                                 family="Helvetica-Narrow", fontface="plain"),
                             nudge_x = cities_df$nx,
                             nudge_y = cities_df$ny,
                             size = 3)

# Plot the layers, reduce clutter w/ theme, and use an Albers equal area
# projection
state_layer + cbsa_large_layer + cbsa_medium_layer + ecom40_point_layer +
              city_points_layer + city_text_layer +
              theme_minimal +
              coord_map("albers", lat0=30, lat1=40) 


