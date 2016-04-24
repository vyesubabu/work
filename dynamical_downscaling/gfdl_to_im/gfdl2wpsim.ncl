;
; developed by Wenqing Xu,Tsinghua University,Beijing
; if you have any problem, please contact 2271548435@qq.com
;

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

  print("open atmos data files ")
  in_hus   = addfile(hus_file,"r") ; 6hout
  in_ta    = addfile(ta_file,"r")  ; 6hour
  in_ua    = addfile(ua_file,"r")  ; 6hour
  in_va    = addfile(va_file,"r")  ; 6hour
  in_ps    = addfile(ps_file,"r")  ; 6hour
  in_huss  = addfile(huss_file,"r")   ; 3hour
  in_tas   = addfile(tas_file,"r")    ; 3hour
  in_uas   = addfile(uas_file,"r")    ; 3hour
  in_vas   = addfile(vas_file,"r")    ; 3hour
  
  print("open land data files ")
  in_mrlsl = addfile(mrlsl_file,"r")         ; monthly
  in_tsl   = addfile(tsl_file,"r")           ; monthly
  
  print("open surface temperature data files ")
  in_tos   = addfile(tos_file,"r")           ; daily
  in_ts = addfile(ts_file,"r")               ; monthly  

  print("open ice and snow data files ")
  in_sic   = addfile(sic_file,"r")          ; daily
  in_snw   = addfile(snw_file,"r")          ; monthly
  
  print("open invariant data files ")
  in_orog  = addfile(orog_file,"r")    ; invariant data
  in_lmask = addfile(sftlf_file,"r")   ; invariant data

  print("read variables of atmos")
  time     = in_ta->time(ntime_s_6h-1:ntime_e_6h-1)
  P0       = 1013.25    ; we can alse use P0 = in_ta->p0/100.
  lon      = in_ta->lon
  lat      = in_ta->lat
  LAT      = in_ta->lat
  lev      = in_ta->lev
  T = in_ta->ta(ntime_s_6h-1:ntime_e_6h-1,:,:,:)
  U = in_ua->ua(ntime_s_6h-1:ntime_e_6h-1,:,:,:)
  V = in_va->va(ntime_s_6h-1:ntime_e_6h-1,:,:,:)
  Q = in_hus->hus(ntime_s_6h-1:ntime_e_6h-1,:,:,:)
  TS_3h = in_tas->tas(ntime_s_3h-1:ntime_e_3h-1,:,:)
  US_3h = in_uas->uas(ntime_s_3h-1:ntime_e_3h-1,:,:)
  VS_3h = in_vas->vas(ntime_s_3h-1:ntime_e_3h-1,:,:)
  QS_3h = in_huss->huss(ntime_s_3h-1:ntime_e_3h-1,:,:)
  PS   = in_ps->ps(ntime_s_6h-1:ntime_e_6h-1,:,:)

  print("read variables of sst ")
  SST_DAY = in_tos->tos(ntime_s_day-1:ntime_e_day-1,:,:)

  print("read variables of sea ice ")
  ICE_DAY = in_sic->sic(ntime_s_day-1:ntime_e_day-1,:,:)*0.01 ; convert from % to fraction

  print("read the soil and surface data ")
  TSKIN = in_ts->ts(ntime_s_mon-1:ntime_e_mon-1,:,:)
  SNOWW = in_snw->snw(ntime_s_mon-1:ntime_e_mon-1,:,:)
  TSOIL = in_tsl->tsl(ntime_s_mon-1:ntime_e_mon-1,:,:,:)
  ;print(TSOIL)
  MSOIL = in_mrlsl->mrlsl(ntime_s_mon-1:ntime_e_mon-1,:,:,:)
  SOILD = in_mrlsl->depth

; Get bottom level temperature for vertical extrapolation
  TBOT = T(:,0,:,:) 
  
  print("calculate dimensions")
  dsizes_x = dimsizes(T)
  ntime    = dsizes_x(0)
  nlev     = dsizes_x(1)
  nlat     = dsizes_x(2)
  nlon     = dsizes_x(3)
  
  print("calculate the start latitude and the increasement of latitude")
  del = new(nlat-1,double)
  do i = 0,nlat-2
    del(i)=lat(i+1)-lat(i)
  end do
  ave_del_lat = dim_avg(del(1:nlat-3))
;  print(ave_del_lat)
  lat_new=new(nlat,double)
  lat_new(0)=-90.0
  do i = 1,nlat-1
    lat_new(i)=lat_new(i-1)+ave_del_lat
  end do
;  diff = new(nlat,double)
;  diff = lat-lat_new
;  print(lat_new)
;  print(diff)

; since the near surface data are 3hours we need the 6hours data
  print("get ts us va qs")
  TS = new((/ntime,nlat,nlon/),float)
  US = new((/ntime,nlat,nlon/),float)
  VS = new((/ntime,nlat,nlon/),float)
  QS = new((/ntime,nlat,nlon/),float)
  do i = 0,ntime-1,1
    TS(i,:,:) = TS_3h(2*i,:,:)
    US(i,:,:) = US_3h(2*i,:,:)
    VS(i,:,:) = VS_3h(2*i,:,:)
    QS(i,:,:) = QS_3h(2*i,:,:)
  end do
  
  print("calculate ZSFC surface height ")
  ZSFC     = in_orog->orog
  PHIS     = ZSFC*9.81 
  
  print("get the LMASK land sea mask ")
  LMASK = in_lmask->sftlf
  do i = 0,nlat-1,1
    do j = 0,nlon-1,1
      if (LMASK(i,j) .gt. 50.0)
        LMASK(i,j) = 1.0
      else
        LMASK(i,j) = 0.0
      end if
    end do
  end do
  
  print("get parameters of the hybrid levels")
  hyam = in_ta->a
  hybm = in_ta->b
  hyai = new(nlev+1,double)
  hybi = new(nlev+1,double)
  hyai(0:nlev-1) = in_ta->a_bnds(:,0)
  hyai(nlev)     = in_ta->a_bnds(nlev-1,1)
  hybi(0:nlev-1) = in_ta->b_bnds(:,0)
  hybi(nlev)     = in_ta->b_bnds(nlev-1,1)

  
; Calculate geopotential height
  print ("calculate Z")
  TV = new((/ntime,nlev,nlat,nlon/),float) 
  TV = T*(1.+0.61*Q)
  Z = new((/ntime,nlev,nlat,nlon/),float) 
  Z = cz2ccm(PS,PHIS,TV(:,::-1,:,:),P0*100.,hyam,hybm,hyai,hybi)
  Z = Z(:,::-1,:,:) ;reorder vertical so consistent with T,U,V, and Q (bottom up)
; Print the average height of each level to evaluate if it is reasonable
; avgz_tmp = dim_avg_n_Wrap(Z,(/2,3/))
; avgz     = dim_avg_n_Wrap(avgz_tmp,0)
; print(avgz)

; Calculate the pressures on each hybrid level (bottom up)
  print ("calculate P")
  P = new((/ntime,nlev,nlat,nlon/),float) 
  P = pres_hybrid_ccm(PS,P0*100.,hyam,hybm)
; Print the average pressure of each level to evaluate if it is reasonable
; avgp_tmp = dim_avg_n_Wrap(P,(/2,3/))
; avgp     = dim_avg_n_Wrap(avgp_tmp,0) 
; print(avgp)

; Uses stock RH function in ncl
  print("calculate RH")
  R = new((/ntime,nlev,nlat,nlon/),float) 
  R = relhum(T,Q,P)
  R = where(R.gt.100.0, 100.0, R)
  RS = new((/ntime,nlat,nlon/),float) 
  RS = relhum(TS,QS,PS)
  RS = where(RS.gt.100.0, 100.0, RS)
; Print the average pressure of each level to evaluate if it is reasonable
; avgr_tmp = dim_avg_n_Wrap(R,(/2,3/))
; avgr     = dim_avg_n_Wrap(avgr_tmp,0)
; print(avgr)

  print("get the near surface variables")
  T2 = TS
  R2 = RS
  U10 = US
  V10 = VS
  
  print("get the sea surface temperature ")
  SST6 = new((/ntime,nlat,nlon/),float) ; create a 6 hourly variable and repeat 4x daily
  SST6(::4,:,:)=SST_DAY
  SST6(1::4,:,:)=SST_DAY
  SST6(2::4,:,:)=SST_DAY
  SST6(3::4,:,:)=SST_DAY
  SST6 = where (ismissing(SST6), -1.E30, SST6) ; set missing value to default for METGRID.TBL

  print("get the sea ice area ")
  ICE6 = new((/ntime,nlat,nlon/),float) ; create a 6 hourly variable and repeat 4x daily
  ICE6(::4,:,:)=ICE_DAY
  ICE6(1::4,:,:)=ICE_DAY
  ICE6(2::4,:,:)=ICE_DAY
  ICE6(3::4,:,:)=ICE_DAY
  ICE6 = where (ismissing(ICE6), -1.E30, ICE6) ; set missing value to default for METGRID.TBL  

;convert MSOIL from kg m-2 to fraction
  MSOIL = doubletofloat(MSOIL/(1000.*conform(MSOIL,SOILD,1))) 
  
; now we make into 6 hourly variables that change every month
; since we use this method , this script should run each month
; and it is recommanded to run by bash or python scripts with cdo software.
; note that soil M & T have several layers.  We only need the 4 that
; most closely correspond to the NOAH LSM 0-10,10-40,40-100,100-200 cm layers.
; these were predetermined based on inspection of the layers
; they aren't very important because they get spun up anyway...

  print("get the soil and surface data")
  TSKIN6   = new((/ntime,nlat,nlon/),float)
  SNOWW6   = new((/ntime,nlat,nlon/),float)
  TSOIL1_6 = new((/ntime,nlat,nlon/),float)
  TSOIL2_6 = new((/ntime,nlat,nlon/),float)
  TSOIL3_6 = new((/ntime,nlat,nlon/),float)
  TSOIL4_6 = new((/ntime,nlat,nlon/),float)
  MSOIL1_6 = new((/ntime,nlat,nlon/),float)
  MSOIL2_6 = new((/ntime,nlat,nlon/),float)
  MSOIL3_6 = new((/ntime,nlat,nlon/),float)
  MSOIL4_6 = new((/ntime,nlat,nlon/),float)
 
  TSKIN6   = conform(PS,TSKIN(0,:,:),(/1,2/))   
  TAVGSFC6 = TSKIN6              ; This can be used for inland lakes 
  SNOWW6   = conform(PS,SNOWW(0,:,:),(/1,2/))
  SNOWW6   = where (ismissing(SNOWW6), 0., SNOWW6) ; set missing value

; this is a very simple method and i will develop another method later
  TSOIL1_6 = conform(PS,TSOIL(0,0,:,:),(/1,2/))*0.2 \
           + conform(PS,TSOIL(0,1,:,:),(/1,2/))*0.4 \
           + conform(PS,TSOIL(0,2,:,:),(/1,2/))*0.4

  TSOIL2_6 = conform(PS,TSOIL(0,3,:,:),(/1,2/))*(1./6.) \
           + conform(PS,TSOIL(0,4,:,:),(/1,2/))*(1./6.) \
           + conform(PS,TSOIL(0,5,:,:),(/1,2/))*(2./6.) \
           + conform(PS,TSOIL(0,6,:,:),(/1,2/))*(2./6.)

  TSOIL3_6 = conform(PS,TSOIL(0,7,:,:),(/1,2/))*(2./6.) \
           + conform(PS,TSOIL(0,8,:,:),(/1,2/))*(2./6.) \
           + conform(PS,TSOIL(0,9,:,:),(/1,2/))*(2./6.)

  TSOIL4_6 = conform(PS,TSOIL(0,10,:,:),(/1,2/))*0.4 \
           + conform(PS,TSOIL(0,11,:,:),(/1,2/))*0.4 \
           + conform(PS,TSOIL(0,12,:,:),(/1,2/))*0.2
  

  MSOIL1_6 = conform(PS,MSOIL(0,0,:,:),(/1,2/))*0.2 \
           + conform(PS,MSOIL(0,1,:,:),(/1,2/))*0.4 \
           + conform(PS,MSOIL(0,2,:,:),(/1,2/))*0.4

  MSOIL2_6 = conform(PS,MSOIL(0,3,:,:),(/1,2/))*(1./6.) \
           + conform(PS,MSOIL(0,4,:,:),(/1,2/))*(1./6.) \
           + conform(PS,MSOIL(0,5,:,:),(/1,2/))*(2./6.) \
           + conform(PS,MSOIL(0,6,:,:),(/1,2/))*(2./6.)

  MSOIL3_6 = conform(PS,MSOIL(0,7,:,:),(/1,2/))*(2./6.) \
           + conform(PS,MSOIL(0,8,:,:),(/1,2/))*(2./6.) \
           + conform(PS,MSOIL(0,9,:,:),(/1,2/))*(2./6.)

  MSOIL4_6 = conform(PS,MSOIL(0,10,:,:),(/1,2/))*0.4 \
           + conform(PS,MSOIL(0,11,:,:),(/1,2/))*0.4 \
           + conform(PS,MSOIL(0,12,:,:),(/1,2/))*0.2

; Set missing values to default for METGRID.TBL
  TSOIL1_6 = where (ismissing(TSOIL1_6), -1.E30, TSOIL1_6)
  TSOIL2_6 = where (ismissing(TSOIL2_6), -1.E30, TSOIL2_6)
  TSOIL3_6 = where (ismissing(TSOIL3_6), -1.E30, TSOIL3_6)
  TSOIL4_6 = where (ismissing(TSOIL4_6), -1.E30, TSOIL4_6)

  MSOIL1_6 = where (ismissing(MSOIL1_6), -1.E30, MSOIL1_6)
  MSOIL2_6 = where (ismissing(MSOIL2_6), -1.E30, MSOIL2_6)
  MSOIL3_6 = where (ismissing(MSOIL3_6), -1.E30, MSOIL3_6)
  MSOIL4_6 = where (ismissing(MSOIL4_6), -1.E30, MSOIL4_6)  
  
;************************************************
; define other arguments required by vinth2p
;************************************************
; type of interpolation: 1 = linear, 2 = log, 3 = loglog
  interp = 2 

; is extrapolation desired if data is outside the range of PS
  extrap = True
   
; create an array of desired pressure levels:
  pnew = (/ 1000.0, 975.0, 950.0, 925.0, 900.0, 850.0, 800.0, 750.00, 700.0, 650.0, 600.0, 550.0, 500.0, \
            450.0,  400.0, 350.0, 300.0, 250.0, 200.0, 150.0, 100.0,  70.0,  50.0,  30.0,  20.0,  10.0 /)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; WRITE OUT DATA TO WRF INTERMEDIATE FORMAT (CALL FORTRAN SUBROUTINE VIA WRAPIT)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  print("write out data to WRF intermediate files")

; Set the IM header information
; These are all passed to the write script as resources

  opt = True
  opt@map_source             = "GFDL 2.022 x 2.5"
  opt@projection             = 0
  opt@startloc               = "SWCORNER"
  opt@startlon               = doubletofloat(lon(0))
  opt@startlat               = doubletofloat(lat_new(0))
  opt@deltalon               = doubletofloat(lon(1)-lon(0))
  opt@deltalat               = doubletofloat(ave_del_lat)
  opt@is_wind_earth_relative = False

; set the format to use for the date
  date_format  = "%Y-%N-%D_%H:00:0000000"        		; 24 chars exact for binary file
  date_format2 = "%Y-%N-%D_%H"                                  ; for filename
  yyyy_format  = "%Y" 						; for output directory


; Set up field specific header information
  FIELD_T       ="TT"
  UNITS_T       ="K"
  DESC_T        ="Temperature"

  FIELD_U       ="UU"
  UNITS_U       ="m s-1"
  DESC_U        ="Zonal Wind Speed"

  FIELD_V       ="VV"
  UNITS_V       ="m s-1"
  DESC_V        ="Meridional Wind Speed"

  FIELD_Q       ="SPECHUMD"
  UNITS_Q       ="kg kg-1"
  DESC_Q        ="Specific Humidity"

  FIELD_R       ="RH"
  UNITS_R       ="%"
  DESC_R        ="Relative Humidity"

  FIELD_Z       ="GHT"
  UNITS_Z       ="m"
  DESC_Z        ="Geopotential Height"

  FIELD_SLP     ="PMSL"
  UNITS_SLP     ="Pa"
  DESC_SLP      ="Sea level pressure"
  XLVL_SLP      = 201300.

  FIELD_PS      ="PSFC"
  UNITS_PS      ="Pa"
  DESC_PS       ="Surface pressure"

  FIELD_U10     ="UU"
  UNITS_U10     ="m s-1"
  DESC_U10      ="10 m Zonal Wind Speed"

  FIELD_V10     ="VV"
  UNITS_V10     ="m s-1"
  DESC_V10      ="10 m Meridional Wind Speed"

  FIELD_T2      ="TT"
  UNITS_T2      ="K"
  DESC_T2       ="2 m Temperature"

  FIELD_Q2      ="SPECHUMD"
  UNITS_Q2      ="kg kg-1"
  DESC_Q2       ="2 m Specific Humidity"

  FIELD_R2      ="RH"
  UNITS_R2      ="%"
  DESC_R2       ="2 m Relative Humidity"

  FIELD_SNOWW6  ="SNOW"
  UNITS_SNOWW6  ="kg m-2"
  DESC_SNOWW6   ="Water Equivalent of Accum Snow Depth"

  FIELD_TSKIN6  ="SKINTEMP"
  UNITS_TSKIN6  ="K"
  DESC_TSKIN6   ="Skin Temperature"

  FIELD_TAVGSFC6="TAVGSFC"
  UNITS_TAVGSFC6="K"
  DESC_TAVGSFC6 ="Daily mean of surface air temperature"

  FIELD_SST6    ="SST"
  UNITS_SST6    ="K"; 25 chars exact
  DESC_SST6     ="Sea Surface Temperature"

  FIELD_ICE6    ="SEAICE"
  UNITS_ICE6    ="fraction"
  DESC_ICE6     ="Sea-Ice-Fraction"

  FIELD_TSOIL1_6="ST000010"
  UNITS_TSOIL1_6="K"
  DESC_TSOIL1_6 ="Soil Temperature 0-10 cm layer"

  FIELD_TSOIL2_6="ST010040"
  UNITS_TSOIL2_6="K"
  DESC_TSOIL2_6 ="Soil Temperature 10-40 cm layer"

  FIELD_TSOIL3_6="ST040100"
  UNITS_TSOIL3_6="K"
  DESC_TSOIL3_6 ="Soil Temperature 40-100 cm layer"

  FIELD_TSOIL4_6="ST100200"
  UNITS_TSOIL4_6="K"
  DESC_TSOIL4_6 ="Soil Temperature 100-200 cm layer"

  FIELD_MSOIL1_6="SM000010"
  UNITS_MSOIL1_6="fraction"
  DESC_MSOIL1_6 ="Soil Moisture 0-10 cm layer"

  FIELD_MSOIL2_6="SM010040"
  UNITS_MSOIL2_6="fraction"
  DESC_MSOIL2_6 ="Soil Moisture 10-40 cm layer"

  FIELD_MSOIL3_6="SM040100"
  UNITS_MSOIL3_6="fraction"
  DESC_MSOIL3_6 ="Soil Moisture 40-100 cm layer"

  FIELD_MSOIL4_6="SM100200"
  UNITS_MSOIL4_6="fraction"
  DESC_MSOIL4_6 ="Soil Moisture 100-200 cm layer"

  FIELD_LMASK   ="LANDSEA"
  UNITS_LMASK   ="proprtn"
  DESC_LMASK    ="Land/Sea Flag; 0=Ocean; 1=Land"

  FIELD_ZSFC    ="SOILHGT"
  UNITS_ZSFC    ="m"
  DESC_ZSFC     ="Terrain Elevation"


; Loop through each time period - do final calculations and write data to the IM format
  do TIM = 0,ntime-1 

    HDATE = cd_string(time(TIM), date_format)                        ; set dates
    OFILE = IM_root_name+":" + cd_string(time(TIM), date_format2)    ; figure the output file name so that we can clobber it
    yyyy  = cd_string(time(TIM), yyyy_format)                        ; figure out the year so that we can make directories
    print("HDATE= " + HDATE)
    system ("mkdir -p " + outDIR + "/" + yyyy)	               	     ; make the output directories
    system ("rm " + OFILE)                                           ; delete the file, so that we don't append to an existing file
    system ("rm " + outDIR + "/" +yyyy+ "/" + OFILE)                 ; delete the file, so that we don't append to an existing file


    ; calculate 3-d variables on pressure levels (need to do this here because ncl doesn't like multiple times)
    print("extrapolate variables to pressure levels")
    varflg = 1
    TonP = vinth2p_ecmwf(T(TIM,::-1,:,:),hyam(::-1),hybm(::-1),pnew,PS(TIM,:,:),interp,P0,1,extrap,varflg,TBOT(TIM,:,:),PHIS)
    varflg = -1
    ZonP = vinth2p_ecmwf(Z(TIM,::-1,:,:),hyam(::-1),hybm(::-1),pnew,PS(TIM,:,:),interp,P0,1,extrap,varflg,TBOT(TIM,:,:),PHIS)
    varflg = 0
    UonP = vinth2p_ecmwf(U(TIM,::-1,:,:),hyam(::-1),hybm(::-1),pnew,PS(TIM,:,:),interp,P0,1,extrap,varflg,TBOT(TIM,:,:),PHIS)
    VonP = vinth2p_ecmwf(V(TIM,::-1,:,:),hyam(::-1),hybm(::-1),pnew,PS(TIM,:,:),interp,P0,1,extrap,varflg,TBOT(TIM,:,:),PHIS)
    RonP = vinth2p_ecmwf(R(TIM,::-1,:,:),hyam(::-1),hybm(::-1),pnew,PS(TIM,:,:),interp,P0,1,extrap,varflg,TBOT(TIM,:,:),PHIS)
    RonP = where(RonP.gt.100.0, 100.0, RonP)
    RonP = where(RonP.lt.0.0, 0.0, RonP)


    ; calcualte slp using ecmwf formulation (no 6-hourly or 3-hourly slp output is otherwise available)
    SLP = pslec(TBOT(TIM,:,:),PHIS,PS(TIM,:,:),P(TIM,0,:,:))


    opt@date = HDATE

    ; write any non-level variables (including treament of soil temp/moisture profiles as single levels each)
    ; Due to the fact that other programs will read these files, and there we assume the fields to in a in given order,
    ; these order of the writes below are import for this application

    opt@level = 200100.
    wrf_wps_write_int(IM_root_name,FIELD_LMASK,UNITS_LMASK,DESC_LMASK, LMASK(:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_ZSFC,UNITS_ZSFC,DESC_ZSFC, ZSFC(:,:),opt)
    wrf_wps_write_int(IM_root_name,FIELD_TSKIN6,UNITS_TSKIN6,DESC_TSKIN6, TSKIN6(TIM,:,:),opt)        
    wrf_wps_write_int(IM_root_name,FIELD_TAVGSFC6,UNITS_TAVGSFC6,DESC_TAVGSFC6, TAVGSFC6(TIM,:,:),opt) 
    wrf_wps_write_int(IM_root_name,FIELD_SST6,UNITS_SST6,DESC_SST6, SST6(TIM,:,:),opt)    
    wrf_wps_write_int(IM_root_name,FIELD_ICE6,UNITS_ICE6,DESC_ICE6, ICE6(TIM,:,:),opt)   
    wrf_wps_write_int(IM_root_name,FIELD_SNOWW6,UNITS_SNOWW6,DESC_SNOWW6, SNOWW6(TIM,:,:),opt)  
    wrf_wps_write_int(IM_root_name,FIELD_TSOIL1_6,UNITS_TSOIL1_6,DESC_TSOIL1_6, TSOIL1_6(TIM,:,:),opt) 
    wrf_wps_write_int(IM_root_name,FIELD_TSOIL2_6,UNITS_TSOIL2_6,DESC_TSOIL2_6, TSOIL2_6(TIM,:,:),opt) 
    wrf_wps_write_int(IM_root_name,FIELD_TSOIL3_6,UNITS_TSOIL3_6,DESC_TSOIL3_6, TSOIL3_6(TIM,:,:),opt) 
    wrf_wps_write_int(IM_root_name,FIELD_TSOIL4_6,UNITS_TSOIL4_6,DESC_TSOIL4_6, TSOIL4_6(TIM,:,:),opt) 
    wrf_wps_write_int(IM_root_name,FIELD_MSOIL1_6,UNITS_MSOIL1_6,DESC_MSOIL1_6, MSOIL1_6(TIM,:,:),opt) 
    wrf_wps_write_int(IM_root_name,FIELD_MSOIL2_6,UNITS_MSOIL2_6,DESC_MSOIL2_6, MSOIL2_6(TIM,:,:),opt) 
    wrf_wps_write_int(IM_root_name,FIELD_MSOIL3_6,UNITS_MSOIL3_6,DESC_MSOIL3_6, MSOIL3_6(TIM,:,:),opt) 
    wrf_wps_write_int(IM_root_name,FIELD_MSOIL4_6,UNITS_MSOIL4_6,DESC_MSOIL4_6, MSOIL4_6(TIM,:,:),opt) 

    opt@level = XLVL_SLP	; Need a different level for SLP
    wrf_wps_write_int(IM_root_name,FIELD_SLP,UNITS_SLP,DESC_SLP, SLP(:,:),opt)                      

    opt@level = 200100.		; Reset level back to regular surface value
    wrf_wps_write_int(IM_root_name,FIELD_PS,UNITS_PS,DESC_PS, PS(TIM,:,:),opt) 	            
    wrf_wps_write_int(IM_root_name,FIELD_U10,UNITS_U10,DESC_U10, U10(TIM,:,:),opt) 	           
    wrf_wps_write_int(IM_root_name,FIELD_V10,UNITS_V10,DESC_V10, V10(TIM,:,:),opt) 	          
    wrf_wps_write_int(IM_root_name,FIELD_T2,UNITS_T2,DESC_T2, T2(TIM,:,:),opt) 	         
    wrf_wps_write_int(IM_root_name,FIELD_R2,UNITS_R2,DESC_R2, R2(TIM,:,:),opt) 	       


    ; Write each level of the 3D fields out separately
    do LEV=0,dimsizes(pnew)-1

      opt@level = pnew(LEV)*100.
      wrf_wps_write_int(IM_root_name,FIELD_U,UNITS_U,DESC_U, UonP(LEV,:,:),opt)
      wrf_wps_write_int(IM_root_name,FIELD_V,UNITS_V,DESC_V, VonP(LEV,:,:),opt)
      wrf_wps_write_int(IM_root_name,FIELD_T,UNITS_T,DESC_T, TonP(LEV,:,:),opt)
      wrf_wps_write_int(IM_root_name,FIELD_R,UNITS_R,DESC_R, RonP(LEV,:,:),opt)
      wrf_wps_write_int(IM_root_name,FIELD_Z,UNITS_Z,DESC_Z, ZonP(LEV,:,:),opt)

    end do 

    ; move the file to the outDIR directory
      print ("mv " + OFILE + "   " + outDIR + "/" +yyyy+ "/.")
      system ("mv " + OFILE + "   " + outDIR + "/" +yyyy+ "/.")
      print("  ")

     delete(HDATE)
     delete(OFILE)
  end do 
  
end
