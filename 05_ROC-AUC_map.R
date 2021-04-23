
#----------------------------------------------------------------------------------------
# AUC ROC PER SEASON

# Author: Roberto O. Chavez
# Modifications: José A. Lastra.
# date: 2021.04.16
# Description: AUC-ROC as a performance measure for the binomial model for snow prob per SEASON
# Output is 1 band
#----------------------------------------------------------------------------------------
#libraries
library(ROCR)
library(raster)
library(lubridate)
library(rts)
library(rgdal)
library(parallel)
library(tidyverse)

rm(list=ls()) #will remove ALL objects

#-------------------------------------------------------------------------------------------------
# Inputs outputs

snow.path <- "bin_NDSI" #path to binary rasters
snowfl <- list.files(path=snow.path, pattern=glob2rx("mask*.tif"), full.names=T) #file list
snow.st <-stack(snowfl) #stack data

dates.table <- read_csv("landsat_Cleancollection_1984-2019.csv") #read dates table

dates_full <- dates.table$fechas #dates vector 

# Subset data for your analysis. Skip if you want to use all dataset

ini <- as.Date('1984-01-01') #start date for analysis
fin <- as.Date('1990-12-31') #end date for analysis

s1 <- which(dates_full >= ini) %>% head(1) #creates start subset
s2 <- which(dates_full <= fin) %>% tail(1) #creates end subset

dates <- dates_full[s1:s2] # subset dates
st.p1 <- snow.st[[s1:s2]] # subset raster

#----------------------------------------------------------------------------------------
# Run the function
#load
source('02_SnowAucRocMap.R')

#outname and setup
oname <- "rasterStackAucROC.tif"
ddd <- dates

SnowAucRocMap(s = st.p1 , dates = ddd, nCluster = 3, outname = oname,
              format = "GTiff", datatype = "INT4S")


