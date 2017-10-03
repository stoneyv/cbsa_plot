## cbsa_plot
### Recreation of the Times ecommerce employment visualizations

### Clone the git repository
```
git clone https://github.com/stoneyv/cbsa_plot.git
```

### Fetch the data  
1. Download the following Census Bureau .txt file into ./data/census/CBP/  
https://www.census.gov/programs-surveys/cbp/data/datasets.html  
cbp15co.txt  
  
2. Download the following Census Bureau population file for CBSA into ./data/census/  
https://www2.census.gov/programs-surveys/popest/datasets/2010-2016/  
https://www2.census.gov/programs-surveys/popest/datasets/2010-2016/metro/totals/  
cbsa-est2016.csv
  
3. Download the following cartographic boundary shapefiles from the Census Bureau into ./data/shapefiles  
https://www.census.gov/geo/maps-data/data/tiger-cart-boundary.html  
a. cb_2015_us_county_20m  
b. cb_2015_us_state_20m  
c. cb_2015_us_cbsa_20m  

<img src="images/ecommerce_2015_by_county_840x533.png"/>

### R implementation
You need R and rstudio.  
The following CRAN packages are necessary
```
sp, stringr, data.table, dplyr, ggplot2, rgeos, rgdal, RColorBrewer
```
If you have difficulty installing a package look at the depends and imports fields of CRAN package page.

```
update.packages("sp")
```
```
update.packages(c("sp","stringr","data.table","dplyr","ggplot2","rgeos","rgdal","RColorBrewer"))
```

### Jupyter ipython implementation
Install the Anaconda python 3.6 distribution  
Create a conda environment for geopandas  
Create a jupyter kernelspec for the geopandas environment  
Install any missing packages  
