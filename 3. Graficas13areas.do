
clear all
cd "\\MEDE1174089\DANE_Anexos\Anexos DANE\Datos\Noviembre 2014"
use "13_Areas.dta", clear

/* d.1   ... diferencia de orden "1"
   t.12  ... diferencia de orden "12"
*/
rename mes periodo
gen period2=periodo
tset periodo, monthly

rename  Construcción Construccion
rename  Otro OtraActividad

rename  Informales_IndustriaManufacture Informales_Industria
rename  Formales_IndustriaManufacturera Formales_Industria
rename  Informales_Construccin          Informales_Constru 
rename  Formales_Construccin            Formales_Constru
rename  Informales_Comerciohotelesyr    Informales_Comercio
rename  Formales_Comerciohotelesyres    Formales_Comercio
rename  Informales_Transportealmacenam  Informales_Transp
rename  Formales_Transportealmacenamie  Formales_Transp
rename  Informales_Intermediacinfinanc  Informales_Finanzas
rename  Formales_Intermediacinfinancie  Formales_Finanzas
rename  Formales_Actividadesinmobiliari Formales_Inmob
rename  Informales_Actividadesinmobilia Informales_Inmob
rename  Informales_Servicioscomunales   Informales_Servicios
rename  Formales_Servicioscomunaless    Formales_Servicios

gen   Ocupados_Superior=Total_Superior 
gen   Ocupados_NoSuperior=(Total_Ninguno+Total_Primaria+Total_Secundaria+Total_Noinforma)

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* * * Creando Tasas de Crecimiento Anual  * * *
/*usuario: introduzca variables para encontrar tasas de crecimiento anual en el local Tasas*/
local Tasas "Asalariado NoAsalariado Formales_Asalariado Informales_Asalariado Formales_NoAsalariado Informales_NoAsalariado Formales Informales Formales_Superior Formales_NoSuperior Informales_NoSuperior Informales_Superior Industria Construccion ComercioHR Transporte Finanzas Inmobiliario Servicios OtraActividad  Formales_Industria Informales_Industria Informales_Constru Formales_Constru Informales_Comercio Formales_Comercio Informales_Transp Formales_Transp Informales_Finanzas Formales_Finanzas Informales_Inmob Formales_Inmob Informales_Servicios Formales_Servicios Informales_Otras Formales_Otras Ocupados_Superior Ocupados_NoSuperior "


foreach V of local Tasas{
gen    `V'_t12=100*(`V' - l12.`V')/l12.`V'
format `V'_t12 %10.2f
}
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
gen percentage="%"

local empl "Asalariado_t12 NoAsalariado_t12 "
foreach e of local empl {
tostring `e',gen(`e'LABEL) force format(%03.2f)
replace  `e'LABEL="" if periodo<ym(2014, 11)
replace  `e'LABEL=substr(`e'LABEL,1,3)
egen     `e'LABELP=concat(`e'LABEL percentage) if `e'LABEL!=""
  }
local empl2 "Formales_Asalariado_t12 Formales_t12 Informales_t12 Ocupados_Superior_t12 Ocupados_NoSuperior_t12"
foreach e of local empl2 {
tostring `e',gen(`e'LABEL) force format(%03.2f)
replace  `e'LABEL="" if periodo<ym(2014, 10) //DATOS DISPONIBLES HASTA OCTUBRE
replace  `e'LABEL=substr(`e'LABEL,1,3)
egen     `e'LABELP=concat(`e'LABEL percentage) if `e'LABEL!=""
  }
  local empl3 "Informales_Asalariado_t12 Formales  Informales "
foreach e of local empl3 {
tostring `e',gen(`e'LABEL) force format(%03.2f)
replace  `e'LABEL="" if periodo<ym(2014, 10) //DATOS DISPONIBLES HASTA OCTUBRE
replace  `e'LABEL=substr(`e'LABEL,1,4)
egen     `e'LABELP=concat(`e'LABEL percentage) if `e'LABEL!=""
  }
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

* * * Empleo Asalariado y No Asalariado (Tasa Anual) Todo el Periodo* * * 
la var Asalariado_t12 "Asalariados"
la var NoAsalariado_t12 "No Asalariados"

twoway (connected Asalariado_t12   periodo if periodo>=ym(2002, 1),   msymbol(none) mlabel(Asalariado_t12LABELP)   mlabposition(3)  mlabgap(*0) mlabcolor(midblue) mlabsize(vsmall)  sort lcolor(midblue) lpattern(dot)    lwidth(thick) )    ///
       (connected NoAsalariado_t12 periodo if periodo>=ym(2002, 1),   msymbol(none) mlabel(NoAsalariado_t12LABELP) mlabposition(3)   mlabgap(*0) mlabcolor(gray)    mlabsize(vsmall)  sort lcolor(gray)   lpattern(dash)    lwidth(thick)) , ///                   
xlabel(#16, labsize(vsmall) angle(vertical)) title("Tasa de crecimiento anual del empleo") subtitle("Asalariados y no asalariados. 13 Áreas. (2002m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(horizontal))  graphregion(fcolor(white)) legend(on  region(lcolor(white)))       ///
xtitle("Trimestre móvil", size(vsmall)) xline(576, lcolor(red) lpattern(dash))
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\EmpAsalNoAsal.png", width(800) height(600) replace


* * * 2011-Actual* * * 
twoway (connected Asalariado_t12   periodo if periodo>=ym(2011, 1),   msymbol(none) mlabel(Asalariado_t12LABELP)   mlabposition(12)  mlabgap(*6) mlabcolor(midblue) mlabsize(vsmall)  sort lcolor(midblue) lpattern(dot)    lwidth(thick) )    ///
       (connected NoAsalariado_t12 periodo if periodo>=ym(2011, 1),   msymbol(none) mlabel(NoAsalariado_t12LABELP) mlabposition(12)              mlabcolor(gray)    mlabsize(vsmall)  sort lcolor(gray)   lpattern(dash)    lwidth(thick)) , ///                                     
xlabel(#16, labsize(vsmall) angle(vertical)) title("Tasa de crecimiento anual del Empleo") subtitle("Asalariados y no asalariados. 13 Áreas. (2011m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(horizontal))  graphregion(fcolor(white)) legend(on  region(lcolor(white)))       ///
xtitle("Trimestre móvil", size(vsmall))
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\EmpAsalNoAsal2.png", width(800) height(600) replace

* * * * * * * * * * * *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

* * * Empleo Asalariado Formal e Informal 2011-Actual* * * 
* * * 2011-Actual* * * 
la var Formales_Asalariado_t12   "Asalariado Formal"
la var Informales_Asalariado_t12 "Asalariado Informal"

twoway (connected Asalariado_t12            periodo if periodo>=ym(2011, 1),   msymbol(none) mlabel(Asalariado_t12LABELP)            mlabposition(3)               mlabcolor(midblue) mlabsize(vsmall)  sort lcolor(midblue) lpattern(dot)    lwidth(thick) )    ///
       (connected Informales_Asalariado_t12 periodo if periodo>=ym(2011, 1),   msymbol(none) mlabel(Informales_Asalariado_t12LABELP) mlabposition(3)               mlabcolor(black)   mlabsize(vsmall)   sort lcolor(black)   lpattern(dash)    lwidth(thick))        ///
       (connected Formales_Asalariado_t12   periodo if periodo>=ym(2011, 1),   msymbol(none) mlabel(Formales_Asalariado_t12LABELP)   mlabposition(3)  mlabgap(*1) mlabcolor(gray)    mlabsize(vsmall)   sort lcolor(gray)    lpattern(solid)   lwidth(thick) )   , /// 
xlabel(#17, labsize(vsmall) angle(vertical)) title("Tasa de crecimiento anual del empleo") subtitle("Asalariados. Formales e informales. 13 Áreas. (2011m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(horizontal))  graphregion(fcolor(white)) legend(on  region(lcolor(white))) yline(0 , lcolor(black))      ///
xtitle("Trimestre móvil", size(vsmall))
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\EAFormInform.png", width(800) height(600) replace

* * * * * * * * * * * *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

* * * TGP y TO   * * * * 
la var TGP "Tasa Global de Participación"
la var TO "Tasa de Ocupación"

local TO "TGP TO T_Sub_Sub T_Sub_Obj T_Sub_Sub_Horas "

foreach e of local TO {
tostring `e',gen(`e'LABEL) force format(%03.2f)
replace  `e'LABEL="" if periodo<ym(2014, 11)
replace  `e'LABEL=substr(`e'LABEL,1,4)
egen     `e'LABELP=concat(`e'LABEL percentage) if `e'LABEL!=""
  }
local TO2 "T_Sub_Obj_Horas TD"

foreach e of local TO2 {
tostring `e',gen(`e'LABEL) force format(%03.2f)
replace  `e'LABEL="" if periodo<ym(2014, 11)
replace  `e'LABEL=substr(`e'LABEL,1,3)
egen     `e'LABELP=concat(`e'LABEL percentage) if `e'LABEL!=""
  }
  *
format TGP TO T_Sub_Sub T_Sub_Obj %10.1f

twoway (connected TGP  periodo if periodo>=ym(2002, 1),   msymbol(none) mlabel(TGPLABELP)  mlabposition(10)                  mlabcolor(midblue) mlabsize(vsmall)  sort lcolor(midblue) lpattern(dot)    lwidth(thick))    ///
       (connected TO   periodo if periodo>=ym(2002, 1),   msymbol(none) mlabel(TOLABELP)   mlabposition(6)  mlabgap(*12) mlabcolor(gray)    mlabsize(vsmall)  sort lcolor(gray)    lpattern(solid)   lwidth(thick) yaxis(2) )   , ///   
xlabel(#13, labsize(vsmall) angle(vertical)) title("Tasa Global de Participación y Tasa de Ocupación") subtitle("13 Áreas. (2002m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(horizontal)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on  region(lcolor(white)))       ///
xtitle("Trimestre móvil", size(vsmall)) ytitle("Tasa Global de Participación"  , size(vsmall) axis(1))  ytitle("Tasa de Ocupación"  , size(vsmall) axis(2)) xline(576, lcolor(red) lpattern(dash))
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\TGP_TO.png", width(800) height(600) replace

twoway (connected TGP  periodo if periodo>=ym(2011, 1),  msymbol(none) mlabel(TGPLABELP)  mlabposition(12)  /*mlabgap(*6)*/  mlabcolor(midblue) mlabsize(vsmall)  sort lcolor(midblue) lpattern(dot)    lwidth(thick))    ///
       (connected TO   periodo if periodo>=ym(2011, 1),  msymbol(none) mlabel(TOLABELP)   mlabposition(8)  mlabgap(*5) mlabcolor(gray)    mlabsize(vsmall)  sort lcolor(gray)    lpattern(solid)   lwidth(thick) yaxis(2) )   , ///   
xlabel(#16, labsize(vsmall) angle(vertical)) title("Tasa Global de Participación y Tasa de Ocupación") subtitle("13 Áreas. (2011m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(horizontal)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on  region(lcolor(white)))       ///
xtitle("Trimestre móvil", size(vsmall)) ytitle("Tasa Global de Participación"  , size(vsmall) axis(1))  ytitle("Tasa de Ocupación"  , size(vsmall) axis(2))
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\TGP_TO2.png", width(800) height(600) replace

* * * * * * * * * * * *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

* * * Empleo  Subjetivo   * * * * 
la var T_Sub_Sub "Subempleo Subjetivo"
la var T_Sub_Obj "Subempleo Objetivo"

twoway (connected T_Sub_Sub   periodo  if periodo>=ym(2008, 1),    msymbol(none) mlabel(T_Sub_SubLABELP)  mlabposition(12)  mlabgap(*1) mlabcolor(gray)    mlabsize(vsmall)    sort lcolor(gray)    lpattern(dot) lwidth(thick))      ///
       (connected T_Sub_Obj   periodo  if periodo>=ym(2008, 1),    msymbol(none) mlabel(T_Sub_ObjLABELP)  mlabposition(11)  mlabgap(*3) mlabcolor(midblue) mlabsize(vsmall)    sort lcolor(midblue) lpattern(soild) lwidth(thick) yaxis(2))   , /// 
xlabel(#13, labsize(vsmall) angle(vertical)) title("Tasas de subempleo subjetivo y objetivo") subtitle("13 Áreas. (2008m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(horizontal)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on  region(lcolor(white)))       ///
ytitle("Subjetivo", size(vsmall) axis(1)) ytitle("Objetivo", size(vsmall) axis(2)) xtitle("Trimestre móvil", size(vsmall))
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\SubyObj.png", width(800) height(600) replace

*Tasa de Subempleo Objetivo por Horas
format  T_Sub_Obj_Horas T_Sub_Sub_Horas %10.1f
la var  T_Sub_Obj_Horas "Subempleo Objetivo  por Horas"
la var  T_Sub_Sub_Horas "Subempleo Subjetivo por Horas"

twoway (connected T_Sub_Obj_Horas periodo  if periodo>=ym(2008, 1),  msymbol(none) mlabel(T_Sub_Obj_HorasLABELP)  mlabposition(5)  mlabgap(*0) mlabcolor(gray)    mlabsize(vsmall)    sort lcolor(gray)    lpattern(dot) lwidth(thick))      ///
       (connected T_Sub_Sub_Horas periodo  if periodo>=ym(2008, 1),  msymbol(none) mlabel(T_Sub_Sub_HorasLABELP)  mlabposition(12)  mlabgap(*0) mlabcolor(midblue) mlabsize(vsmall)    sort lcolor(midblue) lpattern(soild) lwidth(thick) yaxis(2))   , /// 
xlabel(#15, labsize(vsmall) angle(vertical)) title("Tasas de subempleo por insuficiencia de horas") subtitle("Objetivo y subjetivo. 13 Áreas.(2008m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(horizontal)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on hole(2) region(lcolor(white)))       ///
ytitle("Objetivo", size(vsmall) axis(1)) ytitle("Subjetivo", size(vsmall) axis(2)) xtitle("Trimestre móvil", size(vsmall))
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\SubyObjHoras.png", width(800) height(600) replace

*Tasa de Embleo Subjetivo e insuficiencia de horas en el Objetivo
la var T_Sub_Sub "Subempleo Subjetivo"
la var T_Sub_Obj "Subempleo Objetivo"
twoway (connected T_Sub_Sub       periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(T_Sub_SubLABELP)       mlabposition(12)               mlabcolor(midblue) mlabsize(vsmall)  sort lcolor(midblue) lpattern(dot)    lwidth(thick) )    ///
       (connected T_Sub_Obj       periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(T_Sub_ObjLABELP)       mlabposition(12)              mlabcolor(black)   mlabsize(vsmall)   sort lcolor(black)   lpattern(dash)    lwidth(thick) yaxis(2))   ///
       (connected T_Sub_Obj_Horas periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(T_Sub_Obj_HorasLABELP) mlabposition(6)  mlabgap(*6)  mlabcolor(gray)    mlabsize(vsmall)   sort lcolor(gray)    lpattern(solid)   lwidth(thick) yaxis(2))    , ///    
xlabel(#13, labsize(vsmall) angle(vertical)) title("Tasas de subempleo objetivo y subjetivo") subtitle("13 Áreas. (2008m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(horizontal)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on hole(2) region(lcolor(white)))       ///
ytitle("Tasa subempleo subjetivo", size(vsmall) axis(1)) ytitle("Tasa subempleo objetivo y objetivo por horas", size(vsmall) axis(2)) xtitle("Trimestre móvil", size(vsmall))
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\SubyObj2.png", width(800) height(600) replace

* * * * * * * * * * * *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

* * * Formales e Informales y Tasa de Crecimiento
la var Formales_t12 "Tasa de Crecimiento anual"

format Formales Informales %10.0f
twoway (connected Formales     periodo if period2>=ym(2010, 1),  msymbol(none) mlabel(FormalesLABEL)       mlabposition(12)               mlabcolor(midblue) mlabsize(vsmall)    sort lcolor(midblue) lpattern(dot)    lwidth(thick) )    ///
       (connected Formales_t12 periodo if period2>=ym(2010, 1),  msymbol(none) mlabel(Formales_t12LABELP) mlabposition(6)  mlabgap(*6)  mlabcolor(gray)    mlabsize(vsmall)      sort lcolor(gray)    lpattern(solid)  lwidth(thick) yaxis(2))    , ///                   
xlabel(#18, labsize(vsmall) angle(vertical)) title("Empleo formal y tasa de crecimiento anual") subtitle("Asalariados. 13 Áreas. (2010m1-2014m10)")      ///
ylabel(#10, labsize(vsmall) angle(horizontal)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on hole(2) region(lcolor(white)) label(1 Formales) label(2 "" ) label(3 Tasa de Crecimiento anual)) legend(order(1 3)) ///
ytitle("Formales", size(vsmall) axis(1)) ytitle("Tasa de crecimiento", size(vsmall) axis(2)) xtitle("Trimestre móvil", size(vsmall))
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\FormTasa.png", width(800) height(600) replace

twoway (connected Informales     periodo if periodo>=ym(2010, 1),  msymbol(none) mlabel(InformalesLABEL)       mlabposition(12)              mlabcolor(midblue) mlabsize(vsmall)    sort lcolor(midblue) lpattern(dot)    lwidth(thick) )    ///
       (connected Informales_t12 periodo if periodo>=ym(2010, 1),  msymbol(none) mlabel(Informales_t12LABELP)  mlabposition(12)  mlabgap(*3)  mlabcolor(gray)    mlabsize(vsmall)   sort lcolor(gray)    lpattern(solid)  lwidth(thick) yaxis(2))    , ///                                   
xlabel(#16, labsize(vsmall) angle(vertical)) title("Empleo informal y tasa de crecimiento anual") subtitle("Asalariados. 13 Áreas. (2010m1-2014m10)")      ///
ylabel(#10, labsize(vsmall) angle(horizontal)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on hole(2) region(lcolor(white)) label(1 Informales) label(2 "" ) label(3 Tasa de Crecimiento anual)) legend(order(1 3)) ///
ytitle("Informales", size(vsmall) axis(1)) ytitle("Tasa de crecimiento", size(vsmall) axis(2)) xtitle("Trimestre móvil", size(vsmall))
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\InforTasa.png", width(800) height(600) replace

* * * * * * * * * * * *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

* * *  Tasa de Desempleo
la var TD "Tasa de Desempleo"
	twoway (connected TD  periodo if periodo>=ym(2011, 1),   msymbol(none) mlabel(TDLABELP)       mlabposition(1)    mlabgap(*0)     mlabcolor(midblue) mlabsize(vsmall)    sort lcolor(midblue) lpattern(dot)    lwidth(thick))  , ///    
xlabel(#16, labsize(vsmall) angle(vertical)) title("Tasa de Desempleo") subtitle("13 Áreas. (2011m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(hor))  graphregion(fcolor(white)) legend(on hole(2) region(lcolor(white))) ///
ytitle("Variación porcentual", size(vsmall) axis(1)) xtitle("Trimestre móvil", size(vsmall))
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\TasaD.png", width(800) height(600) replace

format TD %10.0f
twoway  (connected TD   periodo if periodo>=ym(2002, 1),     msymbol(none) mlabel(TDLABELP)       mlabposition(1)              mlabcolor(midblue) mlabsize(vsmall)    sort lcolor(midblue) lpattern(dot)    lwidth(thick))  , ///    
xlabel(#16, labsize(vsmall) angle(vertical)) title("Tasa de Desempleo") subtitle("13 Áreas. (2002m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(hor))  graphregion(fcolor(white)) legend(on hole(2) region(lcolor(white))) ///
ytitle("Variación porcentual", size(vsmall) axis(1)) xtitle("Trimestre móvil", size(vsmall)) xline(576, lcolor(red) lpattern(dash))
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\TasaD2.png", width(800) height(600) replace

* * * * * * * * * * * *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

* * * * * * * * EDUCACIÓN * * * * * * * * 
*Ocupados_Superior Ocupados_NoSuperior
la var Ocupados_Superior_t12 "Tasa de Crecimiento Ocupados con Superior"
la var Ocupados_NoSuperior_t12 "Tasa de Crecimiento Ocupados Sin Superior"

twoway (connected Ocupados_Superior_t12   periodo if periodo>=ym(2011, 1),  msymbol(none) mlabel(Ocupados_Superior_t12LABELP)    mlabposition(6)               mlabcolor(midblue) mlabsize(vsmall)  sort lcolor(midblue) lpattern(dot)    lwidth(thick) )    ///
       (connected Ocupados_NoSuperior_t12 periodo if periodo>=ym(2011, 1),  msymbol(none) mlabel(Ocupados_NoSuperior_t12LABELP) mlabposition(12)  mlabgap(*6)   mlabcolor(gray)    mlabsize(vsmall)      sort lcolor(gray)    lpattern(solid)  lwidth(thick) yaxis(2))    , ///                                   
xlabel(#16, labsize(vsmall) angle(vertical)) title("Tasas de crecimiento del empleo") subtitle("Por nivel educativo. 13 Áreas. (2011m1-2014m10)")      ///
ylabel(#10, labsize(vsmall) angle(hor)) ylabel(#10, labsize(vsmall) angle(hor) axis(2))  graphregion(fcolor(white)) legend(on hole(2) region(lcolor(white))) ///
ytitle("Con educación superior", size(vsmall) axis(1)) ytitle("Sin educación superior", size(vsmall) axis(2)) xtitle("Trimestre móvil", size(vsmall))
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\OcupaSuperior.png", width(800) height(600) replace


* * * * * * * * * * * *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
local EDU "Formales_Superior_t12 Formales_NoSuperior_t12 Informales_Superior_t12 Informales_NoSuperior_t12 "

foreach e of local EDU {
tostring `e',gen(`e'LABEL) force format(%03.2f)
replace  `e'LABEL="" if periodo<ym(2014, 10)
replace  `e'LABEL=substr(`e'LABEL,1,3)
egen     `e'LABELP=concat(`e'LABEL percentage) if `e'LABEL!=""
  }
  *
la var Formales_t12 "Empleados Formales"
la var Formales_Superior_t12 "Formales con Educación Superior"
la var Formales_NoSuperior_t12 "Formales sin Educación Superior"
la var Informales "Empleados Informales"
la var Informales_Superior_t12 "Informales con Educación Superior"
la var Informales_NoSuperior_t12 "Informales sin Educación Superior"

format Formales_t12 Formales_Superior_t12 Formales_NoSuperior_t12 Informales_t12 Informales_Superior_t12 Informales_NoSuperior_t12 %10.0f

*Tasa de crecimiento anual del Empleo Formal por Nivel Educativo
twoway (connected Formales_t12            periodo if periodo>=ym(2011, 1), msymbol(none) mlabel(Formales_t12LABELP)            mlabposition(3) mlabgap(*2)  mlabcolor(midblue) mlabsize(vsmall)  sort lcolor(midblue) lpattern(dot)    lwidth(thick) )    ///
       (connected Formales_Superior_t12   periodo if periodo>=ym(2011, 1), msymbol(none) mlabel(Formales_Superior_t12LABELP)   mlabposition(3) mlabgap(*2)  mlabcolor(black)   mlabsize(vsmall)   sort lcolor(black)   lpattern(dash)    lwidth(thick))   ///
       (connected Formales_NoSuperior_t12 periodo if periodo>=ym(2011, 1), msymbol(none) mlabel(Formales_NoSuperior_t12LABELP) mlabposition(3)  mlabgap(*2)  mlabcolor(gray)    mlabsize(vsmall)   sort lcolor(gray)    lpattern(solid)   lwidth(thick))    , ///     
xlabel(#17, labsize(vsmall) angle(vertical)) title("Tasas de crecimiento anual del empleo formal") subtitle("Por nivel educativo. 13 Áreas. (2011m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) legend(on hole(4) region(lcolor(white)) label(1 Empleo Formal) label(2 Formales con Educación Superior) label(3 Formales sin Educación Superior)) legend(order(2 1 3 )) ///
ytitle("", size(vsmall) axis(1)) xtitle("Trimestre móvil", size(vsmall)) yline(0 , lcolor(black))
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\EmpleoFormalEducat.png", width(800) height(600) replace

* * * * * * * * * * * *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*Tasa de crecimiento anual del Empleo Informal por Nivel Educativo
twoway (connected Informales_t12              periodo if periodo>=ym(2011, 1),  msymbol(none) mlabel(Informales_t12LABELP)            mlabposition(4)  mlabgap(*2)  mlabcolor(midblue) mlabsize(vsmall)  sort lcolor(midblue) lpattern(dot)    lwidth(thick) )    ///
       (connected Informales_Superior_t12     periodo if periodo>=ym(2011, 1),  msymbol(none) mlabel(Informales_Superior_t12LABELP)   mlabposition(5)  mlabgap(*2)  mlabcolor(black)   mlabsize(vsmall)   sort lcolor(black)   lpattern(dash)    lwidth(thick))   ///
       (connected Informales_NoSuperior_t12   periodo if periodo>=ym(2011, 1),  msymbol(none) mlabel(Informales_NoSuperior_t12LABELP) mlabposition(3)  mlabgap(*2)  mlabcolor(gray)    mlabsize(vsmall)   sort lcolor(gray)    lpattern(solid)   lwidth(thick))    , ///                  
xlabel(#16, labsize(vsmall) angle(vertical)) title("Tasas de crecimiento anual del empleo informal") subtitle("Por nivel educativo. 13 Áreas. (2011m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) legend(on hole(4) region(lcolor(white)) label(1 Empleo Informal) label(2 Informales con Educación Superior) label(3 Informales sin Educación Superior)) legend(order(2 1 3 )) ///
ytitle("", size(vsmall) axis(1)) xtitle("Trimestre móvil", size(vsmall)) yline(0 , lcolor(black))
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\EmpleoInformalEducat.png", width(800) height(600) replace

* * * * * * * * * * * *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*Tasa de crecimiento anual del Empleo Informal y Formal por Nivel Educativo
twoway (connected Formales_Superior_t12     periodo if periodo>=ym(2011, 1),    msymbol(none) mlabel(Formales_Superior_t12LABELP)     mlabposition(5)  mlabgap(*2)  mlabcolor(midblue) mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)    lwidth(thick))   ///
       (connected Informales_Superior_t12   periodo if periodo>=ym(2011, 1),    msymbol(none) mlabel(Informales_Superior_t12LABELP)   mlabposition(3)  mlabgap(*2)  mlabcolor(black)   mlabsize(vsmall)   sort lcolor(black)   lpattern(longdash) lwidth(thick))   ///
       (connected Informales_NoSuperior_t12 periodo if periodo>=ym(2011, 1),    msymbol(none) mlabel(Informales_NoSuperior_t12LABELP) mlabposition(3)  mlabgap(*2)  mlabcolor(gray)    mlabsize(vsmall)   sort lcolor(gray)    lpattern(solid)    lwidth(thick))   ///                  
	   (connected Formales_NoSuperior_t12 periodo   if periodo>=ym(2011, 1),    msymbol(none) mlabel(Formales_NoSuperior_t12LABELP)   mlabposition(3)  mlabgap(*2)  mlabcolor(orange)  mlabsize(vsmall)   sort lcolor(orange)  lpattern(dot)      lwidth(thick))  , ///                  
xlabel(#16, labsize(vsmall) angle(vertical)) title("Tasas de crecimiento anual del empleo formal e informal") subtitle("Por nivel educativo. 13 Áreas. (2011m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) legend(on hole(4) region(lcolor(white)) label(1 Formales Superior) label(2 Informales Superior) label(3 Informales Sin Superior) label(4 Formales Sin Superior)) legend(order(2 1 3 4)) ///
ytitle("", size(vsmall) axis(1)) xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\EInformalFormalEducat.png", width(800) height(600) replace

*Tasa de crecimiento anual del Empleo Informal y Formal por Nivel Educativo (Toda la serie)
twoway (connected Formales_Superior_t12     periodo if periodo>=ym(2008, 1),    msymbol(none) mlabel(Formales_Superior_t12LABELP)     mlabposition(3)  mlabgap(*2)  mlabcolor(midblue) mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)    lwidth(thick))   ///
       (connected Informales_Superior_t12   periodo if periodo>=ym(2008, 1),    msymbol(none) mlabel(Informales_Superior_t12LABELP)   mlabposition(3)  mlabgap(*2)  mlabcolor(black)   mlabsize(vsmall)   sort lcolor(black)   lpattern(longdash) lwidth(thick))   ///
       (connected Informales_NoSuperior_t12 periodo if periodo>=ym(2008, 1),    msymbol(none) mlabel(Informales_NoSuperior_t12LABELP) mlabposition(2)  mlabgap(*2)  mlabcolor(gray)    mlabsize(vsmall)   sort lcolor(gray)    lpattern(solid)    lwidth(thick))   ///                  
	   (connected Formales_NoSuperior_t12 periodo   if periodo>=ym(2008, 1),    msymbol(none) mlabel(Formales_NoSuperior_t12LABELP)   mlabposition(2)  mlabgap(*2)  mlabcolor(orange)  mlabsize(vsmall)   sort lcolor(orange)  lpattern(dot)      lwidth(thick))  , ///                  
xlabel(#15, labsize(vsmall) angle(vertical)) title("Tasas de crecimiento anual del empleo formal e informal") subtitle("Por nivel educativo. 13 Áreas. (2008m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) legend(on hole(4) region(lcolor(white)) label(1 Formales Superior) label(2 Informales Superior) label(3 Informales Sin Superior) label(4 Formales Sin Superior)) legend(order(2 1 3 4)) ///
ytitle("Variación porcentual", size(vsmall) axis(1)) xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\EInformalFormalEducat2.png", width(800) height(600) replace

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

* * * * * * * * * * * * * * * * * * *  * * * A C T I V I D A D E S * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
* * * * * FORMALES E INFORMALES * * * * *

local ACT "Industria_t12  Construccion_t12 ComercioHR_t12 Transporte_t12 Finanzas_t12 Inmobiliario_t12 Servicios_t12"

foreach e of local ACT {
tostring `e',gen(`e'LABEL) force format(%03.2f)
replace  `e'LABEL="" if periodo<ym(2014, 11)
replace  `e'LABEL=substr(`e'LABEL,1,4)
egen     `e'LABELP=concat(`e'LABEL percentage) if `e'LABEL!=""
  }
local ACT2 "Formales_Otras_t12"

foreach e of local ACT2 {
tostring `e',gen(`e'LABEL) force format(%03.2f)
replace  `e'LABEL="" if periodo<ym(2014, 10)
replace  `e'LABEL=substr(`e'LABEL,1,5)
egen     `e'LABELP=concat(`e'LABEL percentage) if `e'LABEL!=""
  }
local ACT3 "Formales_Industria_t12 Informales_Industria_t12 Formales_Constru_t12 Informales_Constru_t12 Formales_Comercio_t12 Informales_Comercio_t12 Formales_Transp_t12 Informales_Transp_t12 Formales_Finanzas_t12 Informales_Finanzas_t12 Formales_Inmob_t12 Informales_Inmob_t12 Formales_Servicios_t12 Informales_Servicios_t12 Informales_Otras_t12"

foreach e of local ACT3 {
tostring `e',gen(`e'LABEL) force format(%03.2f)
replace  `e'LABEL="" if periodo<ym(2014, 10)
replace  `e'LABEL=substr(`e'LABEL,1,4)
egen     `e'LABELP=concat(`e'LABEL percentage) if `e'LABEL!=""
  }
 * 
*Industria: Formales e Informales en tasas de crecimiento
la var Industria_t12            "Crecimiento Industria" 
la var Formales_Industria_t12   "Formales Industria"
la var Informales_Industria_t12 "Informales Industria"
format Industria_t12 Formales_Industria_t12 Informales_Industria_t12 Construccion_t12 Formales_Constru_t12 Informales_Constru_t12 ComercioHR_t12 Formales_Comercio_t12 Informales_Comercio_t12 Transporte_t12 Formales_Transp_t12 Informales_Transp_t12 Finanzas_t12 Formales_Finanzas_t12 Informales_Finanzas_t12 Inmobiliario_t12 Formales_Inmob_t12 Informales_Inmob_t12 Servicios_t12 Formales_Servicios_t12 Informales_Servicios_t12 Formales_Otras_t12 Informales_Otras_t12 %10.0f

twoway (connected Industria_t12            periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Industria_t12LABELP)            mlabposition(3)  mlabgap(*2)  mlabcolor(midblue) mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)    lwidth(thick))   ///
       (connected Formales_Industria_t12   periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Formales_Industria_t12LABELP)   mlabposition(3)  mlabgap(*2)  mlabcolor(black)   mlabsize(vsmall)   sort lcolor(black)   lpattern(longdash) lwidth(thick))   ///
       (connected Informales_Industria_t12 periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Informales_Industria_t12LABELP) mlabposition(3)  mlabgap(*2)  mlabcolor(gray)    mlabsize(vsmall)   sort lcolor(gray)    lpattern(solid)    lwidth(thick)) , ///                   
xlabel(#15, labsize(vsmall) angle(vertical)) title("Tasas de crecimiento anual empleo formal e informal") subtitle("Industria manufacturera. 13 Áreas. (2008m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) legend(on hole(4) region(lcolor(white))) ///
ytitle("Variación porcentual", size(vsmall) axis(1)) yline(0, lcolor(black)) xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Industria.png", width(800) height(600) replace

*Construcción: Formales e Informales en tasas de crecimiento
la var Construccion_t12       "Crecimiento Construcción"
la var Formales_Constru_t12   "Formales Construcción"
la var Informales_Constru_t12 "Informales Construcción"

twoway (connected Construccion_t12          periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Construccion_t12LABELP)       mlabposition(3)  mlabgap(*2)  mlabcolor(midblue) mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)    lwidth(thick))   ///
       (connected Formales_Constru_t12      periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Formales_Constru_t12LABELP)   mlabposition(4)  mlabgap(*2)  mlabcolor(black)   mlabsize(vsmall)   sort lcolor(black)   lpattern(longdash) lwidth(thick))   ///
       (connected Informales_Constru_t12    periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Informales_Constru_t12LABELP) mlabposition(3)  mlabgap(*2)  mlabcolor(gray)    mlabsize(vsmall)   sort lcolor(gray)    lpattern(solid)    lwidth(thick)) , ///                             
xlabel(#15, labsize(vsmall) angle(vertical)) title("Tasas de crecimiento anual empleo formal e informal") subtitle("Construcción. 13 Áreas. (2008m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) legend(on hole(4) region(lcolor(white))) ///
ytitle("Variación porcentual", size(vsmall) axis(1)) yline(0, lcolor(black)) xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Construccion.png", width(800) height(600) replace

*Comercio: Formales e Informales en tasas de crecimiento
la var ComercioHR_t12          "Crecimiento Comercio"
la var Formales_Comercio_t12   "Formales Comercio"
la var Informales_Comercio_t12 "Informales Comercio"

twoway (connected ComercioHR_t12               periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(ComercioHR_t12LABELP)       mlabposition(3)  mlabgap(*2)  mlabcolor(midblue) mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)    lwidth(thick))   ///
       (connected Formales_Comercio_t12        periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Formales_Comercio_t12LABELP)   mlabposition(3)  mlabgap(*2)  mlabcolor(black)   mlabsize(vsmall)   sort lcolor(black)   lpattern(longdash) lwidth(thick))   ///
       (connected Informales_Comercio_t12      periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Informales_Comercio_t12LABELP) mlabposition(4)  mlabgap(*2)  mlabcolor(gray)    mlabsize(vsmall)   sort lcolor(gray)    lpattern(solid)    lwidth(thick)) , ///              
xlabel(#15, labsize(vsmall) angle(vertical)) title("Tasas de crecimiento anual empleo formal e informal") subtitle("Comercio, hoteles y restaurantes. 13 Áreas. (2008m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) legend(on hole(4) region(lcolor(white))) ///
ytitle("Variación porcentual", size(vsmall) axis(1)) yline(0, lcolor(black)) xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Comercio.png", width(800) height(600) replace

*Transporte: Formales e Informales en tasas de crecimiento
la var Transporte_t12        "Crecimiento Transporte"
la var Formales_Transp_t12   "Formales Transporte"
la var Informales_Transp_t12 "Informales Transporte"

twoway (connected Transporte_t12             periodo if periodo>=ym(2008, 1), msymbol(none) mlabel(Transporte_t12LABELP)        mlabposition(3)  mlabgap(*2)  mlabcolor(midblue) mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)    lwidth(thick))   ///
       (connected Formales_Transp_t12        periodo if periodo>=ym(2008, 1), msymbol(none) mlabel(Formales_Transp_t12LABELP)   mlabposition(3)  mlabgap(*2)  mlabcolor(black)   mlabsize(vsmall)   sort lcolor(black)   lpattern(longdash) lwidth(thick))   ///
       (connected Informales_Transp_t12      periodo if periodo>=ym(2008, 1), msymbol(none) mlabel(Informales_Transp_t12LABELP) mlabposition(3)  mlabgap(*2)  mlabcolor(gray)    mlabsize(vsmall)   sort lcolor(gray)    lpattern(solid)    lwidth(thick)) , ///                
xlabel(#15, labsize(vsmall) angle(vertical)) title("Tasas de crecimiento anual empleo formal e informal") subtitle("Transporte, almacenamiento y comunicaciones. 13 Áreas. (2008m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) legend(on hole(4) region(lcolor(white))) ///
ytitle("Variación porcentual", size(vsmall) axis(1)) yline(0, lcolor(black)) xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Transporte.png", width(800) height(600) replace

*Finanzas: Formales e Informales en tasas de crecimiento
la var Finanzas_t12            "Crecimiento Finanzas"
la var Formales_Finanzas_t12   "Formales Finanzas"
la var Informales_Finanzas_t12 "Informales Finanzas"

twoway (connected Finanzas_t12               periodo if periodo>=ym(2008, 1), msymbol(none) mlabel(Finanzas_t12LABELP)            mlabposition(5)  mlabgap(*2)  mlabcolor(midblue) mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)    lwidth(thick))   ///
       (connected Formales_Finanzas_t12      periodo if periodo>=ym(2008, 1), msymbol(none) mlabel(Formales_Finanzas_t12LABELP)   mlabposition(4)  mlabgap(*2)  mlabcolor(black)   mlabsize(vsmall)   sort lcolor(black)   lpattern(longdash) lwidth(thick))   ///
       (connected Informales_Finanzas_t12    periodo if periodo>=ym(2008, 1), msymbol(none) mlabel(Informales_Finanzas_t12LABELP) mlabposition(5)  mlabgap(*2)  mlabcolor(gray)    mlabsize(vsmall)   sort lcolor(gray)    lpattern(solid)    lwidth(thick)) , ///                 
xlabel(#15, labsize(vsmall) angle(vertical)) title("Tasas de crecimiento anual empleo formal e informal") subtitle("Intermediación financiera. 13 Áreas. (2008m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) legend(on hole(4) region(lcolor(white))) ///
ytitle("Variación porcentual", size(vsmall) axis(1)) yline(0, lcolor(black)) xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Finanzas.png", width(800) height(600) replace

*Inmobiliario: Formales e Informales en tasas de crecimiento
la var Inmobiliario_t12      "Crecimiento Inmobiliarias"
la var Formales_Inmob_t12    "Formales Inmobiliarias"
la var Informales_Inmob_t12  "Informales Inmobiliarias"

twoway (connected Inmobiliario_t12     periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Inmobiliario_t12LABELP)     mlabposition(4)  mlabgap(*2)  mlabcolor(midblue) mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)    lwidth(thick))   ///
       (connected Formales_Inmob_t12   periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Formales_Inmob_t12LABELP)   mlabposition(2)  mlabgap(*2)  mlabcolor(black)   mlabsize(vsmall)   sort lcolor(black)   lpattern(longdash) lwidth(thick))   ///
       (connected Informales_Inmob_t12 periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Informales_Inmob_t12LABELP) mlabposition(3)  mlabgap(*2)  mlabcolor(gray)    mlabsize(vsmall)   sort lcolor(gray)    lpattern(solid)    lwidth(thick)) , ///                                  
xlabel(#15, labsize(vsmall) angle(vertical)) title("Tasas de crecimiento anual empleo formal e informal") subtitle("Actividades inmobiliarias, empresariales y de alquiler. 13 Áreas. (2008m1-2014m11)" , size(small))      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) legend(on  region(lcolor(white))) ///
ytitle("Variación porcentual", size(vsmall) axis(1)) yline(0, lcolor(black)) xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Inmobiliario.png", width(800) height(600) replace

*Servicios: Formales e Informales en tasas de crecimiento
la var Servicios_t12            "Crecimiento Servicios"
la var Formales_Servicios_t12   "Formales Servicios"
la var Informales_Servicios_t12 "Informales Servicios"

twoway (connected Servicios_t12            periodo if periodo>=ym(2008, 1),   msymbol(none) mlabel(Servicios_t12LABELP)            mlabposition(4)  mlabgap(*2)  mlabcolor(midblue) mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)    lwidth(thick))   ///
       (connected Formales_Servicios_t12   periodo if periodo>=ym(2008, 1),   msymbol(none) mlabel(Formales_Servicios_t12LABELP)   mlabposition(4)  mlabgap(*2)  mlabcolor(black)   mlabsize(vsmall)   sort lcolor(black)   lpattern(longdash) lwidth(thick))   ///
       (connected Informales_Servicios_t12 periodo if periodo>=ym(2008, 1),   msymbol(none) mlabel(Informales_Servicios_t12LABELP) mlabposition(3)  mlabgap(*2)  mlabcolor(gray)    mlabsize(vsmall)   sort lcolor(gray)    lpattern(solid)    lwidth(thick)) , ///              
xlabel(#15, labsize(vsmall) angle(vertical)) title("Tasas de crecimiento anual empleo formal e informal") subtitle("Servicios comunales, sociales y personales. 13 Áreas. (2008m1-2014m11)" , size(small))      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) legend(on  region(lcolor(white))) ///
ytitle("Variación porcentual", size(vsmall) axis(1)) yline(0, lcolor(black)) xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Servicios.png", width(800) height(600) replace

*Otras: Formales e Informales en tasas de crecimiento
la var Formales_Otras_t12   "Formales Otras"
la var Informales_Otras_t12 "Informales Otras"

twoway (connected Formales_Otras_t12         periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Formales_Otras_t12LABELP)            mlabposition(3)  mlabgap(*2)  mlabcolor(midblue) mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)    lwidth(thick))   ///
       (connected Informales_Otras_t12       periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Informales_Otras_t12LABELP) mlabposition(3)  mlabgap(*2)  mlabcolor(gray)    mlabsize(vsmall)   sort lcolor(gray)    lpattern(solid)    lwidth(thick)) , ///        
xlabel(#15, labsize(vsmall) angle(vertical)) title("Tasas de crecimiento anual empleo formal e informal") subtitle("Otras Actividades (Agricultura,Minas,Electricidad). 13 Áreas. (2008m1-2014m11)" , size(small))      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) legend(on  region(lcolor(white))) ///
ytitle("Variación porcentual", size(vsmall) axis(1)) yline(0, lcolor(black)) xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\OtrasActividades.png", width(800) height(600) replace

                     
* * * * * * * * * * * * * * * * * * *  * * * A C T I V I D A D E S * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

* * * * * FORMALES E INFORMALES * * * * *
*Actividades sobre la PET
gen    Industria_PET=100*(Industria/PET)
gen    Construccion_PET=100*(Construccion/PET)
gen    ComercioHR_PET=100*(ComercioHR/PET)
gen    Transporte_PET=100*(Transporte/PET)
gen    Finanzas_PET=100*(Finanzas/PET)
gen    Inmobiliario_PET=100*(Inmobiliario/PET)
gen    Servicios_PET=100*(Servicios/PET)
gen    OtraActividad_PET=100*(OtraActividad/PET) 

*Etiquetas de datos
local ACT2 "OtraActividad_t12 Industria_PET Industria Construccion_PET  ComercioHR_PET ComercioHR Transporte_PET  Finanzas_PET Inmobiliario_PET Inmobiliario Servicios_PET Servicios OtraActividad_PET OtraActividad"

foreach e of local ACT2 {
tostring `e',gen(`e'LABEL) force format(%03.2f)
replace  `e'LABEL="" if periodo<ym(2014, 11)
replace  `e'LABEL=substr(`e'LABEL,1,4)
egen     `e'LABELP=concat(`e'LABEL percentage) if `e'LABEL!=""
  }
  *
local ACT3 "Construccion Transporte Finanzas"

foreach e of local ACT3 {
tostring `e',gen(`e'LABEL) force format(%03.2f)
replace  `e'LABEL="" if periodo<ym(2014, 11)
replace  `e'LABEL=substr(`e'LABEL,1,3)
egen     `e'LABELP=concat(`e'LABEL percentage) if `e'LABEL!=""
  }
  *
format  Industria  Construccion ComercioHR_PET ComercioHR Transporte_PET Transporte Finanzas_PET Finanzas Inmobiliario Servicios OtraActividad_PET OtraActividad %10.0f
format Industria_PET Construccion_PET Transporte_PET Finanzas_PET Inmobiliario_PET Servicios_PET %10.1f

*Actividades sobre la PET, Formales

*Industria: 
la var  Industria_PET "Tasa de Ocupación (% PET)"
la var  Industria "Miles de Empleos"

twoway (bar  Industria          periodo if periodo>=ym(2008, 1),                                                                                                               sort lcolor(gray)    lpattern(dot)    lwidth(thick) )    ///
       (sc   Industria          periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(IndustriaLABEL)      mlabposition(12)  mlabgap(*2)   mlabcolor(gray)     mlabsize(vsmall)) ///
       (connected Industria_PET periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Industria_PETLABELP) mlabposition(3)   /*mlabgap(*2)*/   mlabcolor(midblue)  mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)   lwidth(thick) yaxis(2))  , ///            
xlabel(#15, labsize(vsmall) angle(vertical)) title("Empleo y tasa de ocupación como porcentaje PET") subtitle("Industria manufacturera. 13 Áreas. (2008m1-2014m11)" )      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on region(lcolor(white)) label(1 Empleo en Industria) label(2 ) label(3 Tasa de Ocupación (% PET)) ) legend(order(1 3)) ///
ytitle("Miles de empleos", size(vsmall) axis(1)) ytitle("Variación porcentual", size(vsmall) axis(2))  xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Tasa de Ocupación por Actividad\Industria.png", width(800) height(600) replace

*Construcción: 
la var  Construccion_PET "Tasa de Ocupación (% PET)"
la var  Construccion "Miles de Empleos"

twoway (bar  Construccion          periodo if periodo>=ym(2008, 1),                                                                                                               sort lcolor(gray)    lpattern(dot)    lwidth(thick) )    ///
       (sc   Construccion          periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(ConstruccionLABEL)      mlabposition(12)  mlabgap(*2)   mlabcolor(gray)     mlabsize(vsmall)) ///
       (connected Construccion_PET periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Construccion_PETLABELP) mlabposition(2)   /*mlabgap(*2)*/   mlabcolor(midblue)  mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)   lwidth(thick) yaxis(2))  , ///            
xlabel(#15, labsize(vsmall) angle(vertical)) title("Empleo y tasa de ocupación como porcentaje PET") subtitle("Construcción. 13 Áreas. (2008m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on region(lcolor(white)) label(1 Empleo en Construcción) label(2 ) label(3 Tasa de Ocupación (% PET)) ) legend(order(1 3)) ///
ytitle("Miles de empleos", size(vsmall) axis(1)) ytitle("Variación porcentual", size(vsmall) axis(2))  xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Tasa de Ocupación por Actividad\Construccion.png", width(800) height(600) replace

*Comercio: 
la var  ComercioHR_PET "Tasa de Ocupación (% PET)"
la var  ComercioHR "Miles de Empleos"

twoway (bar  ComercioHR            periodo if periodo>=ym(2008, 1),                                                                                                                     sort lcolor(gray)    lpattern(dot)    lwidth(thick) )    ///
       (sc   ComercioHR            periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(ComercioHRLABEL)      mlabposition(12)  mlabgap(*2)      mlabcolor(gray)     mlabsize(vsmall)) ///
       (connected Construccion_PET periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(ComercioHR_PETLABELP) mlabposition(1)   /*mlabgap(*2)*/  mlabcolor(midblue)  mlabsize(vsmall) sort lcolor(midblue) lpattern(solid)   lwidth(thick) yaxis(2))  , ///            
xlabel(#15, labsize(vsmall) angle(vertical)) title("Empleo y tasa de ocupación como porcentaje PET") subtitle("Comercio, hoteles y restaurantes. 13 Áreas. (2008m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on region(lcolor(white)) label(1 Empleo en Comercio) label(2 ) label(3 Tasa de Ocupación (% PET)) ) legend(order(1    3)) ///
ytitle("Miles de empleos", size(vsmall) axis(1)) ytitle("Variación porcentual", size(vsmall) axis(2))  xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Tasa de Ocupación por Actividad\Comercio.png", width(800) height(600) replace

*Transporte: 
la var  Transporte_PET "Tasa de Ocupación (% PET)"
la var  Transporte "Miles de Empleos"

twoway (bar  Transporte             periodo if periodo>=ym(2008, 1),                                                                                                                     sort lcolor(gray)    lpattern(dot)    lwidth(thick) )    ///
       (sc   Transporte             periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(TransporteLABEL)      mlabposition(12)  mlabgap(*2)      mlabcolor(gray)     mlabsize(vsmall)) ///
       (connected Transporte_PET    periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Transporte_PETLABELP) mlabposition(3)   /*mlabgap(*2)*/  mlabcolor(midblue)  mlabsize(vsmall) sort lcolor(midblue) lpattern(solid)   lwidth(thick) yaxis(2))  , ///            
xlabel(#15, labsize(vsmall) angle(vertical)) title("Empleo y tasa de ocupación como porcentaje PET") subtitle("Transporte, almacenamiento y comunicaciones. 13 Áreas. (2008m1-2014m11)" , size(small))      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on region(lcolor(white)) label(1 Empleo en Transporte) label(2 ) label(3 Tasa de Ocupación (% PET)) ) legend(order(1    3)) ///
ytitle("Miles de empleos", size(vsmall) axis(1)) ytitle("Variación porcentual", size(vsmall) axis(2))  xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Tasa de Ocupación por Actividad\Transporte.png", width(800) height(600) replace

*Finanzas: 
la var  Finanzas_PET "Tasa de Ocupación (% PET)"
la var  Finanzas "Miles de Empleos"

twoway (bar  Finanzas             periodo if periodo>=ym(2008, 1),                                                                                                                     sort lcolor(gray)    lpattern(dot)    lwidth(thick) )    ///
       (sc   Finanzas             periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(FinanzasLABEL)      mlabposition(1)  mlabgap(*3)      mlabcolor(gray)     mlabsize(vsmall)) ///
       (connected Finanzas_PET    periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Finanzas_PETLABELP) mlabposition(3)   /*mlabgap(*2)*/  mlabcolor(midblue)  mlabsize(vsmall) sort lcolor(midblue) lpattern(solid)   lwidth(thick) yaxis(2))  , ///            
xlabel(#15, labsize(vsmall) angle(vertical)) title("Empleo y tasa de ocupación como porcentaje PET") subtitle("Intermediación Financiera. 13 Áreas. (2008m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on region(lcolor(white)) label(1 Empleo en Finanzas) label(2 ) label(3 Tasa de Ocupación (% PET)) ) legend(order(1    3)) ///
ytitle("Miles de empleos", size(vsmall) axis(1)) ytitle("Variación porcentual", size(vsmall) axis(2))  xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Tasa de Ocupación por Actividad\Finanzas.png", width(800) height(600) replace

*Inmobiliario: 
la var  Inmobiliario_PET "Tasa de Ocupación (% PET)"
la var  Inmobiliario "Miles de Empleos"

twoway (bar  Inmobiliario             periodo if periodo>=ym(2008, 1),                                                                                                                     sort lcolor(gray)    lpattern(dot)    lwidth(thick) )    ///
       (sc   Inmobiliario             periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(InmobiliarioLABEL)      mlabposition(12)  mlabgap(*2)      mlabcolor(gray)     mlabsize(vsmall)) ///
       (connected Inmobiliario_PET    periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Inmobiliario_PETLABELP) mlabposition(4)   /*mlabgap(*2)*/  mlabcolor(midblue)  mlabsize(vsmall) sort lcolor(midblue) lpattern(solid)   lwidth(thick) yaxis(2))  , ///            
xlabel(#15, labsize(vsmall) angle(vertical)) title("Empleo y tasa de ocupación como porcentaje PET") subtitle("Actividades inmobiliarias, empresariales y de alquiler. 13 Áreas. (2008m1-2014m11)" , size(small))      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on region(lcolor(white)) label(1 Empleo en Inmobiliario) label(2 ) label(3 Tasa de Ocupación (% PET)) ) legend(order(1    3)) ///
ytitle("Miles de empleos", size(vsmall) axis(1)) ytitle("Variación porcentual", size(vsmall) axis(2))  xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Tasa de Ocupación por Actividad\Inmobiliario.png", width(800) height(600) replace

*Servicios: 
la var  Servicios_PET "Tasa de Ocupación (% PET)"
la var  Servicios "Miles de Empleos"

twoway (bar  Servicios             periodo if periodo>=ym(2008, 1),                                                                                                                     sort lcolor(gray)    lpattern(dot)    lwidth(thick) )    ///
       (sc   Servicios             periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(ServiciosLABEL)      mlabposition(1)  mlabgap(*2)      mlabcolor(gray)     mlabsize(vsmall)) ///
       (connected Servicios_PET    periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Servicios_PETLABELP) mlabposition(5)   /*mlabgap(*2)*/  mlabcolor(midblue)  mlabsize(vsmall) sort lcolor(midblue) lpattern(solid)   lwidth(thick) yaxis(2))  , ///            
xlabel(#15, labsize(vsmall) angle(vertical)) title("Empleo y tasa de ocupación como porcentaje PET") subtitle("Servicios comunales, sociales y personales. 13 Áreas. (2008m1-2014m11)" , size(small))      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on region(lcolor(white)) label(1 Empleo en Servicios) label(2 ) label(3 Tasa de Ocupación (% PET)) ) legend(order(1    3)) ///
ytitle("Miles de empleos", size(vsmall) axis(1)) ytitle("Variación porcentual", size(vsmall) axis(2))  xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Tasa de Ocupación por Actividad\Servicios.png", width(800) height(600) replace

*Otras: 
la var  OtraActividad_PET "Tasa de Ocupación (% PET)"
la var  OtraActividad "Miles de Empleos"

twoway (bar  OtraActividad       periodo if periodo>=ym(2008, 1),                                                                                                                     sort lcolor(gray)    lpattern(dot)    lwidth(thick) )    ///
       (sc   OtraActividad       periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(OtraActividadLABEL)      mlabposition(1)  mlabgap(*2)      mlabcolor(gray)     mlabsize(vsmall)) ///
       (connected Servicios_PET  periodo if periodo>=ym(2008, 1),  msymbol(none) mlabel(Servicios_PETLABELP) mlabposition(5)   /*mlabgap(*2)*/  mlabcolor(midblue)  mlabsize(vsmall) sort lcolor(midblue) lpattern(solid)   lwidth(thick) yaxis(2))  , ///            
xlabel(#15, labsize(vsmall) angle(vertical)) title("Empleo y tasa de ocupación como porcentaje PET") subtitle("Otras Actividades (Agricultura,Minas,Electricidad). 13 Áreas. (2008m1-2014m11)" , size(small))      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on region(lcolor(white)) label(1 Empleo en Otras Actividades) label(2 ) label(3 Tasa de Ocupación (% PET)) ) legend(order(1    3)) ///
ytitle("Miles de empleos", size(vsmall) axis(1)) ytitle("Variación porcentual", size(vsmall) axis(2))  xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Tasa de Ocupación por Actividad\OtraActividad.png", width(800) height(600) replace

* * * Nuevas * * *
format Industria Industria_t12 Construccion Construccion_t12 ComercioHR ComercioHR_t12 Transporte Transporte_t12 Finanzas Finanzas_t12 Inmobiliario Inmobiliario_t12 Servicios Servicios_t12 OtraActividad OtraActividad_t12 %10.0f

*Industria: 
la var  Industria_t12 "Tasa de Crecimiento Anual"
la var  Industria "Empleos Industria"

twoway (bar  Industria          periodo if periodo>=ym(2007, 1),                                                                                                               sort lcolor(gray)    lpattern(dot)    lwidth(thick) )    ///
       (sc   Industria          periodo if periodo>=ym(2007, 1),  msymbol(none) mlabel(IndustriaLABEL)      mlabposition(12)  mlabgap(*2)   mlabcolor(gray)     mlabsize(vsmall)) ///
       (connected Industria_t12 periodo if periodo>=ym(2007, 1),  msymbol(none) mlabel(Industria_t12LABELP) mlabposition(4)   mlabgap(*2)   mlabcolor(midblue)  mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)   lwidth(thick) yaxis(2))  , ///            
xlabel(#15, labsize(vsmall) angle(vertical)) title("Empleo y tasa de crecimiento anual del empleo") subtitle("Industria manufacturera. 13 Áreas. (2007m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on region(lcolor(white)) label(1 Empleo en Industria) label(2 ) label(3 Tasa de Crecimiento)) legend(order(1 3)) ///
ytitle("Miles de empleos", size(vsmall) axis(1)) ytitle("Variación porcentual", size(vsmall) axis(2))  xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Actividades en nivel y tasa de crecimiento\Industria.png", width(800) height(600) replace

*Construcción: 
la var  Construccion_t12 "Tasa de Crecimiento Anual (%)"
la var  Construccion "Miles de Empleos"

twoway (bar  Construccion          periodo if periodo>=ym(2007, 1),                                                                                                               sort lcolor(gray)    lpattern(dot)    lwidth(thick) )    ///
       (sc   Construccion          periodo if periodo>=ym(2007, 1),  msymbol(none) mlabel(ConstruccionLABEL)      mlabposition(12)  mlabgap(*4)   mlabcolor(gray)     mlabsize(vsmall)) ///
       (connected Construccion_t12 periodo if periodo>=ym(2007, 1),  msymbol(none) mlabel(Construccion_t12LABELP) mlabposition(4)   /*mlabgap(*2)*/   mlabcolor(midblue)  mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)   lwidth(thick) yaxis(2))  , ///            
xlabel(#17, labsize(vsmall) angle(vertical)) title("Empleo y tasa de crecimiento anual del empleo") subtitle("Construcción. 13 Áreas. (2007m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on region(lcolor(white)) label(1 Empleo en Construcción) label(2 ) label(3 Tasa de Crecimiento)) legend(order(1 3)) ///
ytitle("Miles de empleos", size(vsmall) axis(1)) ytitle("Variación porcentual", size(vsmall) axis(2))  xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Actividades en nivel y tasa de crecimiento\Construccion.png", width(800) height(600) replace

*Comercio: 
la var  ComercioHR_t12 "Tasa de Crecimiento Anual (%)"
la var  ComercioHR "Miles de Empleos"

twoway (bar  ComercioHR          periodo if periodo>=ym(2007, 1),                                                                                                               sort lcolor(gray)    lpattern(dot)    lwidth(thick) )    ///
       (sc   ComercioHR          periodo if periodo>=ym(2007, 1),  msymbol(none) mlabel(ComercioHRLABEL)      mlabposition(12)  mlabgap(*2)   mlabcolor(gray)     mlabsize(vsmall)) ///
       (connected ComercioHR_t12 periodo if periodo>=ym(2007, 1),  msymbol(none) mlabel(ComercioHR_t12LABELP) mlabposition(4)   /*mlabgap(*2)*/   mlabcolor(midblue)  mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)   lwidth(thick) yaxis(2))  , ///            
xlabel(#17, labsize(vsmall) angle(vertical)) title("Empleo y tasa de crecimiento anual del empleo") subtitle("Comercio, hoteles y restaurantes. 13 Áreas. (2007m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on region(lcolor(white)) label(1 Empleo en Comercio) label(2 ) label(3 Tasa de Crecimiento)) legend(order(1 3)) ///
ytitle("Miles de empleos", size(vsmall) axis(1)) ytitle("Variación porcentual", size(vsmall) axis(2))  xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Actividades en nivel y tasa de crecimiento\Comercio.png", width(800) height(600) replace

*Transporte: 
la var  Transporte "Miles de Empleos"
la var  Transporte_t12 "Tasa de Crecimiento Anual (%)"

twoway (bar  Transporte          periodo if periodo>=ym(2007, 1),                                                                                                               sort lcolor(gray)    lpattern(dot)    lwidth(thick) )    ///
       (sc   Transporte          periodo if periodo>=ym(2007, 1),  msymbol(none) mlabel(TransporteLABEL)      mlabposition(12)  mlabgap(*2)   mlabcolor(gray)     mlabsize(vsmall)) ///
       (connected Transporte_t12 periodo if periodo>=ym(2007, 1),  msymbol(none) mlabel(Transporte_t12LABELP) mlabposition(4)   /*mlabgap(*2)*/   mlabcolor(midblue)  mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)   lwidth(thick) yaxis(2))  , ///            
xlabel(#17, labsize(vsmall) angle(vertical)) title("Empleo y tasa de crecimiento anual del empleo") subtitle("Transporte, almacenamiento y comunicaciones. 13 Áreas. (2007m1-2014m11)" , size(small))      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on region(lcolor(white)) label(1 Empleo en Transporte) label(2 ) label(3 Tasa de Crecimiento)) legend(order(1 3)) ///
ytitle("Miles de empleos", size(vsmall) axis(1)) ytitle("Variación porcentual", size(vsmall) axis(2))  xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Actividades en nivel y tasa de crecimiento\Transporte.png", width(800) height(600) replace

*Finanzas: 
la var  Finanzas_t12 "Tasa de Crecimiento Anual (%)"
la var  Finanzas "Miles de Empleos"

twoway (bar  Finanzas          periodo if periodo>=ym(2007, 1),                                                                                                               sort lcolor(gray)    lpattern(dot)    lwidth(thick) )    ///
       (sc   Finanzas          periodo if periodo>=ym(2007, 1),  msymbol(none) mlabel(FinanzasLABEL)      mlabposition(1)  mlabgap(*2)   mlabcolor(gray)     mlabsize(vsmall)) ///
       (connected Finanzas_t12 periodo if periodo>=ym(2007, 1),  msymbol(none) mlabel(Finanzas_t12LABELP) mlabposition(4)   /*mlabgap(*2)*/   mlabcolor(midblue)  mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)   lwidth(thick) yaxis(2))  , ///            
xlabel(#17, labsize(vsmall) angle(vertical)) title("Empleo y tasa de crecimiento anual del empleo") subtitle("Intermediación financiera. 13 Áreas. (2007m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on region(lcolor(white)) label(1 Empleo en Finanzas) label(2 ) label(3 Tasa de Crecimiento)) legend(order(1 3)) ///
ytitle("Miles de empleos", size(vsmall) axis(1)) ytitle("Variación porcentual", size(vsmall) axis(2))  xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Actividades en nivel y tasa de crecimiento\Finanzas.png", width(800) height(600) replace

*Inmobiliario: 
label var Inmobiliario "Miles de Empleos"
la var Inmobiliario_t12 "Tasa de Crecimiento Anual (%)"

twoway (bar  Inmobiliario          periodo if periodo>=ym(2007, 1),                                                                                                               sort lcolor(gray)    lpattern(dot)    lwidth(thick) )    ///
       (sc   Inmobiliario          periodo if periodo>=ym(2007, 1),  msymbol(none) mlabel(InmobiliarioLABEL)      mlabposition(12)  mlabgap(*2)   mlabcolor(gray)     mlabsize(vsmall)) ///
       (connected Inmobiliario_t12 periodo if periodo>=ym(2007, 1),  msymbol(none) mlabel(Inmobiliario_t12LABELP) mlabposition(5)   /*mlabgap(*2)*/   mlabcolor(midblue)  mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)   lwidth(thick) yaxis(2))  , ///            
xlabel(#17, labsize(vsmall) angle(vertical)) title("Empleo y tasa de crecimiento anual del empleo") subtitle("Actividades inmobiliarias, empresariales y de alquiler. 13 Áreas. (2007m1-2014m11)" , size(small))      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on region(lcolor(white)) label(1 Empleo en Inmobiliario) label(2 ) label(3 Tasa de Crecimiento)) legend(order(1 3)) ///
ytitle("Miles de empleos", size(vsmall) axis(1)) ytitle("Variación porcentual", size(vsmall) axis(2))  xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Actividades en nivel y tasa de crecimiento\Inmobiliario.png", width(800) height(600) replace

*Servicios: 
label  var Servicios_t12 "Tasa de Crecimiento Anual (%)"
label var Servicios "Miles de Empleos"

twoway (bar  Servicios          periodo if periodo>=ym(2007, 1),                                                                                                               sort lcolor(gray)    lpattern(dot)    lwidth(thick) )    ///
       (sc   Servicios          periodo if periodo>=ym(2007, 1),  msymbol(none) mlabel(ServiciosLABEL)      mlabposition(12)  mlabgap(*2)   mlabcolor(gray)     mlabsize(vsmall)) ///
       (connected Servicios_t12 periodo if periodo>=ym(2007, 1),  msymbol(none) mlabel(Servicios_t12LABELP) mlabposition(4)   mlabgap(*4)   mlabcolor(midblue)  mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)   lwidth(thick) yaxis(2))  , ///            
xlabel(#17, labsize(vsmall) angle(vertical)) title("Empleo y tasa de crecimiento anual del empleo") subtitle("Servicios comunales, sociales y personales. 13 Áreas. (2007m1-2014m11)" , size(small))      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on region(lcolor(white)) label(1 Empleo en Servicios) label(2 ) label(3 Tasa de Crecimiento)) legend(order(1 3)) ///
ytitle("Miles de empleos", size(vsmall) axis(1)) ytitle("Variación porcentual", size(vsmall) axis(2))  xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Actividades en nivel y tasa de crecimiento\Servicios.png", width(800) height(600) replace

*Otras: 
la var OtraActividad_t12 "Tasa de Crecimiento Anual (%)"
la var OtraActividad "Miles de Empleos"

twoway (bar  OtraActividad          periodo if periodo>=ym(2007, 1),                                                                                                               sort lcolor(gray)    lpattern(dot)    lwidth(thick) )    ///
       (sc   OtraActividad          periodo if periodo>=ym(2007, 1),  msymbol(none) mlabel(OtraActividadLABEL)      mlabposition(12)  mlabgap(*12)   mlabcolor(gray)     mlabsize(vsmall)) ///
       (connected OtraActividad_t12 periodo if periodo>=ym(2007, 1),  msymbol(none) mlabel(OtraActividad_t12LABELP) mlabposition(4)   mlabgap(*5)   mlabcolor(midblue)  mlabsize(vsmall)   sort lcolor(midblue) lpattern(solid)   lwidth(thick) yaxis(2))  , ///            
xlabel(#15, labsize(vsmall) angle(vertical)) title("Empleo y tasa de crecimiento anual del empleo") subtitle("Otras Actividades (Agricultura,Minas,Electricidad). 13 Áreas. (2007m1-2014m11)" , size(small))      ///
ylabel(#10, labsize(vsmall) angle(hor)) graphregion(fcolor(white)) ylabel(#10, labsize(vsmall) angle(hor) axis(2)) graphregion(fcolor(white)) legend(on region(lcolor(white)) label(1 Empleo en Otras Actividades) label(2 ) label(3 Tasa de Crecimiento)) legend(order(1 3)) ///
ytitle("Miles de empleos", size(vsmall) axis(1)) ytitle("Variación porcentual", size(vsmall) axis(2))  xtitle("Trimestre móvil", size(vsmall)) 
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\Actividades Economicas\Actividades en nivel y tasa de crecimiento\OtraActividad.png", width(800) height(600) replace
  

  *Nuevas Doctor Hugo
la var Formales_t12 "Formales"
la var Informales_t12 "Informales"
format Formales Informales %10.0f
twoway (connected Formales_t12     periodo if period2>=ym(2010, 1),  msymbol(none) mlabel(Formales_t12LABELP)       mlabposition(12)               mlabcolor(midblue) mlabsize(vsmall)    sort lcolor(midblue) lpattern(dot)    lwidth(thick) )    ///
       (connected Informales_t12   periodo if period2>=ym(2010, 1),  msymbol(none) mlabel(Informales_t12LABELP) mlabposition(12)  mlabgap(*1)  mlabcolor(gray)    mlabsize(vsmall)      sort lcolor(gray)    lpattern(solid)  lwidth(thick) )    , ///                   
xlabel(#19, labsize(vsmall) angle(vertical)) title("Tasas de crecimiento anual del empleo formal e informal") subtitle("13 Áreas. (2010m1-2014m11)")      ///
ylabel(#10, labsize(vsmall) angle(horizontal))  graphregion(fcolor(white)) legend(on  region(lcolor(white)))  ///
 xtitle("Trimestre móvil", size(vsmall))
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\TasasCrecimientoEmpleoFormal-Informal.png", width(800) height(600) replace


* * * Gráfico de barras * * * 
tostring periodo,gen(per) format(%tmMonYY) force
* * * * * * * * * * * * * * * * * * * * * * * * * *
replace Formales=Formales-4000     /*Sólo una vez*/
replace Informales=Informales-4000 /*Sólo una vez*/
* * * * * * * * * * * * * * * * * * * * * * * * * * 

graph bar (asis) Formales Informales if periodo>=ym(2010,1) , over (per, lab(angle(v) labs(vsmall))/*relabel( 1 "2014m1" 2 "2014m2" 3 "2014m3" 4 "2014m4" 5 "2014m5" 6 "2014m6" 7 "2014m7" 8 "2014m9" 9 "2014m10")*/ sort(periodo))  ///
blabel(Formales, format(%10.0f) )  ///
title("Empleo formal e informal") subtitle("Miles de Empleos. 13 Áreas. (2012m1-2014m10)")      ///
ylabel(0 "4000" 500 "4500" 1000 "5000" 1500 "5500" , labsize(medium) angle(horizontal)) graphregion(fcolor(white)) legend(on region(lcolor(white)) label(1 Formales) label(2 Informales)) legend(order(1 2)) ///
note("Fuente: DANE, Encuestas de hogares; cálculos propios")
graph export "\\\MEDE1174089\DANE_Anexos\Anexos DANE\Gráficas Noviembre de 2014\Gráficas Anexos DANE 13 Áreas - Noviembre de 2014\EmpleoFormal-Informal.png", width(800) height(600) replace

replace Formales=Formales+4000     /*Sólo una vez*/
replace Informales=Informales+4000  /*Sólo una vez*/ 
