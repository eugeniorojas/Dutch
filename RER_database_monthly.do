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
gen year=yofd(daten)
gen month = mofd(daten)
gen quarter = qofd(daten)
format month %tm
format quarter %tq
gen countryname = "Australia"
drop date 
rename RBAUBIS RER
sort year
save RER_Aus.dta, replace

clear

freduse RBCABIS 
gen year=yofd(daten)
gen month = mofd(daten)
gen quarter = qofd(daten)
format month %tm
format quarter %tq
gen countryname = "Canada"
drop date 
rename RBCABIS RER
sort year
save RER_Can.dta, replace

clear

freduse RBCLBIS 
gen year=yofd(daten)
gen month = mofd(daten)
gen quarter = qofd(daten)
format month %tm
format quarter %tq
gen countryname = "Chile"
drop date 
rename RBCLBIS RER
sort year
save RER_Chi.dta, replace

clear

freduse RBRUBIS 
gen year=yofd(daten)
gen month = mofd(daten)
gen quarter = qofd(daten)
format month %tm
format quarter %tq
gen countryname = "Russian Federation"
drop date 
rename RBRUBIS RER
sort year
save RER_Rus.dta, replace

clear

freduse RBVEBIS
gen year=yofd(daten)
gen month = mofd(daten)
gen quarter = qofd(daten)
format month %tm
format quarter %tq
gen countryname = "Venezuela, RB"
drop date 
rename RBVEBIS RER
sort year
save RER_Ven.dta, replace

clear

use RER_Aus.dta, clear
append using RER_Can.dta
append using RER_Chi.dta
append using RER_Rus.dta
append using RER_Ven.dta

sort countryname month

sort countryname 
order countryname daten RER
save "Databases\RER_monthly.dta", replace

erase RER_Aus.dta
erase RER_Can.dta
erase RER_Chi.dta
erase RER_Rus.dta
erase RER_Ven.dta
