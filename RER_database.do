*--------------------------------------------------------------------
*--------------------------------------------------------------------
* Dutch Disease Project
* Eugenio Rojas and David Zarruk, Philadelphia, March 2015
*
* This dofile creates a database with the terms of trade for all the countries
*
*--------------------------------------------------------------------
*--------------------------------------------------------------------

*------------------------------
* Preamble
*------------------------------

clear
clear matrix
set more off 

*------------------------------
* Do Data
*------------------------------

*cd "C:\Users\Eugenio Rojas\Desktop\dutch"
cd "C:\Users\david\Dropbox\Documents\Doctorado\Second year\Semester II (2015 I)\712 - Mendoza (International macro with incomplete markets and fin frict)\Proposals Mendoza\Data_ToT\dutch"

freduse RBAUBIS 
split date, p(-)
gen year=real(date1)
collapse (mean) RBAUBIS , by( year)
gen countryname = "Australia"
tostring(year), gen(year2)
drop year
rename year2 year
rename RBAUBIS RER
sort year
save RER_Aus.dta, replace

clear

freduse RBCABIS 
split date, p(-)
gen year=real(date1)
collapse (mean) RBCABIS , by( year)
gen countryname = "Canada"
tostring(year), gen(year2)
drop year
rename year2 year
rename RBCABIS RER
sort year
save RER_Can.dta, replace

clear

freduse RBCLBIS 
split date, p(-)
gen year=real(date1)
collapse (mean) RBCLBIS , by( year)
gen countryname = "Chile"
tostring(year), gen(year2)
drop year
rename year2 year
rename RBCLBIS RER
sort year
save RER_Chi.dta, replace

clear

freduse RBRUBIS 
split date, p(-)
gen year=real(date1)
collapse (mean) RBRUBIS , by( year)
gen countryname = "Russian Federation"
tostring(year), gen(year2)
drop year
rename year2 year
rename RBRUBIS RER
sort year
save RER_Rus.dta, replace

clear

freduse RBVEBIS
split date, p(-)
gen year=real(date1)
collapse (mean) RBVEBIS, by( year)
gen countryname = "Venezuela, RB"
tostring(year), gen(year2)
drop year
rename year2 year
rename RBVEBIS RER
sort year
save RER_Ven.dta, replace

clear

use RER_Aus.dta, clear
append using RER_Can.dta
append using RER_Chi.dta
append using RER_Rus.dta
append using RER_Ven.dta

sort countryname 

gen year2 = real(year)
drop year
rename year2 year

sort countryname 
save "Databases\RER.dta", replace

erase RER_Aus.dta
erase RER_Can.dta
erase RER_Chi.dta
erase RER_Rus.dta
erase RER_Ven.dta
