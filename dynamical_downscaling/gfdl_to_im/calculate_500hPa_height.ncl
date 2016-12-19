load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/popRemap.ncl"

begin

  in_ta    = addfile("atmos_ta.nc","r")      ; 6-hourly 3-d T              
  in_hus   = addfile("atmos_hus.nc","r")     ; 6-hourly 3-d Q                   
  in_ps    = addfile("atmos_ps.nc","r")      ; 6-hourly surface pressure
  in_zsfc  = addfile("atmos_zsfc.nc","r")    ; static surface geopotential        


  time   = in_ta->time                            
  P0 = 1000.       ; value of P0 is 1000.(units=hPa); it is used in both Pa and hPa units below depending on function
  lon = in_ta->lon
  lat = in_ta->lat

  T = in_ta->T(:,::-1,:,:)                               
  Q = in_hus->Q(:,::-1,:,:)                    
  PHIS = in_zsfc->PHIS
  ZSFC = PHIS/9.81
  PS   = in_ps->PS                        
  LAT  = in_ta->lat                          
  hyam = in_ta->hyam(::-1)                            
  hybm = in_ta->hybm(::-1)                      
  hyai = in_ta->hyai(::-1)                            
  hybi = in_ta->hybi(::-1)                      

; get dimensions from dummy variable
  dsizes_x = dimsizes(T)
  ntim     = dsizes_x(0)
  nlev     = dsizes_x(1)
  nlat     = dsizes_x(2)
  nlon     = dsizes_x(3)

; Calculate geopotential height
  TV = T
  TV = T*(1.+0.61*Q)
  Z = T
  Z = cz2ccm(PS,PHIS,TV(:,::-1,:,:),P0*100.,hyam,hybm,hyai,hybi)
  Z = Z(:,::-1,:,:) ;reorder vertical so consistent with T,U,V, and Q (bottom up)

; Calculate the pressures on each hybrid level (bottom up)
  P = T
  P = pres_hybrid_ccm(PS,P0*100.,hyam,hybm)


;************************************************
; define other arguments required by vinth2p
;************************************************
; type of interpolation: 1 = linear, 2 = log, 3 = loglog
  interp = 2 

; is extrapolation desired if data is outside the range of PS
  extrap = True
   
; create an array of desired pressure levels:
  pnew = (/  500.0  /)


; Loop through each time period - do final calculations and write data to the IM format
  do TIM = 0,ntim-1 

    ; calculate 3-d variables on pressure levels (need to do this here because ncl doesn't like multiple times)
    varflg = -1
    ZonP = vinth2p_ecmwf(Z(TIM,::-1,:,:),hyam(::-1),hybm(::-1),pnew,PS(TIM,:,:),interp,P0,1,extrap,varflg,TBOT(TIM,:,:),PHIS)
    printVarSummary(ZonP)

  end do 

end

