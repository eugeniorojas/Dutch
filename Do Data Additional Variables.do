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

cd "C:\Users\Eugenio Rojas\Desktop\dutch"
*cd "C:\Users\david\Dropbox\Documents\Doctorado\Second year\Semester II (2015 I)\712 - Mendoza (International macro with incomplete markets and fin frict)\Proposals Mendoza\Data_ToT\dutch"

*use "Databases\trade_wb.dta", clear
use "trade_wb.dta", clear
*mmerge countryname countrycode year region using "Databases\economy_growth_wb.dta" 
merge m:m countryname countrycode year region using "economy_growth_wb.dta" 
drop _merge 
*mmerge countryname countrycode year region using "Databases\private_sector_wb.dta" 
merge m:m countryname countrycode year region using "private_sector_wb.dta" 
drop _merge 


keep countryname year bg_gsr_nfsv_g~s  bm_gsr_gnfs_cd bm_gsr_mrch_cd bm_gsr_nfsv_cd bx_gsr_gnfs_cd bx_gsr_mrch_cd bx_gsr_nfsv_cd bx_gsr_totl_cd ne_exp_gnfs_kd  ne_exp_gnfs_k~g ne_imp_gnfs_kd ne_imp_gnfs_k~g ne_exp_gnfs_zs ne_imp_gnfs_zs ne_trd_gnfs_zs tm_val_manf_z~n tm_val_mmtl_zs_un tt_pri_mrch_xd_wd    bn_cab_xoka_cd    bn_cab_xoka_g~s  bx_klt_dinv_c~d  dt_dod_dect_e~s  dt_dod_dstc_x~s dt_int_dect_e~s   dt_tds_dect_e~s dt_dod_dect_g~s dt_tds_dect_g~s fp_cpi_totl_zg gc_dod_totl_g~s gc_xpn_comp_zs ne_rsb_gnfs_zs nv_agr_totl_zs nv_ind_manf_zs nv_ind_totl_zs nv_mnf_mtrn_z~n nv_srv_tetc_zs ny_gdp_defl_k~g  ne_con_petc_zs  ne_gdi_ftot_zs  ne_gdi_totl_zs ny_gdp_pcap_kd ny_gdp_mktp_kd  fs_ast_prvt_g~s ic_bus_nreg tx_val_food_z~n tx_val_fuel_z~n tx_val_ictg_z~n tx_val_manf_z~n tx_val_mmtl_z~n tx_val_tech_m~s tx_val_tech_cd bn_cab_xoka_g~s

keep if countryname=="Chile" | countryname=="Australia" | countryname == "Canada" | countryname == "Russian Federation" | countryname == "Venezuela, RB" 
*mmerge countryname year using "Databases\RER.dta"
merge m:m countryname year using "RER.dta"
keep if _merge==3
drop _merge 					// The dropped observations are because years do not coincide. 

encode countryname, generate(id)

label var tt_pri_mrch_xd_wd "ToT"
label var ne_exp_gnfs_zs "Exports"
label var ny_gdp_defl_kd_zg "Inflation"
label var nv_ind_totl_zs "Industry"
label var nv_srv_tetc_zs "Services"
label var ic_bus_nreg "Bussinesses"

replace countryname = "Russia" if countryname == "Russian Federation"
replace countryname = "Venezuela" if countryname == "Venezuela, RB"

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
