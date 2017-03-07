load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "./output_netcdf.ncl"

begin
    if (case .eq. "pi") then
        time_curr_split = stringtocharacter(time_curr)
        year_curr = time_curr_split(0:3)
        year_curr!0 = "DateStrLen"
        year_pi = stringtocharacter(tostring_with_format(stringtointeger(charactertostring(time_curr_split(0:3))) - 1500, "%4.4d"))
        time_curr_split(0:3) = year_pi(0:3)
        time_curr = charactertostring(time_curr_split)
    end if

    f = addfile("./output_" + case + "/wrfout_d01_" + time_curr, "r")
    Times = wrf_user_getvar(f, "Times", -1)

    if (case .eq. "pi") then
        Times(0, 0:3) = year_curr
    end if

    DateStrLen  = 19
    xlong = f->XLONG
    xlat = f->XLAT

    geopotential = wrf_user_getvar(f, "geopotential", -1)
    pressure = wrf_user_getvar(f, "pressure", -1)
    height = wrf_user_getvar(f, "height", -1)

    uvmet = wrf_user_getvar(f, "uvmet", -1)
    u = uvmet(0,:,:,:,:)
    v = uvmet(1,:,:,:,:)
    u@description = "u met velocity"
    v@description = "v met velocity"
    uvmet10 = wrf_user_getvar(f, "uvmet10", -1)
    u10 = uvmet10(0,:,:,:)
    v10 = uvmet10(1,:,:,:)
    u10@description = "u10 met velocity"
    v10@description = "v10 met velocity"

    u_850 = wrf_user_intrp3d(u, pressure, "h", 850., 0., False)
    v_850 = wrf_user_intrp3d(v, pressure, "h", 850., 0., False)
    u_700 = wrf_user_intrp3d(u, pressure, "h", 700., 0., False)
    v_700 = wrf_user_intrp3d(v, pressure, "h", 700., 0., False)
    u_500 = wrf_user_intrp3d(u, pressure, "h", 500., 0., False)
    v_500 = wrf_user_intrp3d(v, pressure, "h", 500., 0., False)
    u_300 = wrf_user_intrp3d(u, pressure, "h", 300., 0., False)
    v_300 = wrf_user_intrp3d(v, pressure, "h", 300., 0., False)
    u_200 = wrf_user_intrp3d(u, pressure, "h", 200., 0., False)
    v_200 = wrf_user_intrp3d(v, pressure, "h", 200., 0., False)
    geo_850 = wrf_user_intrp3d(geopotential, pressure, "h", 850., 0., False)
    geo_700 = wrf_user_intrp3d(geopotential, pressure, "h", 700., 0., False)
    geo_500 = wrf_user_intrp3d(geopotential, pressure, "h", 500., 0., False)
    geo_300 = wrf_user_intrp3d(geopotential, pressure, "h", 300., 0., False)
    geo_200 = wrf_user_intrp3d(geopotential, pressure, "h", 200., 0., False)
    u_850!0 = "Time"
    v_850!0 = "Time"
    u_700!0 = "Time"
    v_700!0 = "Time"
    u_500!0 = "Time"
    v_500!0 = "Time"
    u_300!0 = "Time"
    v_300!0 = "Time"
    u_200!0 = "Time"
    v_200!0 = "Time"
    geo_850!0 = "Time"
    geo_700!0 = "Time"
    geo_500!0 = "Time"
    geo_300!0 = "Time"
    geo_200!0 = "Time"

    if (index .eq. 0) then
        first_output(file_name, Times, DateStrLen, xlat, xlong, u10, v10,\
                 u_850, v_850, u_700, v_700, u_500, v_500,\
                 u_300, v_300, u_200, v_200,\
                 geo_850, geo_700, geo_500, geo_300, geo_200)
    else
        add_output(file_name, Times, index, xlat, xlong, u10, v10,\
                 u_850, v_850, u_700, v_700, u_500, v_500,\
                 u_300, v_300, u_200, v_200,\
                 geo_850, geo_700, geo_500, geo_300, geo_200)
    end if

end
