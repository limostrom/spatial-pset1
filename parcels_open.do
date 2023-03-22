
*cap cd second_year/spatial/Pset1

pause on

cd Pset1
* # of rows: 43,223,782
local i=2000001
forval j = 2010000(10000)10000000 {
	import delimited "Assessor_-_Parcel_Universe.csv", ///
		clear rowr(`i':`j') varn(1)
	keep tax_year class longitude latitude centroid_x centroid_y census_tract_geoid
	keep if tax_year == 2019
	save "parcels_`i'_`j'.dta", replace
	local i = `j' + 1
}



cd ../

local first = 1
local filelist: dir "Pset1" files "parcels_*.dta"
foreach file of local filelist {
	use "Pset1/`file'", clear
	
	if `first' == 1 {
		tempfile parcels
		save `parcels', replace
	}
	if `first' == 0 {
		append using `parcels'
		save `parcels', replace
	}
	local first = 0
	rm "Pset1/`file'"
}
save parcels_2000001_10000000, replace

