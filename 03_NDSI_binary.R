## Landsat binary mask 
##Author: Jose A. Lastra
##creation: 2020.08.17
##update: 2021.03.01

#####################################################################
## working directory
setwd("working path")
#####################################################################
## libraries
library(tidyverse)
library(lubridate)
library(raster)
library(rgdal)
library(sf)
####################################################################
#read data
inpath <- 'folder with NDSI images/' #path to raw NDSI images
ndsi <- list.files(path = inpath,pattern = glob2rx('ndsi*.tif'),full.names = T)#listing files

 # shapefile data
shp <- read_sf('folder with extent shapefile') %>% 
  st_transform('+proj=utm +zone=18 +datum=WGS84 +units=m +no_defs') #transform CRS to adjust image default CRS

####################################################################
## ouput names
ndsiNames <- list.files(path = inpath,pattern = glob2rx('ndsi*.tif'),full.names = F)#extract filenames
outnames <- paste('FOLDER/mask_',ndsiNames,sep = '')

####################################################################
## writing binary files
for (i in 1:length(outnames)) {
  
  r <- ndsi[i] %>% raster() 
  r[r >= 0.5] <-  1 #snow
  r[r < 0.5] <- 0 #not snow

  writeRaster(r, filename = outnames[i],format='GTiff',overwrite=T)
  print(paste('image', i, 'ready!'))
}

