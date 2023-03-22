

cd "/Users/laurenmostrom/Library/CloudStorage/Dropbox/Personal Document Backup/Booth/Second Year/Spatial Economics/Pset1"

import delimited "parcels_2019.csv", clear delim(" ")
duplicates drop

ren (v1-v7) (year class longitude latitude centroid_x centroid_y geoid10)

export delimited "parcels_nodups.csv", replace delim(",")
