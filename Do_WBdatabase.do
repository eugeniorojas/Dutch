*--------------------------------------------------------------------
*--------------------------------------------------------------------
* Dutch Disease Project
* Eugenio Rojas and David Zarruk, Philadelphia, March 2015
*
* This dofile creates the world bank databases that we use
*
*--------------------------------------------------------------------
*--------------------------------------------------------------------

clear all
set more off

cd "C:\Users\Eugenio Rojas\Desktop\dutch"
*cd "C:\Users\david\Dropbox\Documents\Doctorado\Second year\Semester II (2015 I)\712 - Mendoza (International macro with incomplete markets and fin frict)\Proposals Mendoza\Data_ToT\dutch"


* The variables we will keep from each database: trade, private sector and economy + growth
global tradevars "bg_gsr_nfsv_gd_zs bm_gsr_gnfs_cd bm_gsr_mrch_cd bm_gsr_nfsv_cd bx_gsr_gnfs_cd bx_gsr_mrch_cd bx_gsr_nfsv_cd bx_gsr_totl_cd ne_exp_gnfs_kd ne_exp_gnfs_kd_zg ne_exp_gnfs_zs ne_imp_gnfs_kd ne_imp_gnfs_kd_zg ne_imp_gnfs_zs ne_trd_gnfs_zs tm_val_manf_zs_un tm_val_mmtl_zs_un tt_pri_mrch_xd_wd tx_val_ictg_z~n tx_val_fuel_z~n tx_val_mmtl_z~n tx_val_manf_z~n"
global privavars "fs_ast_prvt_gd_zs ic_bus_nreg"
global econvars "ny_gdp_mktp_cd bn_cab_xoka_cd bn_cab_xoka_gd_zs bx_klt_dinv_cd_wd dt_dod_dect_ex_zs dt_dod_dect_gn_zs dt_dod_dstc_xp_zs dt_int_dect_ex_zs dt_tds_dect_ex_zs dt_tds_dect_gn_zs fp_cpi_totl_zg gc_dod_totl_gd_zs gc_xpn_comp_zs ne_con_petc_zs ne_gdi_ftot_zs ne_gdi_totl_zs ne_rsb_gnfs_zs nv_agr_totl_zs nv_ind_manf_zs nv_ind_totl_zs nv_mnf_mtrn_zs_un nv_srv_tetc_zs ny_gdp_defl_kd_zg ny_gdp_mktp_kd ny_gdp_pcap_kd" /*nv_ind_totl_cd nv_ind_manf_cd nv_ind_minq_cd"*/
global socialvars " sl_agr_empl_zs sl_emp_tot~p_zs  sl_emp_work_zs sl_ind_empl_zs sl_srv_empl_zs sl_uem_totl_n~s " 

wbopendata, topics(21 - Trade) long clear
keep if countrycode=="AUS" | countrycode=="CHL" | countrycode=="CAN" | countrycode=="VEN" | countrycode=="COL" | countrycode=="RUS" 
keep $tradevars countryname countrycode year 
save wbdata.dta, replace

wbopendata, topics(12 - Private Sector ) long clear
keep if countrycode=="AUS" | countrycode=="CHL" | countrycode=="CAN" | countrycode=="VEN" | countrycode=="COL" | countrycode=="RUS" 
keep $privavars countryname countrycode year 
mmerge countrycode year using wbdata.dta
save wbdata.dta, replace

wbopendata, topics(10 - Social Protection & Labor) long clear
keep if countrycode=="AUS" | countrycode=="CHL" | countrycode=="CAN" | countrycode=="VEN" | countrycode=="COL" | countrycode=="RUS" 
keep $socialvars countryname countrycode year 
mmerge countrycode year using wbdata.dta
save wbdata.dta, replace

wbopendata, topics(3 - Economy & Growth) long clear
keep if countrycode=="AUS" | countrycode=="CHL" | countrycode=="CAN" | countrycode=="VEN" | countrycode=="COL" | countrycode=="RUS" 
keep $econvars countryname countrycode year 
mmerge countrycode year using wbdata.dta
drop _merge
save wbdata.dta, replace


pico
/*
wbopendata, topics(21 - Trade) long clear
keep if countrycode=="AUS" | countrycode=="CHI" | countrycode=="CAN" | countrycode=="VEN" | countrycode=="COL" | countrycode=="RUS" 
keep tx_val_ictg_z~n tx_val_fuel_z~n tx_val_mmtl_z~n tx_val_manf_z~n countryname countrycode year 
mmerge countrycode year using wbdata.dta
save wbdata.dta, replace
*/





