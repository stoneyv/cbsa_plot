#!/bin/bash

# Metropolitan and Micropolitan Statistical Area Population Totals Tables
# 2010 to 2016
# https://www.census.gov/data/tables/2016/demo/popest/
#         total-metro-and-micro-statistical-areas.html

# Core Base Statistical Area shapefile (Metro plus Micro areas)
# https://www.census.gov/geo/maps-data/data/tiger-cart-boundary.html

# Example CBSA maps to confirm that you understand the area definitions
# https://www.census.gov/geo/maps-data/maps/statecbsa.html

# developed w/ mapshaper version 0.4.34
mapshaper --version

# Get column names from the header row
mapshaper ../data/PEP_2016_GCTPEPANNR.US24PR_with_ann_singleHeader.csv -info

# Get column names
mapshaper ../data/shapefiles/cb_2016_us_cbsa_20m/cb_2016_us_cbsa_20m.shp -info

# Load and clip cbsa to continental US
mapshaper ../data/shapefiles/cb_2016_us_cbsa_20m/cb_2016_us_cbsa_20m.shp \ 
          -clip bbox=-125.51,23.73,50.35,65.48

# Join cbsa census population estimates for MSA with
# cbsa shapefile GEOID. Then select a subset of the data fields 
mapshaper ../data/PEP_2016_GCTPEPANNR.US23PR_with_ann.csv -join \
          keys=GEOID,GC.target-geo-i-2 \
          -filter-fields GEOID,NAME,GC.target-geo-id,GC.display-label,respop72015 

# Large Metropolitan Statistical Areas
mapshaper ../data/PEP_2016_GCTPEPANNR.US23PR_with_ann.csv -filter 'respop72015 > 999999' -omsa_large_2016.shp 

# Medium sized Metropolitan Statistical Areas, pop 250k to 1M
mapshaper ../data/PEP_2016_GCTPEPANNR.US23PR_with_ann.csv -filter 'respop72015 > 249999 ANDrespop72015 < 1000000' -o msa_medium_2016.shp
