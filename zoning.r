library(tidyverse)
library(sf)
library(mapview)
library(rvest)
library(httr)
library(terra)
library(janitor)
library(sp)

setwd("/Users/laurenmostrom/Dropbox/Personal Document Backup/Booth/Second Year/Spatial Economics/Pset1/")

here::here()

#Read in CSV
parcels <- read.csv("parcels_nodups.csv", header=TRUE, sep=",")
parcels <- parcels %>% filter(!is.na(centroid_x))
parcels <- st_as_sf(parcels, coords=c("centroid_x", "centroid_y"), crs=3435)
buffer <- st_buffer(parcels, 1)

zones <- vect("Zoning_Nov2012.kml")
zones <- st_as_sf(zones)
#zones <- st_transform(zones, crs = 3435)
zones <- zones %>% filter(st_is_valid(zones) == TRUE)
zones$zid <- 1:nrow(zones)

merged_c <- st_join(parcels, zones, st_covered_by)
# excluded land and railroads
merged <- merged[-which(merged$class == "EX" | merged$class == "RR"),]


merged <- merged[(which(!is.na(merged$geoid10))),]
areas <- st_area(merged[6,])