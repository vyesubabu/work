load "./make_plots_wind.ncl"

undef("subroutine")
procedure subroutine(spd, Times, wks_name, title_name)
begin
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
        end do
        times = new((/ndims(0)/), string)
        do i = 0, ndims(0) - 1
            times(i) = charactertostring(Times(i,:))
        end do
    else
        spdmask = where(chn_mask.eq.1,spd,spd@_FillValue)
        times = Times
    end if

    make_plots(wks_name, title_name, spdmask, times)
end

begin

;;;;;;;;;; plot 10m wind speed ;;;;;;;;;;
;    f = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "pi_wind_spd_mean_10m"
;    title_name = "PI wind speed mean 10m"
;    spd = f->SPD10(:,:,:)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_his/month_mean.nc", "r")
;    wks_name = "his_wind_spd_mean_10m"
;    title_name = "HIS wind speed mean 10m"
;    spd = f->SPD10(:,:,:)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_ghg/month_mean.nc", "r")
;    wks_name = "ghg_wind_spd_mean_10m"
;    title_name = "GHG wind speed mean 10m"
;    spd = f->SPD10(:,:,:)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_nat/month_mean.nc", "r")
;    wks_name = "nat_wind_spd_mean_10m"
;    title_name = "NAT wind speed mean 10m"
;    spd = f->SPD10(:,:,:)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;;;;;;;;;; end of plot 10m wind speed ;;;;;;;;;;

;;;;;;;;;; plot 850hPa wind speed ;;;;;;;;;;
;    f = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "pi_wind_spd_mean_850hPa"
;    title_name = "PI wind speed mean 850hPa"
;    spd = f->SPD_850(:,:,:)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_his/month_mean.nc", "r")
;    wks_name = "his_wind_spd_mean_850hPa"
;    title_name = "HIS wind speed mean 850hPa"
;    spd = f->SPD_850(:,:,:)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_ghg/month_mean.nc", "r")
;    wks_name = "ghg_wind_spd_mean_850hPa"
;    title_name = "GHG wind speed mean 850hPa"
;    spd = f->SPD_850(:,:,:)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_nat/month_mean.nc", "r")
;    wks_name = "nat_wind_spd_mean_850hPa"
;    title_name = "NAT wind speed mean 850hPa"
;    spd = f->SPD_850(:,:,:)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;;;;;;;;;; end of plot 850hPa wind speed ;;;;;;;;;;

;;;;;;;;;; plot 500hPa wind speed ;;;;;;;;;;
;    f = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "pi_wind_spd_mean_500hPa"
;    title_name = "PI wind speed mean 500hPa"
;    spd = f->SPD_500(:,:,:)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_his/month_mean.nc", "r")
;    wks_name = "his_wind_spd_mean_500hPa"
;    title_name = "HIS wind speed mean 500hPa"
;    spd = f->SPD_500(:,:,:)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_ghg/month_mean.nc", "r")
;    wks_name = "ghg_wind_spd_mean_500hPa"
;    title_name = "GHG wind speed mean 500hPa"
;    spd = f->SPD_500(:,:,:)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_nat/month_mean.nc", "r")
;    wks_name = "nat_wind_spd_mean_500hPa"
;    title_name = "NAT wind speed mean 500hPa"
;    spd = f->SPD_500(:,:,:)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;;;;;;;;;; end of plot 500hPa wind speed ;;;;;;;;;;

;;;;;;;;;; plot 300hPa wind speed ;;;;;;;;;;
;    f = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "pi_wind_spd_mean_300hPa"
;    title_name = "PI wind speed mean 300hPa"
;    spd = f->SPD_300(:,:,:)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_his/month_mean.nc", "r")
;    wks_name = "his_wind_spd_mean_300hPa"
;    title_name = "HIS wind speed mean 300hPa"
;    spd = f->SPD_300(:,:,:)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_ghg/month_mean.nc", "r")
;    wks_name = "ghg_wind_spd_mean_300hPa"
;    title_name = "GHG wind speed mean 300hPa"
;    spd = f->SPD_300(:,:,:)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f = addfile("../data_nat/month_mean.nc", "r")
;    wks_name = "nat_wind_spd_mean_300hPa"
;    title_name = "NAT wind speed mean 300hPa"
;    spd = f->SPD_300(:,:,:)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;;;;;;;;;; end of plot 300hPa wind speed ;;;;;;;;;;






;;;;;;;;;; plot 10m wind speed diff ;;;;;;;;;;
;    f_1 = addfile("../data_his/month_mean.nc", "r")
;    f_2 = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "his_pi_diff_wind_spd_mean_10m"
;    title_name = "HIS PI diff wind speed mean 10m"
;    spd_1 = f_1->SPD10(:,:,:)
;    spd_2 = f_2->SPD10(:,:,:)
;    spd = spd_1 - spd_2
;    copy_VarMeta(spd_1, spd)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f_1 = addfile("../data_ghg/month_mean.nc", "r")
;    f_2 = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "ghg_pi_diff_wind_spd_mean_10m"
;    title_name = "GHG PI diff wind speed mean 10m"
;    spd_1 = f_1->SPD10(:,:,:)
;    spd_2 = f_2->SPD10(:,:,:)
;    spd = spd_1 - spd_2
;    copy_VarMeta(spd_1, spd)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f_1 = addfile("../data_nat/month_mean.nc", "r")
;    f_2 = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "nat_pi_diff_wind_spd_mean_10m"
;    title_name = "NAT PI diff wind speed mean 10m"
;    spd_1 = f_1->SPD10(:,:,:)
;    spd_2 = f_2->SPD10(:,:,:)
;    spd = spd_1 - spd_2
;    copy_VarMeta(spd_1, spd)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f_1 = addfile("../data_his/month_mean.nc", "r")
;    f_2 = addfile("../data_nat/month_mean.nc", "r")
;    wks_name = "his_nat_diff_wind_spd_mean_10m"
;    title_name = "HIS NAT diff wind speed mean 10m"
;    spd_1 = f_1->SPD10(:,:,:)
;    spd_2 = f_2->SPD10(:,:,:)
;    spd = spd_1 - spd_2
;    copy_VarMeta(spd_1, spd)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f_1 = addfile("../data_his/month_mean.nc", "r")
;    f_2 = addfile("../data_ghg/month_mean.nc", "r")
;    wks_name = "his_ghg_diff_wind_spd_mean_10m"
;    title_name = "HIS GHG diff wind speed mean 10m"
;    spd_1 = f_1->SPD10(:,:,:)
;    spd_2 = f_2->SPD10(:,:,:)
;    spd = spd_1 - spd_2
;    copy_VarMeta(spd_1, spd)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;;;;;;;;;; end of plot 10m wind speed diff ;;;;;;;;;;

;;;;;;;;;; plot 850hPa wind speed diff ;;;;;;;;;;
;    f_1 = addfile("../data_his/month_mean.nc", "r")
;    f_2 = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "his_pi_diff_wind_spd_mean_850hPa"
;    title_name = "HIS PI diff wind speed mean 850hPa"
;    spd_1 = f_1->SPD_850(:,:,:)
;    spd_2 = f_2->SPD_850(:,:,:)
;    spd = spd_1 - spd_2
;    copy_VarMeta(spd_1, spd)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f_1 = addfile("../data_ghg/month_mean.nc", "r")
;    f_2 = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "ghg_pi_diff_wind_spd_mean_850hPa"
;    title_name = "GHG PI diff wind speed mean 850hPa"
;    spd_1 = f_1->SPD_850(:,:,:)
;    spd_2 = f_2->SPD_850(:,:,:)
;    spd = spd_1 - spd_2
;    copy_VarMeta(spd_1, spd)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f_1 = addfile("../data_nat/month_mean.nc", "r")
;    f_2 = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "nat_pi_diff_wind_spd_mean_850hPa"
;    title_name = "NAT PI diff wind speed mean 850hPa"
;    spd_1 = f_1->SPD_850(:,:,:)
;    spd_2 = f_2->SPD_850(:,:,:)
;    spd = spd_1 - spd_2
;    copy_VarMeta(spd_1, spd)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f_1 = addfile("../data_his/month_mean.nc", "r")
;    f_2 = addfile("../data_nat/month_mean.nc", "r")
;    wks_name = "his_nat_diff_wind_spd_mean_850hPa"
;    title_name = "HIS NAT diff wind speed mean 850hPa"
;    spd_1 = f_1->SPD_850(:,:,:)
;    spd_2 = f_2->SPD_850(:,:,:)
;    spd = spd_1 - spd_2
;    copy_VarMeta(spd_1, spd)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;
;    f_1 = addfile("../data_his/month_mean.nc", "r")
;    f_2 = addfile("../data_ghg/month_mean.nc", "r")
;    wks_name = "his_ghg_diff_wind_spd_mean_850hPa"
;    title_name = "HIS GHG diff wind speed mean 850hPa"
;    spd_1 = f_1->SPD_850(:,:,:)
;    spd_2 = f_2->SPD_850(:,:,:)
;    spd = spd_1 - spd_2
;    copy_VarMeta(spd_1, spd)
;    spd_mean = dim_avg_n_Wrap(spd, 0)
;    subroutine(spd_mean, "16years", wks_name, title_name)
;;;;;;;;;; end of plot 850hPa wind speed diff ;;;;;;;;;;

;;;;;;;;;; plot 500hPa wind speed diff ;;;;;;;;;;
    f_1 = addfile("../data_his/month_mean.nc", "r")
    f_2 = addfile("../data_pi/month_mean.nc", "r")
    wks_name = "his_pi_diff_wind_spd_mean_500hPa"
    title_name = "HIS PI diff wind speed mean 500hPa"
    spd_1 = f_1->SPD_500(:,:,:)
    spd_2 = f_2->SPD_500(:,:,:)
    spd = spd_1 - spd_2
    copy_VarMeta(spd_1, spd)
    spd_mean = dim_avg_n_Wrap(spd, 0)
    subroutine(spd_mean, "16years", wks_name, title_name)

    f_1 = addfile("../data_ghg/month_mean.nc", "r")
    f_2 = addfile("../data_pi/month_mean.nc", "r")
    wks_name = "ghg_pi_diff_wind_spd_mean_500hPa"
    title_name = "GHG PI diff wind speed mean 500hPa"
    spd_1 = f_1->SPD_500(:,:,:)
    spd_2 = f_2->SPD_500(:,:,:)
    spd = spd_1 - spd_2
    copy_VarMeta(spd_1, spd)
    spd_mean = dim_avg_n_Wrap(spd, 0)
    subroutine(spd_mean, "16years", wks_name, title_name)

    f_1 = addfile("../data_nat/month_mean.nc", "r")
    f_2 = addfile("../data_pi/month_mean.nc", "r")
    wks_name = "nat_pi_diff_wind_spd_mean_500hPa"
    title_name = "NAT PI diff wind speed mean 500hPa"
    spd_1 = f_1->SPD_500(:,:,:)
    spd_2 = f_2->SPD_500(:,:,:)
    spd = spd_1 - spd_2
    copy_VarMeta(spd_1, spd)
    spd_mean = dim_avg_n_Wrap(spd, 0)
    subroutine(spd_mean, "16years", wks_name, title_name)

    f_1 = addfile("../data_his/month_mean.nc", "r")
    f_2 = addfile("../data_nat/month_mean.nc", "r")
    wks_name = "his_nat_diff_wind_spd_mean_500hPa"
    title_name = "HIS NAT diff wind speed mean 500hPa"
    spd_1 = f_1->SPD_500(:,:,:)
    spd_2 = f_2->SPD_500(:,:,:)
    spd = spd_1 - spd_2
    copy_VarMeta(spd_1, spd)
    spd_mean = dim_avg_n_Wrap(spd, 0)
    subroutine(spd_mean, "16years", wks_name, title_name)

    f_1 = addfile("../data_his/month_mean.nc", "r")
    f_2 = addfile("../data_ghg/month_mean.nc", "r")
    wks_name = "his_ghg_diff_wind_spd_mean_500hPa"
    title_name = "HIS GHG diff wind speed mean 500hPa"
    spd_1 = f_1->SPD_500(:,:,:)
    spd_2 = f_2->SPD_500(:,:,:)
    spd = spd_1 - spd_2
    copy_VarMeta(spd_1, spd)
    spd_mean = dim_avg_n_Wrap(spd, 0)
    subroutine(spd_mean, "16years", wks_name, title_name)
;;;;;;;;;; end of plot 500hPa wind speed diff ;;;;;;;;;;

;;;;;;;;;; plot 300hPa wind speed diff ;;;;;;;;;;
    f_1 = addfile("../data_his/month_mean.nc", "r")
    f_2 = addfile("../data_pi/month_mean.nc", "r")
    wks_name = "his_pi_diff_wind_spd_mean_300hPa"
    title_name = "HIS PI diff wind speed mean 300hPa"
    spd_1 = f_1->SPD_300(:,:,:)
    spd_2 = f_2->SPD_300(:,:,:)
    spd = spd_1 - spd_2
    copy_VarMeta(spd_1, spd)
    spd_mean = dim_avg_n_Wrap(spd, 0)
    subroutine(spd_mean, "16years", wks_name, title_name)

    f_1 = addfile("../data_ghg/month_mean.nc", "r")
    f_2 = addfile("../data_pi/month_mean.nc", "r")
    wks_name = "ghg_pi_diff_wind_spd_mean_300hPa"
    title_name = "GHG PI diff wind speed mean 300hPa"
    spd_1 = f_1->SPD_300(:,:,:)
    spd_2 = f_2->SPD_300(:,:,:)
    spd = spd_1 - spd_2
    copy_VarMeta(spd_1, spd)
    spd_mean = dim_avg_n_Wrap(spd, 0)
    subroutine(spd_mean, "16years", wks_name, title_name)

    f_1 = addfile("../data_nat/month_mean.nc", "r")
    f_2 = addfile("../data_pi/month_mean.nc", "r")
    wks_name = "nat_pi_diff_wind_spd_mean_300hPa"
    title_name = "NAT PI diff wind speed mean 300hPa"
    spd_1 = f_1->SPD_300(:,:,:)
    spd_2 = f_2->SPD_300(:,:,:)
    spd = spd_1 - spd_2
    copy_VarMeta(spd_1, spd)
    spd_mean = dim_avg_n_Wrap(spd, 0)
    subroutine(spd_mean, "16years", wks_name, title_name)

    f_1 = addfile("../data_his/month_mean.nc", "r")
    f_2 = addfile("../data_nat/month_mean.nc", "r")
    wks_name = "his_nat_diff_wind_spd_mean_300hPa"
    title_name = "HIS NAT diff wind speed mean 300hPa"
    spd_1 = f_1->SPD_300(:,:,:)
    spd_2 = f_2->SPD_300(:,:,:)
    spd = spd_1 - spd_2
    copy_VarMeta(spd_1, spd)
    spd_mean = dim_avg_n_Wrap(spd, 0)
    subroutine(spd_mean, "16years", wks_name, title_name)

    f_1 = addfile("../data_his/month_mean.nc", "r")
    f_2 = addfile("../data_ghg/month_mean.nc", "r")
    wks_name = "his_ghg_diff_wind_spd_mean_300hPa"
    title_name = "HIS GHG diff wind speed mean 300hPa"
    spd_1 = f_1->SPD_300(:,:,:)
    spd_2 = f_2->SPD_300(:,:,:)
    spd = spd_1 - spd_2
    copy_VarMeta(spd_1, spd)
    spd_mean = dim_avg_n_Wrap(spd, 0)
    subroutine(spd_mean, "16years", wks_name, title_name)
;;;;;;;;;; end of plot 300hPa wind speed diff ;;;;;;;;;;














;;;;;;;;;; calculate monthly wind speed ;;;;;;;;;;
;    f = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "pi_wind_spd"
;    title_name = "PI wind speed "
;    spd = f->SPD10(:,:,:)
;    subroutine(spd, "16years", wks_name, title_name)
;
;    f = addfile("../data_his/month_mean.nc", "r")
;    wks_name = "his_wind_spd"
;    title_name = "HIS wind speed "
;    spd = f->SPD10(:,:,:)
;    subroutine(spd, "16years", wks_name, title_name)
;
;    f = addfile("../data_ghg/month_mean.nc", "r")
;    wks_name = "ghg_wind_spd"
;    title_name = "GHG wind speed "
;    spd = f->SPD10(:,:,:)
;    subroutine(spd, "16years", wks_name, title_name)
;
;    f = addfile("../data_nat/month_mean.nc", "r")
;    wks_name = "nat_wind_spd"
;    title_name = "NAT wind speed "
;    spd = f->SPD10(:,:,:)
;    subroutine(spd, "16years", wks_name, title_name)
;
;    f_1 = addfile("../data_nat/month_mean.nc", "r")
;    f_2 = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "nat_pi_diff_wind_spd"
;    title_name = "NAT PI diff wind speed "
;    spd_1 = f_1->SPD10(:,:,:)
;    spd_2 = f_2->SPD10(:,:,:)
;    Times = f_1->Times(:,:)
;    spd = spd_1 - spd_2
;    copy_VarMeta(spd_1, spd)
;    subroutine(spd, Times, wks_name, title_name)
;
;    f_1 = addfile("../data_ghg/month_mean.nc", "r")
;    f_2 = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "ghg_pi_diff_wind_spd"
;    title_name = "GHG PI diff wind speed "
;    spd_1 = f_1->SPD10(:,:,:)
;    spd_2 = f_2->SPD10(:,:,:)
;    Times = f_1->Times(:,:)
;    spd = spd_1 - spd_2
;    copy_VarMeta(spd_1, spd)
;    subroutine(spd,Times, wks_name, title_name)
;
;    f_1 = addfile("../data_his/month_mean.nc", "r")
;    f_2 = addfile("../data_pi/month_mean.nc", "r")
;    wks_name = "his_pi_diff_wind_spd"
;    title_name = "HIS PI diff wind speed "
;    spd_1 = f_1->SPD10(:,:,:)
;    spd_2 = f_2->SPD10(:,:,:)
;    Times = f_1->Times(:,:)
;    spd = spd_1 - spd_2
;    copy_VarMeta(spd_1, spd)
;    subroutine(spd, Times, wks_name, title_name)
;
;    f_1 = addfile("../data_his/month_mean.nc", "r")
;    f_2 = addfile("../data_nat/month_mean.nc", "r")
;    wks_name = "his_nat_diff_wind_spd"
;    title_name = "HIS NAT diff wind speed "
;    spd_1 = f_1->SPD10(:,:,:)
;    spd_2 = f_2->SPD10(:,:,:)
;    Times = f_1->Times(:,:)
;    spd = spd_1 - spd_2
;    copy_VarMeta(spd_1, spd)
;    subroutine(spd, Times, wks_name, title_name)
;
;    f_1 = addfile("../data_his/month_mean.nc", "r")
;    f_2 = addfile("../data_ghg/month_mean.nc", "r")
;    wks_name = "his_ghg_diff_wind_spd"
;    title_name = "HIS GHG diff wind speed "
;    spd_1 = f_1->SPD10(:,:,:)
;    spd_2 = f_2->SPD10(:,:,:)
;    Times = f_1->Times(:,:)
;    spd = spd_1 - spd_2
;    copy_VarMeta(spd_1, spd)
;    subroutine(spd, Times, wks_name, title_name)
end

