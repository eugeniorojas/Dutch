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
* Do Data
*------------------------------

*cd "C:\Users\Eugenio Rojas\Desktop\dutch"
cd "C:\Users\david\Dropbox\Documents\Doctorado\Second year\Semester II (2015 I)\712 - Mendoza (International macro with incomplete markets and fin frict)\Proposals Mendoza\Data_ToT\dutch\Preliminary"

use trade_wb.dta, clear
mmerge countryname countrycode year region using "economy_growth_wb.dta" 
drop _merge 
mmerge countryname countrycode year region using "private_sector_wb.dta" 
drop _merge 


keep countryname countrycode iso2code region regioncode year bg_gsr_nfsv_g~s  bm_gsr_gnfs_cd bm_gsr_mrch_cd bm_gsr_nfsv_cd bx_gsr_gnfs_cd bx_gsr_mrch_cd bx_gsr_nfsv_cd bx_gsr_totl_cd ne_exp_gnfs_kd  ne_exp_gnfs_k~g ne_imp_gnfs_kd ne_imp_gnfs_k~g ne_exp_gnfs_zs ne_imp_gnfs_zs ne_trd_gnfs_zs tm_val_manf_z~n tm_val_mmtl_zs_un tt_pri_mrch_xd_wd    bn_cab_xoka_cd    bn_cab_xoka_g~s  bx_klt_dinv_c~d  dt_dod_dect_e~s  dt_dod_dstc_x~s dt_int_dect_e~s   dt_tds_dect_e~s dt_dod_dect_g~s dt_tds_dect_g~s fp_cpi_totl_zg gc_dod_totl_g~s gc_xpn_comp_zs ne_rsb_gnfs_zs nv_agr_totl_zs nv_ind_manf_zs nv_ind_totl_zs nv_mnf_mtrn_z~n nv_srv_tetc_zs ny_gdp_defl_k~g  ne_con_petc_zs  ne_gdi_ftot_zs  ne_gdi_totl_zs ny_gdp_pcap_kd ny_gdp_mktp_kd  fs_ast_prvt_g~s ic_bus_nreg 

keep if countryname=="Chile" | countryname=="Australia" | countryname == "Canada" | countryname == "Russian Federation" | countryname == "Venezuela, RB" 
mmerge countryname year using "RER.dta"
keep if _merge==3 					// The dropped observations are because years do not coincide. 

encode countryname, generate(id)

xtset id year

gen iRER = 1/RER

xtreg iRER tt_pri_mrch_xd_wd i.year, fe

stap
********
clear

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
save RER.dta, replace

stap

RBCLBIS RBCABIS RBRUBIS RBVEBIS
import delimited "C:\Users\Eugenio Rojas\Desktop\dutch\tt.pri.mrch.xd.wd_Indicator_en_csv_v2.csv", varnames(2) 

forvalue i=1960/2014{
	local J = `i'-1955
	gen year`i' = v`J'
		}
		
drop indicatorname indicatorcode v5-v60

reshape long year, i(countryname) j(year2)

rename year tot
rename year2 year

drop if year<1980
