*--------------------------------------------------------------------
*--------------------------------------------------------------------
* Dutch Disease Project
* Eugenio Rojas and David Zarruk, Philadelphia, March 2015
*--------------------------------------------------------------------
*--------------------------------------------------------------------

*------------------------------
* Preamble
*------------------------------

clear
clear matrix
set more off 

*------------------------------
* Do Data: merge the databases
*------------------------------

*cd "C:\Users\Eugenio Rojas\Desktop\dutch"
cd "C:\Users\david\Dropbox\Documents\Doctorado\Second year\Semester II (2015 I)\712 - Mendoza (International macro with incomplete markets and fin frict)\Proposals Mendoza\Data_ToT\dutch"

use "Databases\wbdata.dta", clear

mmerge countryname year using "Databases\RER_all.dta"
*merge m:m countryname year using "RER.dta"

* RER is not complete, so there are observations of many countries only in master.
* Only in using there is only "Euro area" and "Netherlands antilles"
keep if _merge==3
drop _merge 					// The dropped observations are because years do not coincide. 

rename countryname country

encode country, generate(id)

label var tt_pri_mrch_xd_wd "ToT"
label var ne_exp_gnfs_zs "Exports"
label var ny_gdp_defl_kd_zg "Inflation"
label var nv_ind_totl_zs "Industry"
label var nv_srv_tetc_zs "Services"
label var ic_bus_nreg "Bussinesses"

replace country = "Russia" if country == "Russian Federation"
replace country = "Venezuela" if country == "Venezuela, RB"


*------------------------------
* Select the countries
*------------------------------

* Me quedo con los paises que tienen datos en mas de 20 anhos
gen num = 1 if tx_val_food_zs_un !=. & tx_val_fuel_zs_un!= . & tx_val_mmtl_zs_un!= . 
bys country: egen num2 = sum(num)

keep if num2>=15
drop num num2

*-------------------------------------------------------------------------------
* Graph 1 - % of countries with commodities > 30% of exports, by GDP per capita
*-------------------------------------------------------------------------------

* La pregunta es TAN relevante, que quiero mostrar un grafico con income per capita en eje x, y % de paises
* de ese income que dependieron en mas del 30% en algun anho de commodities...

* TODO: por robustez, deberia mirar los paises que estuvieron, digamos, por encima de 30% durante mas de 
* cinco anhos, o cosas por el estilo. Sin embargo, se ve que la mayoria de paises cumplen eso.

gen max_food = tx_val_food_zs_un
gen max_fuel = tx_val_fuel_zs_un
gen max_ores = tx_val_mmtl_zs_un

* k es el numero de anhos que queremos que este por encima del threshold
local k = 4

forvalues i=1(1)`k'{
	bys country: egen max_fo = max(max_food)
	bys country: egen max_fu = max(max_fuel)
	bys country: egen max_or = max(max_ores)
	
	replace max_food = . if max_food==max_fo
	replace max_fuel = . if max_fuel==max_fu
	replace max_ores = . if max_ores==max_or
	
	drop max_fo max_fu max_or
}

bys country: egen max_fo = max(max_food)
bys country: egen max_fu = max(max_fuel)
bys country: egen max_or = max(max_ores)

drop max_food max_fuel max_ores

gen maximum = max(max_fo, max_fu, max_or)

* Maximum income per capita en la muestra
bys country: egen m_incpm = max( ny_gdp_pcap_kd )

local contador = 1

forvalues k=1000(1000)50000{
	gen c = country if m_incpm<`k'
	levelsof c, local(coun)
	
	local tot = 0
	foreach w of local coun{
		local tot = `tot' + 1
	}
	
	drop c
	gen c = country if m_incpm<`k' & maximum>30
	levelsof c, local(coun)
	
	local yes = 0
	foreach w of local coun{
		local yes = `yes' + 1
	}
	
	local porcentaje = `yes'/`tot'
	
	drop c
	
	preserve
	if `contador'==1{ 
		clear 
		set obs 1
		gen size = .
		gen percentage = .
	}
	
	if `contador'!=1{ 
		use porcent.dta, clear
		set obs `contador'
	}
		replace size = `k' if _n == `contador'
		replace percentage = `porcentaje' if _n == `contador'
		
		save porcent.dta, replace
	restore
	
	local contador = `contador' + 1
}

preserve
	use porcent.dta, clear
	label var per "% of countries"
	label var siz "GDP per capita"
	twoway (scatter percentage size, c(l) yaxis(1)) , saving(graph1, replace) title("% of countries with commodities > 30% ") scheme(s1color)
	graph export porcentage.eps, replace
	clear
	erase porcent.dta
	erase graph1.gph
restore


drop if country == ""


****************************************************************************************************************************************

keep if maximum>=25

gen product = ""
replace product ="crude petroleum, petroleum gas" if country =="Algeria"
replace product ="??????" if country =="Bahamas, The"
replace product ="Refined petroleum, raw aluminium, petroleum gas" if country =="Bahrain"
replace product ="crude petroleum, raw sugar, fruit juice, bananas, fish" if country =="Belize"
replace product ="petroleum gas, precious metals, zinc ore" if country =="Bolivia"
replace product ="iron ore, crude petroleum, soybeans, raw sugar, poultry meat" if country =="Brazil"
replace product ="crude petroleum, refined petroleum, cocoa beans, wood, bananas" if country =="Cameroon"
replace product ="refined copper, copper ore, raw copper" if country =="Chile"
replace product ="crude petroleum, coal briquettes, refined petroleum" if country =="Colombia"
replace product ="integrated circuits (WTF?!?!?!?!?!?!), office parts, medical instruments" if country =="Costa Rica"
replace product ="cocoa beans, refined petroleum, crude petroleum" if country =="Cote d'Ivoire"
replace product ="????????" if country =="Cyprus"
replace product ="crude petroleum, bananas, crustaceans, fish, refined petroleum" if country =="Ecuador"
replace product ="fish, water, gold, sugar" if country =="Fiji"
replace product ="gold, crude petroleum, cocoa beans" if country =="Ghana"
replace product ="nutmeg, cocoa, fish, wheat" if country =="Grenada"
replace product ="aluminium, fish, ferroalloys" if country =="Iceland"
replace product ="tobacco, radioactive chemicals, sugar" if country =="Malawi"
replace product ="milk, meat, butter, wood" if country =="New Zealand"
replace product ="coffee, gold, meat, sugar" if country =="Nicaragua"
replace product ="crude petroleum, petroleum gas, refined petroleum" if country =="Nigeria"
replace product ="crude petroleum, petroleum gas, refined petroleum" if country =="Norway"
replace product ="soybeans, meat, corn, wheat" if country =="Paraguay"
replace product ="crude petroleum, refined petroleum" if country =="Saudi Arabia"
replace product ="bananas, refined petroleum, beer, water" if country =="St. Lucia"
replace product ="wheat, cassava, rice, animal food" if country =="St. Vincent and the Grenadines"
replace product ="petroleum gas, ammonia, refined petroleum, iron reductions" if country =="Trinidad and Tobago"
replace product ="coffee, refined petroleum, cement, fish" if country =="Uganda"
replace product ="soybeans, meat, rice, wheat" if country =="Uruguay"
replace product ="crude petroleum, refined petroleum, iron ore" if country =="Venezuela"
replace product ="copper, corn, tobbaco, cotton" if country =="Zambia"


save final.dta, replace

****************************************************************************************************************************************
HASTA AQUI VA
****************************************************************************************************************************************




*------------------------------
* Do Data: estimations + figures
*------------------------------

xtset id year

gen iRER = 1/RER
label var iRER "RER"

* Australia
foreach nam in Australia Canada Chile Venezuela Russia{
	corr tt_pri_mrch_xd_wd iRER if countryname=="`nam'"
	local k = round(r(rho), 0.005)
	twoway (scatter iRER year, c(l) yaxis(1)) (scatter tt_pri_mrch_xd_wd year, c(l) yaxis(2))  if countryname == "`nam'", saving(graph1, replace) title("RER  (`k') ") scheme(s1color)
	
	corr tt_pri_mrch_xd_wd ne_exp_gnfs_zs if countryname=="`nam'"
	local k = round(r(rho), 0.005)
	twoway (scatter ne_exp_gnfs_zs year, c(l) yaxis(1)) (scatter tt_pri_mrch_xd_wd year, c(l) yaxis(2))  if countryname == "`nam'", saving(graph2, replace) title("Exports  (`k')") scheme(s1color)

	corr tt_pri_mrch_xd_wd nv_ind_totl_zs if countryname=="`nam'"
	local k = round(r(rho), 0.005)
	twoway (scatter nv_ind_totl_zs year, c(l) yaxis(1)) (scatter tt_pri_mrch_xd_wd year, c(l) yaxis(2))  if countryname == "`nam'", saving(graph3, replace) title("Industry  (`k')") scheme(s1color)

	corr tt_pri_mrch_xd_wd ny_gdp_defl_kd_zg if countryname=="`nam'"
	local k = round(r(rho), 0.005)
	twoway (scatter ny_gdp_defl_kd_zg year, c(l) yaxis(1)) (scatter tt_pri_mrch_xd_wd year, c(l) yaxis(2))  if countryname == "`nam'", saving(graph4, replace) title("Inflation  (`k')") scheme(s1color)

	corr tt_pri_mrch_xd_wd nv_srv_tetc_zs if countryname=="`nam'"
	local k = round(r(rho), 0.005)
	twoway (scatter nv_srv_tetc_zs year, c(l) yaxis(1)) (scatter tt_pri_mrch_xd_wd year, c(l) yaxis(2))  if countryname == "`nam'", saving(graph5, replace) title("Services  (`k')") scheme(s1color)

	corr tt_pri_mrch_xd_wd ic_bus_nreg if countryname=="`nam'"
	local k = round(r(rho), 0.005)
	twoway (scatter ic_bus_nreg year, c(l) yaxis(1)) (scatter tt_pri_mrch_xd_wd year, c(l) yaxis(2))  if countryname == "`nam'", saving(graph6, replace) title("Business  (`k')") scheme(s1color)

	graph combine graph1.gph graph2.gph graph3.gph graph4.gph , rows(2) cols(2) title("`nam'") scheme(s1color) 
	graph export `nam'.eps, replace

	erase graph1.gph 
	erase graph2.gph 
	erase graph3.gph 
	erase graph4.gph 
	erase graph5.gph 
	erase graph6.gph
}

* keys: twoway (scatter tx_val_manf_zs_un year, c(l) yaxis(1)) (scatter tt_pri_mrch_xd_wd year, c(l) yaxis(2))  if countryname == "Chile", title("RER  (`k') ") scheme(s1color)
* twoway (scatter tx_val_mmtl_zs_un year, c(l) yaxis(1)) (scatter tt_pri_mrch_xd_wd year, c(l) yaxis(2))  if countryname == "Canada", title("RER  (`k') ") scheme(s1color)
* twoway (scatter tx_val_fuel_zs_un year, c(l) yaxis(1)) (scatter tt_pri_mrch_xd_wd year, c(l) yaxis(2))  if countryname == "Russia", title("RER  (`k') ") scheme(s1color)
* twoway (scatter tx_val_ictg_zs_un year, c(l) yaxis(1)) (scatter tt_pri_mrch_xd_wd year, c(l) yaxis(2))  if countryname == "Venezuela", title("RER  (`k') ") scheme(s1color)

* xtreg iRER tt_pri_mrch_xd_wd i.year, fe
