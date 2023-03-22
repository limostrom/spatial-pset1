library(tidyverse)
library(dplyr)
library(terra)
library(RColorBrewer)
library(sp)
library(lattice)
library(gridExtra)
library(plyr)

here::here()

# Load in NHGIS population data for demographics by census tract
acs19 <- read.csv('nhgis0001_csv/nhgis0001_ds245_20195_tract.csv')
pop <- acs19[which(acs19$STATE=='Illinois' & acs19$COUNTY == 'Cook County'),
            c('GISJOIN', 'GEOID', 'TRACTA', 'AL44E001', 'AL46E001', 'AL5AE001', 'AL5BE001')]
pop$bwratio <- pop$AL44E001 / (pop$AL5AE001 + pop$AL44E001)
pop$nonwratio <- 1 - (pop$AL5AE001 / (pop$AL5AE001 + pop$AL44E001 + pop$AL46E001 + pop$AL5BE001))
pop$bratio <- pop$AL44E001 / (pop$AL5AE001 + pop$AL44E001 + pop$AL46E001 + pop$AL5BE001)
pop <- pop[,c('TRACTA', 'bwratio', 'bratio','nonwratio')]
pop$TRACTA <- pop$TRACTA/100

# Load in Chicago census tract boundaries
chi <- vect('Boundaries - Census Tracts - 2010/geo_export_20724df8-474d-489d-a807-f9ffe04b1922.shp')
chi$name10 <- as.numeric(chi$name10)
chi <- merge(chi, pop, by.x='name10', by.y='TRACTA')

# Load in Elevated Blood Lead Levels
lead <- read.csv('Chicago Health Atlas Data Download - Community areas.csv')
lead <- lead[5:length(lead$Name),c('Name', 'LDPP_2021')]
lead$Name <- gsub("'", '', lead$Name)
lead$Name <- toupper(lead$Name)
lead$LDPP_2021 <- as.numeric(lead$LDPP_2021)

# Load in Chicago Community Areas
hoods <- vect('Boundaries - Community Areas (current)/geo_export_d89fce91-bff9-467b-bcf2-2fffc8746067.shp')
hoods <- merge(hoods, lead, by.x='community', by.y='Name')
hoods$LDPP_2021 <- as.numeric(hoods$LDPP_2021)

# Load in As
A <- read.csv('A_j.csv', header=FALSE)
colnames(A) <- c('geoid10', 'Aj')
A$Aj <- as.numeric(A$Aj)
chi <- merge(chi, A, by.x='geoid10', by.y='geoid10')

# Map of Black-White Ratio by Census Tract
my.palette <- brewer.pal(n = 8, name = "Blues")

plotBW <- spplot(chi, "bwratio", title="Black-White Ratio", col.regions = my.palette, cuts = 7)
plotNW <- spplot(chi, "nonwratio", col.regions = my.palette, cuts = 7)
plotPB <- spplot(hoods, "LDPP_2021", col.regions=my.palette, cuts=7, title="Percent of Children with Elevated Blood Lead Levels")
plotA <- spplot(chi, "Aj", col.regions=my.palette, cuts=7)

png(file="Figures/bw_ratio.png", height=600, width=350)
plotBW
dev.off()

# Map of Lead Poisoning by Community Area
png(file="Figures/lead_by_comm_area.png", height=600, width=350)
plotPB
dev.off()

# Map of Lead Poisoning and Black-White Ratio next to each other
png(file="Figures/bw_lead_combined.png", height=600, width=800)
grid.arrange(plotBW, plotPB, ncol=2)
dev.off()

# Map of the Ajs
png(file="Figures/Aj_map.png", height=600, width=350)
plotA
dev.off()
