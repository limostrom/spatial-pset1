library(tidyverse)
library(dplyr)
library(terra)
library(RColorBrewer)
library(sp)
library(lattice)
library(gridExtra)

here::here()

# Load in Chicago census tract boundaries
chi <- st_read('Boundaries - Census Tracts - 2010/geo_export_20724df8-474d-489d-a807-f9ffe04b1922.shp')
centers <- st_centroid(chi)


# Census tract distances
dist_matrix <- st_distance(centers, centers)
dist_matrix <- as.data.frame(dist_matrix)
colnames(dist_matrix) <- chi$geoid10
dist_matrix$i <- chi$geoid10
dist <- gather(dist_matrix, j , distance, '17031010100':'17031980100', factor_key=TRUE)
write.table(dist, file="d_ij.csv", sep=',', row.names=FALSE)
