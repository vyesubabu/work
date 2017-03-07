load "./make_plots_geo.ncl"
undef("subroutine")
procedure subroutine(geo, Times, wks_name, title_name)
begin
    geomask = geo
;---Read the new mask from the NetCDF file
    fmask    = addfile("./chn_mask_5m.nc","r")
    chn_mask = fmask->chn_mask
;---Create masked data array
    ndims = dimsizes(geo)
    ndim = dimsizes(ndims)
    if (ndim .eq. 3) then
        do i = 0, ndims(0) - 1
            geomask(i,:,:) = where(chn_mask.eq.1,geo(i,:,:),geo@_FillValue)
        end do
        times = new((/ndims(0)/), string)
        do i = 0, ndims(0) - 1
            times(i) = charactertostring(Times(i,:))
        end do
    else
        geomask = where(chn_mask.eq.1,geo,geo@_FillValue)
        times = Times
    end if

    make_plots(wks_name, title_name, geomask, times)
end

begin


;;;;;;;;;; plot 850hPa geo ;;;;;;;;;;
;    f = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "pi_geo_mean_850hPa"
;    title_name = "PI geo mean 850hPa"
;    geo = f->GEO_850(:,:,:)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_his/month_mean.nc", "r")
;    wks_name = "his_geo_mean_850hPa"
;    title_name = "HIS geo mean 850hPa"
;    geo = f->GEO_850(:,:,:)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_ghg/month_mean.nc", "r")
;    wks_name = "ghg_geo_mean_850hPa"
;    title_name = "GHG geo mean 850hPa"
;    geo = f->GEO_850(:,:,:)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_nat/month_mean.nc", "r")
;    wks_name = "nat_geo_mean_850hPa"
;    title_name = "NAT geo mean 850hPa"
;    geo = f->GEO_850(:,:,:)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;;;;;;;;;; end of plot 850hPa geo ;;;;;;;;;;

;;;;;;;;;; plot 500hPa geo ;;;;;;;;;;
;    f = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "pi_geo_mean_500hPa"
;    title_name = "PI geo mean 500hPa"
;    geo = f->GEO_500(:,:,:)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_his/month_mean.nc", "r")
;    wks_name = "his_geo_mean_500hPa"
;    title_name = "HIS geo mean 500hPa"
;    geo = f->GEO_500(:,:,:)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_ghg/month_mean.nc", "r")
;    wks_name = "ghg_geo_mean_500hPa"
;    title_name = "GHG geo mean 500hPa"
;    geo = f->GEO_500(:,:,:)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_nat/month_mean.nc", "r")
;    wks_name = "nat_geo_mean_500hPa"
;    title_name = "NAT geo mean 500hPa"
;    geo = f->GEO_500(:,:,:)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;;;;;;;;;; end of plot 500hPa geo ;;;;;;;;;;

;;;;;;;;;; plot 300hPa geo ;;;;;;;;;;
;    f = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "pi_geo_mean_300hPa"
;    title_name = "PI geo mean 300hPa"
;    geo = f->GEO_300(:,:,:)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_his/month_mean.nc", "r")
;    wks_name = "his_geo_mean_300hPa"
;    title_name = "HIS geo mean 300hPa"
;    geo = f->GEO_300(:,:,:)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_ghg/month_mean.nc", "r")
;    wks_name = "ghg_geo_mean_300hPa"
;    title_name = "GHG geo mean 300hPa"
;    geo = f->GEO_300(:,:,:)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_nat/month_mean.nc", "r")
;    wks_name = "nat_geo_mean_300hPa"
;    title_name = "NAT geo mean 300hPa"
;    geo = f->GEO_300(:,:,:)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;;;;;;;;;; end of plot 300hPa geo ;;;;;;;;;;





;;;;;;;;;; plot 850hPa geo diff ;;;;;;;;;;
;    f_1 = addfile("../data_his/month_mean.nc", "r")
;    f_2 = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "his_pi_diff_geo_mean_850hPa"
;    title_name = "HIS PI diff geo mean 850hPa"
;    geo_1 = f_1->GEO_850(:,:,:)
;    geo_2 = f_2->GEO_850(:,:,:)
;    geo = geo_1 - geo_2
;    copy_VarMeta(geo_1, geo)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;
;    f_1 = addfile("../data_ghg/month_mean.nc", "r")
;    f_2 = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "ghg_pi_diff_geo_mean_850hPa"
;    title_name = "GHG PI diff geo mean 850hPa"
;    geo_1 = f_1->GEO_850(:,:,:)
;    geo_2 = f_2->GEO_850(:,:,:)
;    geo = geo_1 - geo_2
;    copy_VarMeta(geo_1, geo)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;
;    f_1 = addfile("../data_nat/month_mean.nc", "r")
;    f_2 = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "nat_pi_diff_geo_mean_850hPa"
;    title_name = "NAT PI diff geo mean 850hPa"
;    geo_1 = f_1->GEO_850(:,:,:)
;    geo_2 = f_2->GEO_850(:,:,:)
;    geo = geo_1 - geo_2
;    copy_VarMeta(geo_1, geo)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;
;    f_1 = addfile("../data_his/month_mean.nc", "r")
;    f_2 = addfile("../data_nat/month_mean.nc", "r")
;    wks_name = "his_nat_diff_geo_mean_850hPa"
;    title_name = "HIS NAT diff geo mean 850hPa"
;    geo_1 = f_1->GEO_850(:,:,:)
;    geo_2 = f_2->GEO_850(:,:,:)
;    geo = geo_1 - geo_2
;    copy_VarMeta(geo_1, geo)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;
;    f_1 = addfile("../data_his/month_mean.nc", "r")
;    f_2 = addfile("../data_ghg/month_mean.nc", "r")
;    wks_name = "his_ghg_diff_geo_mean_850hPa"
;    title_name = "HIS GHG diff geo mean 850hPa"
;    geo_1 = f_1->GEO_850(:,:,:)
;    geo_2 = f_2->GEO_850(:,:,:)
;    geo = geo_1 - geo_2
;    copy_VarMeta(geo_1, geo)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;;;;;;;;;; end of plot 850hPa geo diff ;;;;;;;;;;

;;;;;;;;;; plot 500hPa geo diff ;;;;;;;;;;
;    f_1 = addfile("../data_his/month_mean.nc", "r")
;    f_2 = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "his_pi_diff_geo_mean_500hPa"
;    title_name = "HIS PI diff geo mean 500hPa"
;    geo_1 = f_1->GEO_500(:,:,:)
;    geo_2 = f_2->GEO_500(:,:,:)
;    geo = geo_1 - geo_2
;    copy_VarMeta(geo_1, geo)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;
;    f_1 = addfile("../data_ghg/month_mean.nc", "r")
;    f_2 = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "ghg_pi_diff_geo_mean_500hPa"
;    title_name = "GHG PI diff geo mean 500hPa"
;    geo_1 = f_1->GEO_500(:,:,:)
;    geo_2 = f_2->GEO_500(:,:,:)
;    geo = geo_1 - geo_2
;    copy_VarMeta(geo_1, geo)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;
;    f_1 = addfile("../data_nat/month_mean.nc", "r")
;    f_2 = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "nat_pi_diff_geo_mean_500hPa"
;    title_name = "NAT PI diff geo mean 500hPa"
;    geo_1 = f_1->GEO_500(:,:,:)
;    geo_2 = f_2->GEO_500(:,:,:)
;    geo = geo_1 - geo_2
;    copy_VarMeta(geo_1, geo)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;
;    f_1 = addfile("../data_his/month_mean.nc", "r")
;    f_2 = addfile("../data_nat/month_mean.nc", "r")
;    wks_name = "his_nat_diff_geo_mean_500hPa"
;    title_name = "HIS NAT diff geo mean 500hPa"
;    geo_1 = f_1->GEO_500(:,:,:)
;    geo_2 = f_2->GEO_500(:,:,:)
;    geo = geo_1 - geo_2
;    copy_VarMeta(geo_1, geo)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;
;    f_1 = addfile("../data_his/month_mean.nc", "r")
;    f_2 = addfile("../data_ghg/month_mean.nc", "r")
;    wks_name = "his_ghg_diff_geo_mean_500hPa"
;    title_name = "HIS GHG diff geo mean 500hPa"
;    geo_1 = f_1->GEO_500(:,:,:)
;    geo_2 = f_2->GEO_500(:,:,:)
;    geo = geo_1 - geo_2
;    copy_VarMeta(geo_1, geo)
;    geo_mean = dim_avg_n_Wrap(geo, 0)
;    subroutine(geo_mean, "16years", wks_name, title_name)
;;;;;;;;;; end of plot 500hPa geo diff ;;;;;;;;;;

;;;;;;;;;; plot 300hPa geo diff ;;;;;;;;;;
    f_1 = addfile("../data_his/month_mean.nc", "r")
    f_2 = addfile("../data_pi/month_mean.nc", "r")
    wks_name = "his_pi_diff_geo_mean_300hPa"
    title_name = "HIS PI diff geo mean 300hPa"
    geo_1 = f_1->GEO_300(:,:,:)
    geo_2 = f_2->GEO_300(:,:,:)
    geo = geo_1 - geo_2
    copy_VarMeta(geo_1, geo)
    geo_mean = dim_avg_n_Wrap(geo, 0)
    subroutine(geo_mean, "16years", wks_name, title_name)

    f_1 = addfile("../data_ghg/month_mean.nc", "r")
    f_2 = addfile("../data_pi/month_mean.nc", "r")
    wks_name = "ghg_pi_diff_geo_mean_300hPa"
    title_name = "GHG PI diff geo mean 300hPa"
    geo_1 = f_1->GEO_300(:,:,:)
    geo_2 = f_2->GEO_300(:,:,:)
    geo = geo_1 - geo_2
    copy_VarMeta(geo_1, geo)
    geo_mean = dim_avg_n_Wrap(geo, 0)
    subroutine(geo_mean, "16years", wks_name, title_name)

    f_1 = addfile("../data_nat/month_mean.nc", "r")
    f_2 = addfile("../data_pi/month_mean.nc", "r")
    wks_name = "nat_pi_diff_geo_mean_300hPa"
    title_name = "NAT PI diff geo mean 300hPa"
    geo_1 = f_1->GEO_300(:,:,:)
    geo_2 = f_2->GEO_300(:,:,:)
    geo = geo_1 - geo_2
    copy_VarMeta(geo_1, geo)
    geo_mean = dim_avg_n_Wrap(geo, 0)
    subroutine(geo_mean, "16years", wks_name, title_name)

    f_1 = addfile("../data_his/month_mean.nc", "r")
    f_2 = addfile("../data_nat/month_mean.nc", "r")
    wks_name = "his_nat_diff_geo_mean_300hPa"
    title_name = "HIS NAT diff geo mean 300hPa"
    geo_1 = f_1->GEO_300(:,:,:)
    geo_2 = f_2->GEO_300(:,:,:)
    geo = geo_1 - geo_2
    copy_VarMeta(geo_1, geo)
    geo_mean = dim_avg_n_Wrap(geo, 0)
    subroutine(geo_mean, "16years", wks_name, title_name)

    f_1 = addfile("../data_his/month_mean.nc", "r")
    f_2 = addfile("../data_ghg/month_mean.nc", "r")
    wks_name = "his_ghg_diff_geo_mean_300hPa"
    title_name = "HIS GHG diff geo mean 300hPa"
    geo_1 = f_1->GEO_300(:,:,:)
    geo_2 = f_2->GEO_300(:,:,:)
    geo = geo_1 - geo_2
    copy_VarMeta(geo_1, geo)
    geo_mean = dim_avg_n_Wrap(geo, 0)
    subroutine(geo_mean, "16years", wks_name, title_name)
;;;;;;;;;; end of plot 300hPa geo diff ;;;;;;;;;;

end

