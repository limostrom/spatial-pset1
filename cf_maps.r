
library(gridExtra)

#Chi Census Tracts
setwd('/Users/laurenmostrom/Library/CloudStorage/Dropbox/Personal Document Backup/Booth/Second Year/Spatial Economics/Pset1')
chi <- vect('Boundaries - Census Tracts - 2010/geo_export_20724df8-474d-489d-a807-f9ffe04b1922.shp')


setwd('/Users/laurenmostrom/Dropbox/chicago_model (1)/output/')

# Productivities
A <- read.csv('A_j.csv', header=FALSE)
colnames(A) <- c('geoid10', 'Aj')
A$Aj <- as.numeric(A$Aj)
chi <- merge(chi, A, by.x='geoid10', by.y='geoid10')

my.palette <- brewer.pal(n = 8, name = "Blues")
plotA <- spplot(chi, "Aj", col.regions=my.palette, cuts=7)
png(file="maps/Aj_map.png", height=400, width=350)
plotA
dev.off()

# Exogenous Starting Amenities
B <- read.csv('B_j.csv')
chi <- merge(chi, B, by.x='geoid10', by.y='tract')
my.palette <- brewer.pal(n = 8, name = "Blues")
plotBw <- spplot(chi, "Bw_j", col.regions=my.palette, cuts=7)
plotBb <- spplot(chi, "Bb_j", col.regions=my.palette, cuts=7)

png(file="maps/B_j.png", height=450, width=800)
grid.arrange(plotBw, plotBb, ncol=2)
dev.off()

# Counterfactual Results - Same Amenity Change, Different Outside Options
cf <- read.csv('cf_results.csv')
chi <- merge(chi, cf, by.x='geoid10', by.y='tract')

chi$ch_wage_pct <- chi$ch_wage - 1
chi$ch_wpop <- (chi$white_pop_cf - chi$white_pop)/chi$white_pop
chi$ch_bpop <- (chi$black_pop_cf - chi$black_pop)/chi$black_pop
chi$ch_pop <- (chi$black_pop_cf + chi$white_pop_cf - chi$black_pop - chi$white_pop)/(chi$black_pop + chi$white_pop)


my.palette <- brewer.pal(n = 8, name = "Blues")
plot_dwage <- spplot(chi, "ch_wage_pct", col.regions = my.palette, cuts = 7)


png(file="maps/d_wage.png", height=400, width=350)
plot_dwage
dev.off()

my.palette <- rev(brewer.pal(n = 8, name = "Reds"))
plot_dwpop <- spplot(chi, "ch_wpop", col.regions = my.palette, cuts = 7)
plot_dbpop <- spplot(chi, "ch_bpop", col.regions = my.palette, cuts = 7)
plot_dpop <- spplot(chi, "ch_pop", col.regions = my.palette, cuts = 7)


png(file="maps/d_wpop.png", height=400, width=350)
plot_dwpop
dev.off()

png(file="maps/d_bpop.png", height=400, width=350)
plot_dbpop
dev.off()

png(file="maps/d_pop_combined.png", height=450, width = 800)
grid.arrange(plot_dwpop, plot_dbpop, ncol=2)
dev.off()

png(file="maps/d_totpop.png", height=400, width=350)
plot_dpop
dev.off()



# Counterfactual Results - Different Amenity Changes, Different Outside Options
setwd('/Users/laurenmostrom/Library/CloudStorage/Dropbox/Personal Document Backup/Booth/Second Year/Spatial Economics/Pset1')
chi <- vect('Boundaries - Census Tracts - 2010/geo_export_20724df8-474d-489d-a807-f9ffe04b1922.shp')
setwd('/Users/laurenmostrom/Dropbox/chicago_model (1)/output/')
cf <- read.csv('cf_results_only_Bw.csv')
chi <- merge(chi, cf, by.x='geoid10', by.y='tract')

chi$ch_wage_pct <- chi$ch_wage - 1
chi$ch_wpop <- (chi$white_pop_cf - chi$white_pop)/chi$white_pop
chi$ch_bpop <- (chi$black_pop_cf - chi$black_pop)/chi$black_pop
chi$ch_pop <- (chi$black_pop_cf + chi$white_pop_cf - chi$black_pop - chi$white_pop)/(chi$black_pop + chi$white_pop)


my.palette <- brewer.pal(n = 8, name = "Blues")
plot_dwage <- spplot(chi, "ch_wage_pct", col.regions = my.palette, cuts = 7)


png(file="maps/d_wage_only_Bw.png", height=400, width=350)
plot_dwage
dev.off()

my.palette <- rev(brewer.pal(n = 8, name = "Reds"))
plot_dwpop <- spplot(chi, "ch_wpop", col.regions = my.palette, cuts = 7,
                at=c(-.15, -.1, -.05, -.04, -.03, -.02, -.01, 0))
plot_dbpop <- spplot(chi, "ch_bpop", col.regions = my.palette, cuts = 7,
                at=c(-.15, -.1, -.05, -.04, -.03, -.02, -.01, 0))
plot_dpop <- spplot(chi, "ch_pop", col.regions = my.palette, cuts = 7,
                at=c(-.15, -.1, -.05, -.04, -.03, -.02, -.01, 0))


png(file="maps/d_wpop_only_Bw.png", height=400, width=350)
plot_dwpop
dev.off()

png(file="maps/d_bpop_only_Bw.png", height=400, width=350)
plot_dbpop
dev.off()


png(file="maps/d_pop_combined_only_Bw.png", height=450, width=800)
grid.arrange(plot_dwpop, plot_dbpop, ncol=2)
dev.off()

png(file="maps/d_totpop_only_Bw.png", height=400, width=350)
plot_dpop
dev.off()


# Counterfactual Results - Same Amenity Changes, All Tracts
setwd('/Users/laurenmostrom/Library/CloudStorage/Dropbox/Personal Document Backup/Booth/Second Year/Spatial Economics/Pset1')
chi <- vect('Boundaries - Census Tracts - 2010/geo_export_20724df8-474d-489d-a807-f9ffe04b1922.shp')
setwd('/Users/laurenmostrom/Dropbox/chicago_model (1)/output/')
cf <- read.csv('cf_results_all_tracts.csv')
chi <- merge(chi, cf, by.x='geoid10', by.y='tract')

chi$ch_wage_pct <- chi$ch_wage - 1
chi$ch_wpop <- (chi$white_pop_cf - chi$white_pop)/chi$white_pop
chi$ch_bpop <- (chi$black_pop_cf - chi$black_pop)/chi$black_pop
chi$ch_pop <- (chi$black_pop_cf + chi$white_pop_cf - chi$black_pop - chi$white_pop)/(chi$black_pop + chi$white_pop)


my.palette <- brewer.pal(n = 8, name = "Blues")
plot_dwage <- spplot(chi, "ch_wage_pct", col.regions = my.palette, cuts = 7)


png(file="maps/d_wage_all_tracts.png", height=400, width=350)
plot_dwage
dev.off()

my.palette <- rev(brewer.pal(n = 8, name = "Reds"))
plot_dwpop <- spplot(chi, "ch_wpop", col.regions = my.palette, cuts = 7)
plot_dbpop <- spplot(chi, "ch_bpop", col.regions = my.palette, cuts = 7)
plot_dpop <- spplot(chi, "ch_pop", col.regions = my.palette, cuts = 7)


png(file="maps/d_wpop_all_tracts.png", height=400, width=350)
plot_dwpop
dev.off()

png(file="maps/d_bpop_all_tracts.png", height=400, width=350)
plot_dbpop
dev.off()


png(file="maps/d_pop_combined_all_tracts.png", height=450, width=800)
grid.arrange(plot_dwpop, plot_dbpop, ncol=2)
dev.off()

png(file="maps/d_totpop_all_tracts.png", height=400, width=350)
plot_dpop
dev.off()
