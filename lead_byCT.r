library(plyr)
library(RColorBrewer)
library(gridExtra)

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


# Merge Census Tracts with Community Areas
chi <- sf::st_as_sf(chi)
hoods <- sf::st_as_sf(hoods)
merged_overlaps <- st_join(chi, hoods, st_overlaps)
merged_covered <- st_join(chi, hoods, st_covered_by)

merged_o_notNA <- merged_overlaps %>% filter(!is.na(community))
merged_c_notNA <- merged_covered %>% filter(!is.na(community))
merged <- rbind(merged_o_notNA, merged_c_notNA)

PB_byCT <- ddply(merged, .(geoid10), summarise, LDPP_2021=mean(LDPP_2021))
chi <- merge(chi, PB_byCT, by.x='geoid10', by.y='geoid10')
chi <- vect(chi)

my.palette <- brewer.pal(n = 8, name = "Blues")
plotPB_byCT <- spplot(chi, "LDPP_2021", col.regions=my.palette, cuts=7)
png(file="Figures/PB_by_tract.png", height=600, width=350)
plotPB_byCT
dev.off()

write.table(chi[,c("geoid10","LDPP_2021")], file="lead_poisoning_by_tract.csv", sep=",", row.names=FALSE)

chi$LDPP_top5pct <- ifelse(chi$LDPP_2021 >= quantile(chi$LDPP_2021,probs=0.95),1,0)
chi$treatment <- chi$LDPP_2021 * chi$LDPP_top5pct

plotPB_treatment <- spplot(chi, "treatment", col.regions=my.palette, cuts=7)
png(file="Figures/PB_treatment_by_tract.png", height=600, width=350)
plotPB_treatment
dev.off()

png(file="Figures/PB_combined.png", height=600, width=800)
grid.arrange(plotPB_byCT, plotPB_treatment, ncol=2)
dev.off()