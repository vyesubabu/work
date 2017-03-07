load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

undef("first_output")
procedure first_output(file_name, lev, lat, lon, Z, U, V)
local fout
begin
    printVarSummary(Z)
    var_dim = dimsizes(Z)
    nlat = var_dim(2)
    nlon = var_dim(3)
    nlev = 5

    system("rm -rf " + file_name)
    fout = addfile(file_name, "c")  ; open output file

;===================================================================
; explicitly declare file definition mode. Improve efficiency.
;===================================================================
    setfileoption(fout,"DefineMode",True)

;===================================================================
    print("predefine the coordinate variables and their dimensionality")
; Note: to get an UNLIMITED record dimension, we set the dimensionality
; to -1 (or the actual size) and set the dimension name to True.
;===================================================================
    dimNames = (/"Time", "lev", "lat", "lon"/)
    dimSizes = (/ -1   , nlev,  nlat,  nlon/)
    dimUnlim = (/ True , False, False, False/)
    filedimdef(fout, dimNames, dimSizes, dimUnlim)

;===================================================================
    print("predefine the the dimensionality of the variables to be written out")
;===================================================================
; Here we are using NCL functions to facilitate defining
; each variable's dimension name(s) and type.
; The following could be replaced with explicit, user defined dimension
; names different from those associated with the variable in memory.
; Say, PS(Time,XLAT,XLONG) in the NCL script. They could be redefined for the file via:
; filevardef(fout, "PS"   ,typeof(PS) ,(/"Time","XLAT","XLONG"/))
;===================================================================
    filevardef(fout, "lev", typeof(lev),  getvardims(lev))
    filevardef(fout, "lat", typeof(lat),  getvardims(lat))
    filevardef(fout, "lon", typeof(lon),  getvardims(lon))
    filevardef(fout, "Z", typeof(Z) ,  getvardims(Z))
    filevardef(fout, "U", typeof(U) ,  getvardims(U))
    filevardef(fout, "V", typeof(V) ,  getvardims(V))

;===================================================================
    print("Copy attributes associated with each variable to the file")
; All attributes associated with each variable will be copied.
;====================================================================
    filevarattdef(fout, "lev", lev)       ; copy attributes
    filevarattdef(fout, "lat", lat)       ; copy attributes
    filevarattdef(fout, "lon", lon)       ; copy attributes
    filevarattdef(fout, "Z", Z)       ; copy attributes
    filevarattdef(fout, "U", U)       ; copy attributes
    filevarattdef(fout, "V", V)       ; copy attributes

;===================================================================
; explicitly exit file definition mode. **NOT REQUIRED**
;===================================================================
    setfileoption(fout,"DefineMode",False)

;===================================================================
    print("output the datas")
; output only the data values since the dimensionality and such have
; been predefined. The "(/", "/)" syntax tells NCL to only output the
; data values to the predefined locations on the file.
;====================================================================
    fout->lat     = (/lat/)
    fout->lon     = (/lon/)
    fout->lev     = (/lev/)
    fout->Z     = (/Z/)
    fout->U     = (/U/)
    fout->V     = (/V/)

end

undef("add_output")
procedure add_output(file_name, index, Z, U, V)
local fout
begin
    fout = addfile(file_name, "w")
    fout->Z(Time|index, lev|:, lat|:, lon|:)  = (/Z/)
    fout->U(Time|index, lev|:, lat|:, lon|:)  = (/U/)
    fout->V(Time|index, lev|:, lat|:, lon|:)  = (/V/)

end





begin

  print("open atmos data files ")
  in_hus   = addfile(hus_file,"r") ; 6hout
  in_ta    = addfile(ta_file,"r")  ; 6hour
  in_ps    = addfile(ps_file,"r")  ; 6hour
  in_ua    = addfile(ua_file,"r")  ; 6hour
  in_va    = addfile(va_file,"r")  ; 6hour


  print("open invariant data files ")
  in_orog  = addfile(orog_file,"r")    ; invariant data

  print("read variables of atmos")
  P0       = 1013.25    ; we can alse use P0 = in_ta->p0/100.
  lon      = in_ta->lon
  lat      = in_ta->lat
  lev      = in_ta->lev
  T = in_ta->ta(ntime_s_6h-1:ntime_e_6h-1,:,:,:)
  Q = in_hus->hus(ntime_s_6h-1:ntime_e_6h-1,:,:,:)
  PS = in_ps->ps(ntime_s_6h-1:ntime_e_6h-1,:,:)
  U = in_ua->ua(ntime_s_6h-1:ntime_e_6h-1,:,:,:)
  V = in_va->va(ntime_s_6h-1:ntime_e_6h-1,:,:,:)


; Get bottom level temperature for vertical extrapolation
  TBOT = T(:,0,:,:)

  print("calculate dimensions")
  dsizes_x = dimsizes(T)
  ntime    = dsizes_x(0)
  nlev     = dsizes_x(1)
  nlat     = dsizes_x(2)
  nlon     = dsizes_x(3)

  print("calculate the start latitude and the increasement of latitude")
  del = new(nlat-1, double)
  do i = 0,nlat-2
    del(i)=lat(i+1)-lat(i)
  end do
  ave_del_lat = dim_avg(del(1:nlat-3))
  lat_new = lat
  lat_new(0)=-90.0
  do i = 1,nlat-1
    lat_new(i)=lat_new(i-1) + ave_del_lat
  end do

  print("calculate ZSFC surface height ")
  ZSFC     = in_orog->orog
  PHIS     = ZSFC*9.81

  print("get parameters of the hybrid levels")
  hyam = in_ta->a
  hybm = in_ta->b
  hyai = new(nlev+1, double)
  hybi = new(nlev+1, double)
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

; Calculate the pressures on each hybrid level (bottom up)
  print ("calculate P")
  P = new((/ntime,nlev,nlat,nlon/),float)
  P = pres_hybrid_ccm(PS,P0*100.,hyam,hybm)


;************************************************
; define other arguments required by vinth2p
;************************************************
; type of interpolation: 1 = linear, 2 = log, 3 = loglog
  interp = 2

; is extrapolation desired if data is outside the range of PS
  extrap = True

; create an array of desired pressure levels:
  pnew = (/ 850.0, 700.0, 500.0, 300.0, 200.0 /)
  nlev_new = 5

  print("extrapolate variables to pressure levels")
  varflg = -1
  ZonP = vinth2p_ecmwf(Z(:,::-1,:,:),hyam(::-1),hybm(::-1),pnew,PS(:,:,:),interp,P0,1,extrap,varflg,TBOT(:,:,:),PHIS)
  varflg = 0
  UonP = vinth2p_ecmwf(U(:,::-1,:,:),hyam(::-1),hybm(::-1),pnew,PS(:,:,:),interp,P0,1,extrap,varflg,TBOT(:,:,:),PHIS)
  VonP = vinth2p_ecmwf(V(:,::-1,:,:),hyam(::-1),hybm(::-1),pnew,PS(:,:,:),interp,P0,1,extrap,varflg,TBOT(:,:,:),PHIS)

  ZonP_month = dim_avg_n_Wrap(ZonP, 0)
  UonP_month = dim_avg_n_Wrap(UonP, 0)
  VonP_month = dim_avg_n_Wrap(VonP, 0)

  ZonP_month_3dim = reshape(ZonP_month, (/1, nlev_new, nlat, nlon/))
  UonP_month_3dim = reshape(UonP_month, (/1, nlev_new, nlat, nlon/))
  VonP_month_3dim = reshape(VonP_month, (/1, nlev_new, nlat, nlon/))

  ZonP_month_3dim!0 = "Time"
  UonP_month_3dim!0 = "Time"
  VonP_month_3dim!0 = "Time"
  ZonP_month_3dim!1 = "lev"
  UonP_month_3dim!1 = "lev"
  VonP_month_3dim!1 = "lev"
  ZonP_month_3dim!2 = "lat"
  UonP_month_3dim!2 = "lat"
  VonP_month_3dim!2 = "lat"
  ZonP_month_3dim!3 = "lon"
  UonP_month_3dim!3 = "lon"
  VonP_month_3dim!3 = "lon"
  ZonP_month_3dim&lev = pnew
  UonP_month_3dim&lev = pnew
  VonP_month_3dim&lev = pnew
  ZonP_month_3dim&lat = lat_new
  UonP_month_3dim&lat = lat_new
  VonP_month_3dim&lat = lat_new
  ZonP_month_3dim&lon = lon
  UonP_month_3dim&lon = lon
  VonP_month_3dim&lon = lon

  lat_new!0 = "lat"
  lon!0 = "lon"
  pnew!0 = "lev"

  file_name = CASE +  "_pressure_level.nc"
  if(index .eq. 0)then
      first_output(file_name, pnew, lat_new, lon, ZonP_month_3dim, UonP_month_3dim, VonP_month_3dim)
  end if
      add_output(file_name, index, ZonP_month_3dim, UonP_month_3dim, VonP_month_3dim)

end
