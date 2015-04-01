*--------------------------------------------------------------------
*--------------------------------------------------------------------
* Dutch Disease Project
* Eugenio Rojas and David Zarruk, Philadelphia, March 2015
*
* This dofile creates the IMF databases that we use
*
*--------------------------------------------------------------------
*--------------------------------------------------------------------

clear all
set more off

*cd "C:\Users\Eugenio Rojas\Desktop\dutch"
cd "C:\Users\david\Dropbox\Documents\Doctorado\Second year\Semester II (2015 I)\712 - Mendoza (International macro with incomplete markets and fin frict)\Proposals Mendoza\Data_ToT\dutch"

use "Databases\IMF_raw.dta"

rename value v

levelsof conceptcode, local(conc)
foreach v of local conc{
	levelsof conceptlabel if conceptcode=="`v'", local(l_`v')
}

levelsof datasourcecode, local(dat)
foreach v of local dat{
	levelsof datasourcelabel if datasourcecode=="`v'", local(l_`v')
	disp("`v'")
}

levelsof unitcode, local(uni)
foreach v of local uni{
	levelsof unitlabel if unitcode=="`v'", local(l_`v')
}


keep conceptcode countrylabel  unitcode timecode datasourcecode v

gen type = conceptcode+"_"+ datasourcecode+"_"+unitcode
drop conceptcode datasourcecode unitcode

reshape wide v, i(countrylabel  timecode ) j(type) string

foreach v of local conc{
	foreach w of local dat{
		foreach y of local uni{
		
		foreach s1 of local l_`v'{
			foreach s2 of local l_`w'{
				foreach s3 of local l_`y'{
					cap label var v`v'_`w'_`y' "`s1', units: `s3', source: `s2'"
				}
			}
		}
			
		}
	}
}

rename countrylabel country
rename timecode year

save "Databases\IMF.dta", replace
