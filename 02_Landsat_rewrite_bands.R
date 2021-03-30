## Frontiers Paper 
##Checking imagery for glaciar mapping  Mocho Choshuenco
##Author: Jose A. Lastra
##creation: 2020.08.11
##update: 2021.03.01

#####################################################################
## working directory
setwd("raster stack path")
#####################################################################
## libraries
library(tidyverse)
library(lubridate)
library(scales)
library(raster)
library(rasterVis)
#####################################################################
#stack data
ndsi <- stack('Landsat_SnowBrick.tif')
#table data
tabla_col <- read_csv('list_cleanCollection_names.csv')

##looping for writing individual bands
#name creation
fechas <- substr(tabla_col$value,18,25) %>% ymd()#extracting and converting dates
sensor_id <- substr(tabla_col$value,1,4) #sensor id
image_id <- substr(tabla_col$value,11,41) #image id 

nombres <- paste('folder/','ndsi_',fechas,'_',image_id,'_',sensor_id,sep = '')

for (i in 1:nlayers(ndsi)) {
  r <- ndsi[[i]]
  n <- nombres[i]
  r[r > 1] <- NA
  r[r < -1] <- NA
  writeRaster(r, filename = n,format= 'GTiff')
  print(paste('image', i, 'ready!'))
}









