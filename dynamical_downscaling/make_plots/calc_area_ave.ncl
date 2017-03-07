undef("func")
function func(f)
begin

    a_lon = (/118.07, 110.89, 106.66, 104.66, 102.36, 85.31, 71.33, 61.34, 108.10, 116.22 /)
    a_lat = (/39.23,  38.85,  37.95,  37.24,  36.60,  37.99, 33.40, 52.90, 56.11,  45.74 /)

    b_lon = (/118.07, 116.22, 108.10, 143.58, 125.76, 121.17 /)
    b_lat = (/39.23,  45.74,  56.11,  50.40,  36.90,  38.26 /)

    c_lon = (/104.66, 102.36, 85.31, 71.33, 77.11, 105.20, 105.43, 103.95, 102.48, 104.37/)
    c_lat = (/37.24,  36.60,  37.99, 33.40, 22.64, 17.88,  22.14,  27.60,  29.91,  32.97 /)

    d_lon = (/110.89, 106.66, 104.66, 104.37, 102.48, 103.95, 105.43, 110.92, 112.23, 110.01, 110.34/)
    d_lat = (/38.85,  37.95,  37.24,  32.97,  29.91,  27.60,  22.14,  24.90,  29.67,  31.80,  34.38/)

    e_lon = (/118.06, 110.89, 110.34, 110.01, 112.23, 110.92, 105.43, 108.04, 126.78, 125.76, 121.17 /)
    e_lat = (/39.22,  38.85,  34.38,  31.80,  29.67,  24.90,  22.14,  15.42,  20.50,  36.90,  38.26 /)

    lat = f->XLAT(0,:,:)
    lon = f->XLONG(0,:,:)
    inout_a = gc_inout(lat,lon,a_lat,a_lon)
    inout_b = gc_inout(lat,lon,b_lat,b_lon)
    inout_c = gc_inout(lat,lon,c_lat,c_lon)
    inout_d = gc_inout(lat,lon,d_lat,d_lon)
    inout_e = gc_inout(lat,lon,e_lat,e_lon)

    fmask    = addfile("./chn_mask_5m.nc","r")
    chn_mask = fmask->chn_mask
    spd = f->SPD10(:,:,:)
    spdmask = spd
    spdmask_re_a = spd
    spdmask_re_b = spd
    spdmask_re_c = spd
    spdmask_re_d = spd
    spdmask_re_e = spd
    ndims = dimsizes(spd)
    do i = 0, ndims(0) - 1
        spdmask(i,:,:) = where(chn_mask.eq.1,spd(i,:,:),spd@_FillValue)
        spdmask_re_a(i,:,:) = where(inout_a.eq.True,spdmask(i,:,:),spdmask@_FillValue)
        spdmask_re_b(i,:,:) = where(inout_b.eq.True,spdmask(i,:,:),spdmask@_FillValue)
        spdmask_re_c(i,:,:) = where(inout_c.eq.True,spdmask(i,:,:),spdmask@_FillValue)
        spdmask_re_d(i,:,:) = where(inout_d.eq.True,spdmask(i,:,:),spdmask@_FillValue)
        spdmask_re_e(i,:,:) = where(inout_e.eq.True,spdmask(i,:,:),spdmask@_FillValue)
    end do
    spd_mean_a = wgt_areaave_Wrap(spdmask_re_a, 1.0, 1.0, 1)
    spd_mean_b = wgt_areaave_Wrap(spdmask_re_b, 1.0, 1.0, 1)
    spd_mean_c = wgt_areaave_Wrap(spdmask_re_c, 1.0, 1.0, 1)
    spd_mean_d = wgt_areaave_Wrap(spdmask_re_d, 1.0, 1.0, 1)
    spd_mean_e = wgt_areaave_Wrap(spdmask_re_e, 1.0, 1.0, 1)

;    output = new((/5, dimsizes(spd_mean_a)/), float)
    output = (/spd_mean_a, spd_mean_b, spd_mean_c, spd_mean_d, spd_mean_e/)

    return output

end

begin

    f = addfile("../data_pi/month_mean.nc", "r")
    out_pi = func(f)
    f = addfile("../data_his/month_mean.nc", "r")
    out_his = func(f)
    f = addfile("../data_ghg/month_mean.nc", "r")
    out_ghg = func(f)
    f = addfile("../data_nat/month_mean.nc", "r")
    out_nat = func(f)

    format = "%.6f %.6f %.6f %.6f"
    data_list_a = [/out_pi(0,:), out_nat(0,:), out_ghg(0,:), out_his(0,:)/]
    data_list_b = [/out_pi(1,:), out_nat(1,:), out_ghg(1,:), out_his(1,:)/]
    data_list_c = [/out_pi(2,:), out_nat(2,:), out_ghg(2,:), out_his(2,:)/]
    data_list_d = [/out_pi(3,:), out_nat(3,:), out_ghg(3,:), out_his(3,:)/]
    data_list_e = [/out_pi(4,:), out_nat(4,:), out_ghg(4,:), out_his(4,:)/]

    write_table("a.txt","w",data_list_a,format)
    write_table("b.txt","w",data_list_b,format)
    write_table("c.txt","w",data_list_c,format)
    write_table("d.txt","w",data_list_d,format)
    write_table("e.txt","w",data_list_e,format)

end
