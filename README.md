
### Recreation of the NY Times ecommerce employment geo visualization
https://www.nytimes.com/interactive/2017/07/06/business/ecommerce-retail-jobs.html

Currently there are R ggplot2 and Python matplotlib implementations.  I hope to finish a d3.js v4 implementation soon.

### 1. Clone the git repository
```
git clone https://github.com/stoneyv/cbsa_plot.git
```

### 2. Download the data and shapefiles
If you are running linux or Mac OSX you can open a terminal and run this bash shell script to download the data and unzip it into the required directories.  Windows users might use the newer Ubuntu linux subsytem on Windows 10 or cygwin.
```bash
./download-data-cbsa.sh
```
Otherwise you can do this manually following these directions

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
https://www.rstudio.com/products/rstudio/download/

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
https://www.anaconda.com/download

Create a conda environment for geopandas  
https://conda.io/docs/user-guide/tasks/manage-environments.html
```bash
# On the windows platform, omit the word "source"
conda create -n geopandas python=3.6 geopandas
source activate geopandas
```
Note that the following commands assume that you have activated the geopandas environment that you created above.  You should see "geopandas" at your command prompt once you activate the environment.  To deactivate the environment you can issue the source deactivate command.

Create a jupyter kernelspec for the geopandas environment  
http://ipython.readthedocs.io/en/stable/install/kernel_install.html#kernels-for-different-environments
```bash
python -m ipykernel install --user --name geopandas --display-name "Python (geopandas)"
```
Install any missing packages  
https://conda.io/docs/user-guide/tasks/manage-pkgs.html#installing-packages
```bash
conda install <package_name>
```
Run the jupyter ipython notebook
```bash
jupyter notebook
```
When you want to change to the regular Anaconda environment you can issue 
```bash
# On the Windows platform omit the word "source"
source deactivate geopandas
```
