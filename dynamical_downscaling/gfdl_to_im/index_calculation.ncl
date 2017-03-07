load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

undef("Eurasian_Zonal_Circulation_Index")
function Eurasian_Zonal_Circulation_Index(filename)
begin
    f = addfile(filename, "r")
    lat = f->lat
    lon = f->lon
    print(lat(67))
    print(lat(77))
    print(lon(0:11))
    print(lon(12:23))
    print(lon(24:35))
    print(lon(36:47))
    print(lon(48:59))

    z500 = f->Z500

    z_45_1 = z500(:,67,0:11)
    z_65_1 = z500(:,77,0:11)
    z_45_2 = z500(:,67,12:23)
    z_65_2 = z500(:,77,12:23)
    z_45_3 = z500(:,67,24:35)
    z_65_3 = z500(:,77,24:35)
    z_45_4 = z500(:,67,36:47)
    z_65_4 = z500(:,77,36:47)
    z_45_5 = z500(:,67,48:59)
    z_65_5 = z500(:,77,48:59)

    sum_45_1 = dim_sum_n_Wrap(z_45_1, 1)
    sum_65_1 = dim_sum_n_Wrap(z_65_1, 1)
    sum_45_2 = dim_sum_n_Wrap(z_45_2, 1)
    sum_65_2 = dim_sum_n_Wrap(z_65_2, 1)
    sum_45_3 = dim_sum_n_Wrap(z_45_3, 1)
    sum_65_3 = dim_sum_n_Wrap(z_65_3, 1)
    sum_45_4 = dim_sum_n_Wrap(z_45_4, 1)
    sum_65_4 = dim_sum_n_Wrap(z_65_4, 1)
    sum_45_5 = dim_sum_n_Wrap(z_45_5, 1)
    sum_65_5 = dim_sum_n_Wrap(z_65_5, 1)

    i_1 = (sum_45_1 - sum_65_1) / 12. * (65 - 45)
    i_2 = (sum_45_2 - sum_65_2) / 12. * (65 - 45)
    i_3 = (sum_45_3 - sum_65_3) / 12. * (65 - 45)
    i_4 = (sum_45_4 - sum_65_4) / 12. * (65 - 45)
    i_5 = (sum_45_5 - sum_65_5) / 12. * (65 - 45)

    i = (i_1 + i_2 + i_3 + i_4 + i_5) / 5.

    return i
end

undef("Eurasian_Meridional_Circulation_Index")
function Eurasian_Meridional_Circulation_Index(filename)
begin
    f = addfile(filename, "r")
    lat = f->lat
    lon = f->lon
    print(lat(67))
    print(lat(77))
    print(lon(0:11))
    print(lon(12:23))
    print(lon(24:35))
    print(lon(36:47))
    print(lon(48:59))
    pi = 3.141592653589793

    z500 = f->Z500
    dz_1 = z500(:,67:77,0:11)  - z500(:,66:76,0:11)
    dz_2 = z500(:,67:77,12:23) - z500(:,66:76,12:23)
    dz_3 = z500(:,67:77,24:35) - z500(:,66:76,24:35)
    dz_4 = z500(:,67:77,36:47) - z500(:,66:76,36:47)
    dz_5 = z500(:,67:77,48:59) - z500(:,66:76,48:59)
    dz_over_cos_phi_1 = todouble(dz_1)
    dz_over_cos_phi_2 = todouble(dz_2)
    dz_over_cos_phi_3 = todouble(dz_3)
    dz_over_cos_phi_4 = todouble(dz_4)
    dz_over_cos_phi_5 = todouble(dz_5)

    do i = 67,77
        dz_over_cos_phi_1(:,i-67:i-67,:) = dz_1(:,i-67:i-67,:) / cos(lat(i)*pi/180.)
        dz_over_cos_phi_2(:,i-67:i-67,:) = dz_2(:,i-67:i-67,:) / cos(lat(i)*pi/180.)
        dz_over_cos_phi_3(:,i-67:i-67,:) = dz_3(:,i-67:i-67,:) / cos(lat(i)*pi/180.)
        dz_over_cos_phi_4(:,i-67:i-67,:) = dz_4(:,i-67:i-67,:) / cos(lat(i)*pi/180.)
        dz_over_cos_phi_5(:,i-67:i-67,:) = dz_5(:,i-67:i-67,:) / cos(lat(i)*pi/180.)
    end do

    sum_1_1 = dim_sum_n_Wrap(dz_over_cos_phi_1, 2)
    sum_1_2 = dim_sum_n_Wrap(dz_over_cos_phi_2, 2)
    sum_1_3 = dim_sum_n_Wrap(dz_over_cos_phi_3, 2)
    sum_1_4 = dim_sum_n_Wrap(dz_over_cos_phi_4, 2)
    sum_1_5 = dim_sum_n_Wrap(dz_over_cos_phi_5, 2)

    sum_2_1 = dim_sum_n_Wrap(abs(sum_1_1), 1)
    sum_2_2 = dim_sum_n_Wrap(abs(sum_1_2), 1)
    sum_2_3 = dim_sum_n_Wrap(abs(sum_1_3), 1)
    sum_2_4 = dim_sum_n_Wrap(abs(sum_1_4), 1)
    sum_2_5 = dim_sum_n_Wrap(abs(sum_1_5), 1)

    index_1 = (1.0 / (12.0 * 11.0 * 15.0)) * sum_2_1
    index_2 = (1.0 / (12.0 * 11.0 * 15.0)) * sum_2_2
    index_3 = (1.0 / (12.0 * 11.0 * 15.0)) * sum_2_3
    index_4 = (1.0 / (12.0 * 11.0 * 15.0)) * sum_2_4
    index_5 = (1.0 / (12.0 * 11.0 * 15.0)) * sum_2_5


    return (index_1 + index_2 + index_3 + index_4 + index_5) / 5.0

end

begin
    ;filename = "./HIS500hPa_Z.nc"
    ;filename = "./GHG500hPa_Z.nc"
    ;filename = "./NAT500hPa_Z.nc"
    filename = "./PI500hPa_Z.nc"
    i_zonal = Eurasian_Zonal_Circulation_Index(filename)
    i_meridional = Eurasian_Meridional_Circulation_Index(filename)
    print(i_zonal)
    print(i_meridional)

end
