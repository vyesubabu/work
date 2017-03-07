load "./make_plots.ncl"
undef("subroutine")
procedure subroutine(spd, Times, wks_name, title_name)
begin
end

begin

    f = addfile("../data_pi/month_mean.nc", "r")
    wks_name = "pi_wind_spd_mean"
    title_name = "PI wind speed mean"
    spd_all = f->SPD10(:,:,:)
    spd = dim_avg_n_Wrap(spd_all, 0)
    lat = f->XLAT(0,:,:) 
    lon = f->XLONG(0,:,:)
    a_lon = (/118.07, 110.89, 106.66, 104.66, 102.36, 85.31, 71.33, 61.34, 108.10, 116.22 /)
    a_lat = (/39.23,  38.85,  37.95,  37.24,  36.60,  37.99, 33.40, 52.90, 56.11,  45.74 /)
    inout = gc_inout(lat,lon,a_lat,a_lon)

    
    Times = "16years"

    spdmask = spd
;---Read the new mask from the NetCDF file 
    fmask    = addfile("./chn_mask_5m.nc","r")
    chn_mask = fmask->chn_mask
;---Create masked data array
    ndims = dimsizes(spd)
    ndim = dimsizes(ndims)
    if (ndim .eq. 3) then
        do i = 0, ndims(0) - 1
            spdmask(i,:,:) = where(chn_mask.eq.1,spd(i,:,:),spd@_FillValue)
            spdmask_re(i,:,:) = where(inout.eq.True,spdmask(i,:,:),spdmask@_FillValue)
        end do
        times = new((/ndims(0)/), string)
        do i = 0, ndims(0) - 1
            times(i) = charactertostring(Times(i,:))
        end do
    else
        spdmask = where(chn_mask.eq.1,spd,spd@_FillValue)
        spdmask_re = where(inout.eq.True,spdmask,spdmask@_FillValue)
        times = Times
    end if

    make_plots(wks_name, title_name, spdmask_re, times)

end

