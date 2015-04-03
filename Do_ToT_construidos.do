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

use "Databases\IMF.dta", clear

drop if country=="World" | country=="Western Hemisphere" | country=="APEC" | country=="Advanced Economies" | country=="All Countries" | country=="CEMAC" 
drop if country=="CFA franc zone" | country=="CIS" | country=="Common Market of Eastern and Southern.." | country=="East African Community (EAC -5)" 
drop if country=="Eastern Caribbean Currency Union" | country=="Economic Community of West African St.." | country=="Emerging and Developing Asia" 
drop if country=="Emerging and Developing Countries" | country=="Emerging and Developing Europe" | country=="Euro Area" | country=="Europe" | country=="European Union" 
drop if country=="Export earnings: fuel" | country=="Export earnings: nonfuel" | country=="International Organizations" | country=="International Organizations " | country=="Middle East and North Africa" 
drop if country=="Middle East, North Africa, Afghanista.." | country=="Other Countries n.i.e." | country=="SACCA excluding South Africa" 
drop if country=="SSA Multilateral Debt Relief Initiati.." | country=="SSA fixed exchange rate regime countr.." | country=="SSA floating exchange rate regime cou.."
drop if country=="SSA fragile countries" | country=="SSA low-income countries" | country=="SSA low-income countries excluding fr.." | country=="SSA middle-income countries" 
drop if country=="SSA middle-income countries excluding.." | country=="SSA oil-exporting countries" | country=="SSA oil-exporting countries excluding.." 
drop if country=="SSA oil-importing countries" | country=="SSA oil-importing countries excluding.." | country=="South African Common Customs Area (SA.." 
drop if country=="Southern African Customs Union (SACU)" | country=="Southern African Development Communit.." | country=="Sub-Saharan Africa excluding Nigeria .."
drop if country=="Sub-Saharan Africa excluding South Su.." | country=="Sub-Saharan Africa excluding Zimbabwe" | country=="West African Economic and Monetary Un.."

keep if country=="Chile" | country=="Australia" | country=="Canada" | country=="Russian Federation" | country=="Venezuela, Republica Bolivariana de"

gen TOT = vTXG_D_IFS_DUS / vTMG_D_IFS_DUS

bys country: egen mean = mean(TOT)
bys country: egen sd = sd(TOT)
gen up = mean + sd
gen dn = mean - sd

twoway (scatter TOT year,c(1)) (scatter up year, msymbol(i) c(1)) (scatter dn year, msymbol(i) c(1))   if country == "Australia" & TOT!=., saving(graph1, replace) legend(off) title("RER  (`k') ")  scheme(s1color) 

bys country: gen num=1 if TOT>=up & TOT!=.

gen t=.
bys country: replace t=1 if num==num[_n-1] & num[_n-1]==num[_n-2] & num[_n-2]==num[_n-3] & num!=. & num[_n-1]!=. & num[_n-2]!=. & num[_n-3]!=. 

bys country: gen w=1 if t[_n+3]!=. | t[_n+2]!=. | t[_n+1]!=. | t!=.
drop t
bys country: egen sum2 = max(w)
rename sum2 tograph
drop num

replace tograph=0 if tograph==.

bys country: gen num2 = sum(w) if tograph==1
replace num2=0 if tograph==0
replace num2=1 if num2!=0

bys country: replace num2=sum(num2)
gen num3 = num2[_n+3]-2

gen haydatos=1 if TOT!=.
bys country: egen sufi = sum(haydatos)


* dropeo paises que tienen menos de 30 anhos de TOT y los que no tienen mas de tres anhos seguidos por encima/
* debajo de la media mas/menos una desviacion estandar durante c periodos consecutivos
drop if sufi<=30
drop if num3<-1
drop num3 w haydatos sufi

replace num2=-2 if num2[_n+3]==1
replace num2=-1 if num2[_n+2]==1

rename vAIP_IFS_IND2005 industrial_prod 
rename vEREER_AFRREO_IND2000 RER
rename vLEMA_IFS_IND2010SA empl_manuf
rename vLEMI_IFS_IND2010SA empl_min
rename vLE_IFS_PER empl

*replace empl_manuf=empl_manuf/empl
*replace empl_min=empl_min/empl

collapse (mean) TOT empl* RER, by(num2)

twoway (scatter TOT num2,c(1) yaxis(1)) (scatter empl_manuf num2,c(1) yaxis(2)) , saving(graph1, replace) legend(off) title("RER  (`k') ")  scheme(s1color) 








