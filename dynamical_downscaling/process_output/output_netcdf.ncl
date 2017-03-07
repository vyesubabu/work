undef("first_output")
procedure first_output(file_name, Times, DateStrLen, XLAT, XLONG, U10, V10,\
                 U_850, V_850, U_700, V_700, U_500, V_500,\
                 U_300, V_300, U_200, V_200,\
                 GEO_850, GEO_700, GEO_500, GEO_300, GEO_200)
local fout,  west_east, south_north
begin
    var_dim = dimsizes(U10)
    south_north = var_dim(1)
    west_east   = var_dim(2)

    system("rm -rf " + file_name)
    fout = addfile(file_name, "c")  ; open output file

;===================================================================
; explicitly declare file definition mode. Improve efficiency.
;===================================================================
    setfileoption(fout,"DefineMode",True)

;===================================================================
; create global attributes of the file
;===================================================================
    f_in               = addfile("./wrfout_d01_1984-01-01_06:00:00", "r")
    fAtt               = True            ; assign file attributes
    fAtt@title         = "NCL Efficient Approach to netCDF Creation"
    fAtt@Conventions   = "None"
    fAtt@creation_date = systemfunc ("date")
    fileattdef( fout, f_in )            ; copy file attributes

;===================================================================
; predefine the coordinate variables and their dimensionality
; Note: to get an UNLIMITED record dimension, we set the dimensionality
; to -1 (or the actual size) and set the dimension name to True.
;===================================================================
    dimNames = (/"Time", "south_north", "west_east", "DateStrLen"/)
    dimSizes = (/ -1   ,  south_north,  west_east, DateStrLen/)
    dimUnlim = (/ True , False, False, False/)
    filedimdef(fout, dimNames, dimSizes, dimUnlim)

;===================================================================
; predefine the the dimensionality of the variables to be written out
;===================================================================
; Here we are using NCL functions to facilitate defining
; each variable's dimension name(s) and type.
; The following could be replaced with explicit, user defined dimension
; names different from those associated with the variable in memory.
; Say, PS(Time,XLAT,XLONG) in the NCL script. They could be redefined for the file via:
; filevardef(fout, "PS"   ,typeof(PS) ,(/"Time","XLAT","XLONG"/))
;===================================================================
    filevardef(fout, "Times", typeof(Times), getvardims(Times))
    filevardef(fout, "XLAT",  typeof(XLAT),  getvardims(XLAT))
    filevardef(fout, "XLONG", typeof(XLONG), getvardims(XLONG))
    filevardef(fout, "U10",   typeof(U10) ,  getvardims(U10))
    filevardef(fout, "V10",   typeof(V10) ,  getvardims(V10))
    filevardef(fout, "U_850",   typeof(U_850) ,  getvardims(U_850))
    filevardef(fout, "V_850",   typeof(V_850) ,  getvardims(V_850))
    filevardef(fout, "U_700",   typeof(U_700) ,  getvardims(U_700))
    filevardef(fout, "V_700",   typeof(V_700) ,  getvardims(V_700))
    filevardef(fout, "U_500",   typeof(U_500) ,  getvardims(U_500))
    filevardef(fout, "V_500",   typeof(V_500) ,  getvardims(V_500))
    filevardef(fout, "U_300",   typeof(U_300) ,  getvardims(U_300))
    filevardef(fout, "V_300",   typeof(V_300) ,  getvardims(V_300))
    filevardef(fout, "U_200",   typeof(U_200) ,  getvardims(U_200))
    filevardef(fout, "V_200",   typeof(V_200) ,  getvardims(V_200))
    filevardef(fout, "GEO_850",   typeof(GEO_850) ,  getvardims(GEO_850))
    filevardef(fout, "GEO_700",   typeof(GEO_700) ,  getvardims(GEO_700))
    filevardef(fout, "GEO_500",   typeof(GEO_500) ,  getvardims(GEO_500))
    filevardef(fout, "GEO_300",   typeof(GEO_300) ,  getvardims(GEO_300))
    filevardef(fout, "GEO_200",   typeof(GEO_200) ,  getvardims(GEO_200))

;===================================================================
; Copy attributes associated with each variable to the file
; All attributes associated with each variable will be copied.
;====================================================================
    filevarattdef(fout, "Times", Times)     ; copy XLAT attributes
    filevarattdef(fout, "XLAT",  XLAT)      ; copy XLAT attributes
    filevarattdef(fout, "XLONG", XLONG)     ; copy XLONG attributes
    filevarattdef(fout, "U10",   U10)       ; copy attributes
    filevarattdef(fout, "V10",   V10)       ; copy attributes
    filevarattdef(fout, "U_850",   U_850)       ; copy attributes
    filevarattdef(fout, "V_850",   V_850)       ; copy attributes
    filevarattdef(fout, "U_700",   U_700)       ; copy attributes
    filevarattdef(fout, "V_700",   V_700)       ; copy attributes
    filevarattdef(fout, "U_500",   U_500)       ; copy attributes
    filevarattdef(fout, "V_500",   V_500)       ; copy attributes
    filevarattdef(fout, "U_300",   U_300)       ; copy attributes
    filevarattdef(fout, "V_300",   V_300)       ; copy attributes
    filevarattdef(fout, "U_200",   U_200)       ; copy attributes
    filevarattdef(fout, "V_200",   V_200)       ; copy attributes
    filevarattdef(fout, "GEO_850",   GEO_850)       ; copy attributes
    filevarattdef(fout, "GEO_700",   GEO_700)       ; copy attributes
    filevarattdef(fout, "GEO_500",   GEO_500)       ; copy attributes
    filevarattdef(fout, "GEO_300",   GEO_300)       ; copy attributes
    filevarattdef(fout, "GEO_200",   GEO_200)       ; copy attributes

;===================================================================
; explicitly exit file definition mode. **NOT REQUIRED**
;===================================================================
    setfileoption(fout,"DefineMode",False)

;===================================================================
; output only the data values since the dimensionality and such have
; been predefined. The "(/", "/)" syntax tells NCL to only output the
; data values to the predefined locations on the file.
;====================================================================
    fout->Times    = (/Times/)
    fout->XLAT    = (/XLAT/)
    fout->XLONG   = (/XLONG/)
    fout->U10     = (/U10/)
    fout->V10     = (/V10/)
    fout->U_850     = (/U_850/)
    fout->V_850     = (/V_850/)
    fout->U_700     = (/U_700/)
    fout->V_700     = (/V_700/)
    fout->U_500     = (/U_500/)
    fout->V_500     = (/V_500/)
    fout->U_300     = (/U_300/)
    fout->V_300     = (/V_300/)
    fout->U_200     = (/U_200/)
    fout->V_200     = (/V_200/)
    fout->GEO_850     = (/GEO_850/)
    fout->GEO_700     = (/GEO_700/)
    fout->GEO_500     = (/GEO_500/)
    fout->GEO_300     = (/GEO_300/)
    fout->GEO_200     = (/GEO_200/)

end

undef("add_output")
procedure add_output(file_name, Times, index, XLAT, XLONG, U10, V10,\
                 U_850, V_850, U_700, V_700, U_500, V_500,\
                 U_300, V_300, U_200, V_200,\
                 GEO_850, GEO_700, GEO_500, GEO_300, GEO_200)
local fout
begin
    fout = addfile(file_name, "w")
    fout->Times(Time|index, DateStrLen|:)                   = (/Times/)
    fout->XLAT(Time|index, south_north|:, west_east|:)      = (/XLAT/)
    fout->XLONG(Time|index, south_north|:, west_east|:)     = (/XLONG/)
    fout->U10(Time|index, south_north|:, west_east|:)       = (/U10/)
    fout->V10(Time|index, south_north|:, west_east|:)       = (/V10/)
    fout->U_850(Time|index, south_north|:, west_east|:)     = (/U_850/)
    fout->V_850(Time|index, south_north|:, west_east|:)     = (/V_850/)
    fout->U_700(Time|index, south_north|:, west_east|:)     = (/U_700/)
    fout->V_700(Time|index, south_north|:, west_east|:)     = (/V_700/)
    fout->U_500(Time|index, south_north|:, west_east|:)     = (/U_500/)
    fout->V_500(Time|index, south_north|:, west_east|:)     = (/V_500/)
    fout->U_300(Time|index, south_north|:, west_east|:)     = (/U_300/)
    fout->V_300(Time|index, south_north|:, west_east|:)     = (/V_300/)
    fout->U_200(Time|index, south_north|:, west_east|:)     = (/U_200/)
    fout->V_200(Time|index, south_north|:, west_east|:)     = (/V_200/)
    fout->GEO_850(Time|index, south_north|:, west_east|:)     = (/GEO_850/)
    fout->GEO_700(Time|index, south_north|:, west_east|:)     = (/GEO_700/)
    fout->GEO_500(Time|index, south_north|:, west_east|:)     = (/GEO_500/)
    fout->GEO_300(Time|index, south_north|:, west_east|:)     = (/GEO_300/)
    fout->GEO_200(Time|index, south_north|:, west_east|:)     = (/GEO_200/)

end
