
### Recreation of the NY Times ecommerce employment geo visualization
https://www.nytimes.com/interactive/2017/07/06/business/ecommerce-retail-jobs.html

### 1. Clone the git repository
```
git clone https://github.com/stoneyv/cbsa_plot.git
```

### 2. Download the data and shapefiles  
A. Download the following Census Bureau .txt file into ./data/census/CBP/  
https://www.census.gov/programs-surveys/cbp/data/datasets.html  
cbp15co.txt  
  
B. Download the following Census Bureau population file for CBSA into ./data/census/  
https://www2.census.gov/programs-surveys/popest/datasets/2010-2016/  
https://www2.census.gov/programs-surveys/popest/datasets/2010-2016/metro/totals/  
cbsa-est2016.csv
  
C. Download the following cartographic boundary shapefiles from the Census Bureau into ./data/shapefiles  
https://www.census.gov/geo/maps-data/data/tiger-cart-boundary.html  
1. cb_2015_us_county_20m  
2. cb_2015_us_state_20m  
3. cb_2015_us_cbsa_20m  

<img src="images/ecommerce_2015_by_county_legend_ggplot_1900x1004.png"/>

### R implementation
You need R and rstudio.  
The following CRAN packages are necessary
```
sp, stringr, data.table, dplyr, ggplot2, rgeos, rgdal, RColorBrewer
```
If you have difficulty installing a package look at the depends and imports fields of CRAN package page.
To update a single package

```
install.packages("sp")
```
To update multiple packages at once
```
install.packages(c("sp","stringr","data.table","dplyr","ggplot2","rgeos","rgdal","RColorBrewer"))
```

### Jupyter ipython implementation
Install the Anaconda python 3.6 distribution  
Create a conda environment for geopandas  
Create a jupyter kernelspec for the geopandas environment  
Install any missing packages
Run the jupyter ipython notebook
