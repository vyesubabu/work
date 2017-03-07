load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "./output_month_mean.ncl"

begin

    DateStrLen  = 7
    month_curr_char = stringtocharacter(month_curr)
    month_curr_out = new((/1, DateStrLen/), "character")
    month_curr_out(0,:) = month_curr_char(0:6)
    month_curr_out!0 = "Time"
    month_curr_out!1 = "DateStrLen"
    delete_VarAtts(month_curr_out, -1)
    out_filename = case + "_" + "month_mean.nc"

    f = addfile(file_name, "r")
    xlat  = f->XLAT
    xlong = f->XLONG
    u10   = f->U10
    v10   = f->V10
    u_850 = f->U_850
    v_850 = f->V_850
    u_700 = f->U_700
    v_700 = f->V_700
    u_500 = f->U_500
    v_500 = f->V_500
    u_300 = f->U_300
    v_300 = f->V_300
    u_200 = f->U_200
    v_200 = f->V_200
    geo_850 = f->GEO_850
    geo_700 = f->GEO_700
    geo_500 = f->GEO_500
    geo_300 = f->GEO_300
    geo_200 = f->GEO_200

    spd10 = sqrt(u10^2 + v10^2)
    spd_850 = sqrt(u_850^2 + v_850^2)
    spd_700 = sqrt(u_700^2 + v_700^2)
    spd_500 = sqrt(u_500^2 + v_500^2)
    spd_300 = sqrt(u_300^2 + v_300^2)
    spd_200 = sqrt(u_200^2 + v_200^2)
    copy_VarMeta(u10, spd10)
    copy_VarMeta(u_850, spd_850)
    copy_VarMeta(u_700, spd_700)
    copy_VarMeta(u_500, spd_500)
    copy_VarMeta(u_300, spd_300)
    copy_VarMeta(u_200, spd_200)
    spd10@description = "10 meters wind speed"
    spd_850@description = "850hPa wind speed"
    spd_700@description = "700hPa wind speed"
    spd_500@description = "500hPa wind speed"
    spd_300@description = "300hPa wind speed"
    spd_200@description = "200hPa wind speed"
    
    xlat_out = xlat(0:0,:,:)
    xlong_out = xlong(0:0,:,:)
    u10_out = u10(0:0,:,:)
    v10_out = v10(0:0,:,:)
    spd10_out = spd10(0:0,:,:)
    u_850_out = u_850(0:0,:,:)
    v_850_out = v_850(0:0,:,:)
    u_700_out = u_700(0:0,:,:)
    v_700_out = v_700(0:0,:,:)
    u_500_out = u_500(0:0,:,:)
    v_500_out = v_500(0:0,:,:)
    u_300_out = u_300(0:0,:,:)
    v_300_out = v_300(0:0,:,:)
    u_200_out = u_200(0:0,:,:)
    v_200_out = v_200(0:0,:,:)
    geo_850_out = geo_850(0:0,:,:)
    geo_700_out = geo_700(0:0,:,:)
    geo_500_out = geo_500(0:0,:,:)
    geo_300_out = geo_300(0:0,:,:)
    geo_200_out = geo_200(0:0,:,:)
    spd_850_out = spd_850(0:0,:,:)
    spd_700_out = spd_700(0:0,:,:)
    spd_500_out = spd_500(0:0,:,:)
    spd_300_out = spd_300(0:0,:,:)
    spd_200_out = spd_200(0:0,:,:)

    xlat_out(0,:,:) = dim_avg_n_Wrap(xlat, 0)
    xlong_out(0,:,:) = dim_avg_n_Wrap(xlong, 0)
    u10_out(0,:,:) = dim_avg_n_Wrap(u10, 0)
    v10_out(0,:,:) = dim_avg_n_Wrap(v10, 0)
    spd10_out(0,:,:) = dim_avg_n_Wrap(spd10, 0)
    u_850_out(0,:,:) = dim_avg_n_Wrap(u_850, 0)
    v_850_out(0,:,:) = dim_avg_n_Wrap(v_850, 0)
    u_700_out(0,:,:) = dim_avg_n_Wrap(u_700, 0)
    v_700_out(0,:,:) = dim_avg_n_Wrap(v_700, 0)
    u_500_out(0,:,:) = dim_avg_n_Wrap(u_500, 0)
    v_500_out(0,:,:) = dim_avg_n_Wrap(v_500, 0)
    u_300_out(0,:,:) = dim_avg_n_Wrap(u_300, 0)
    v_300_out(0,:,:) = dim_avg_n_Wrap(v_300, 0)
    u_200_out(0,:,:) = dim_avg_n_Wrap(u_200, 0)
    v_200_out(0,:,:) = dim_avg_n_Wrap(v_200, 0)
    geo_850_out(0,:,:) = dim_avg_n_Wrap(geo_850, 0)
    geo_700_out(0,:,:) = dim_avg_n_Wrap(geo_700, 0)
    geo_500_out(0,:,:) = dim_avg_n_Wrap(geo_500, 0)
    geo_300_out(0,:,:) = dim_avg_n_Wrap(geo_300, 0)
    geo_200_out(0,:,:) = dim_avg_n_Wrap(geo_200, 0)
    spd_850_out(0,:,:) = dim_avg_n_Wrap(spd_850, 0)
    spd_700_out(0,:,:) = dim_avg_n_Wrap(spd_700, 0)
    spd_500_out(0,:,:) = dim_avg_n_Wrap(spd_500, 0)
    spd_300_out(0,:,:) = dim_avg_n_Wrap(spd_300, 0)
    spd_200_out(0,:,:) = dim_avg_n_Wrap(spd_200, 0)

    if (index .eq. 0) then
        first_output(out_filename, month_curr_out, DateStrLen, \
                 xlat_out, xlong_out, u10_out, v10_out, spd10_out,\
                 u_850_out, v_850_out, u_700_out, v_700_out, u_500_out, v_500_out,\
                 u_300_out, v_300_out, u_200_out, v_200_out,\
                 geo_850_out, geo_700_out, geo_500_out, geo_300_out, geo_200_out,\
                 spd_850_out, spd_700_out, spd_500_out, spd_300_out, spd_200_out)
    else
        add_output(out_filename, month_curr_out, index, \
                 xlat_out, xlong_out, u10_out, v10_out, spd10_out,\
                 u_850_out, v_850_out, u_700_out, v_700_out, u_500_out, v_500_out,\
                 u_300_out, v_300_out, u_200_out, v_200_out,\
                 geo_850_out, geo_700_out, geo_500_out, geo_300_out, geo_200_out,\
                 spd_850_out, spd_700_out, spd_500_out, spd_300_out, spd_200_out)
    end if

end
