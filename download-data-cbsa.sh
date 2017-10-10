#!/bin/bash

# Run this from the top directory FARS-traffic

# Check for wget and unzip
command -v wget >/dev/null 2>&1 || { echo "wget not installed.  Aborting." >&2; exit 1; }
command -v unzip >/dev/null 2>&1 || { echo "unzip not installed.  Aborting." >&2; exit 1; }

base_url_census_survey="https://www2.census.gov/programs-surveys"
base_url_census_tiger="http://www2.census.gov/geo/tiger"

# Download Census 2015 US boundary shapefiles
# State, County, CBSA (core based statistical area)
declare -a tiger_urls=("GENZ2015/shp/cb_2015_us_state_20m.zip"
                       "GENZ2015/shp/cb_2015_us_county_20m.zip"
                       "GENZ2015/shp/cb_2015_us_cbsa_20m.zip")

if [ ! -e ./data/shapefiles ]; then
  mkdir -p ./data/shapefiles
fi

for shapefile in "${tiger_urls[@]}"; do
  wget -P ./data/shapefiles/ ${base_url_census_tiger}/$shapefile
done

pushd ./data/shapefiles
## TODO 
ls -1 *.zip
popd

# Download Census Bureau survey data  fo
# CBP (County Business Patterns) 2015 by county
# CPS (Current Population Survey) 2010 through 2016 for CBSA areas
declare -a survey_urls=("cbp/datasets/2015/cbp15co.zip"
    "popest/datasets/2010-2016/metro/totals/cbsa-est2016-alldata.csv")

if [ ! -e ./data/census ]; then
  mkdir ./data/census
fi

for survey in "${survey_urls[@]}"; do
  wget -P ./data/census/ ${base_url_census_survey}/$survey
done

unzip -d ./data/census ./data/census/cbp15co.zip
rm ./data/census/cbp15co.zip
