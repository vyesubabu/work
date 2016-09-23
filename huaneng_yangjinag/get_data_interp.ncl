load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin
    time_soft = "/home2_hn/xuwq/github/work/huaneng_yangjinag/advancetime.py "
    date_begin = systemfunc(time_soft+date+" 12"+" -w")
    date_end   = systemfunc(time_soft+date+" 36"+" -w")
    date_wrf = systemfunc(time_soft+date+" 0"+" -w")
    wrfout = "/home2_hn/xuwq/cases/huaneng_2012/wrf_output/"+date+"/wrfout_d03_"+date_wrf
    f = addfile(wrfout,"r")
    times = wrf_user_getvar(f,"times",-1)
    lat2d = wrf_user_getvar(f,"lat",0)
    lon2d = wrf_user_getvar(f,"lon",0)
    ntimes = dimsizes(times)
    it_begin = 0
    it_end   = 0
    do it =0,ntimes-1
        if (times(it) .eq. date_begin) then
            it_begin = it
        end if
        if (times(it) .eq. date_end) then
            it_end   = it
        end if
    end do
    nit = it_end - it_begin + 1
    
    lon1 = 111.4966306
    lat1 = 21.34285833
    lon2 = 111.5239861
    lat2 = 21.23899722
    
    height_levels = (/25., 30., 50., 70., 90./)
    nlevels = dimsizes(height_levels)
    spd_list_1 = new((/nit,nlevels/),float)
    dir_list_1 = new((/nit,nlevels/),float)
    spd_list_2 = new((/nit,nlevels/),float)
    dir_list_2 = new((/nit,nlevels/),float)

    opt = 2

    do it = it_begin,it_end
        print("processing time "+times(it))
        uvmet = wrf_user_getvar(f,"uvmet",it)
        umet  = uvmet(0,:,:,:)
        vmet  = uvmet(1,:,:,:)
        model_hgt    = wrf_user_getvar(f,"HGT",it)
        model_height = wrf_user_getvar(f,"height",it)
        z = model_height-conform(model_height,model_hgt,(/1,2/))
        do level = 0,nlevels-1
            height = height_levels(level)
            u_plane  = wrf_user_intrp3d(umet,z,"h",height,0.,False)
            v_plane  = wrf_user_intrp3d(vmet,z,"h",height,0.,False)
            u_1 = rcm2points_Wrap(lat2d,lon2d,u_plane,lat1,lon1,opt)
            v_1 = rcm2points_Wrap(lat2d,lon2d,v_plane,lat1,lon1,opt)
            u_2 = rcm2points_Wrap(lat2d,lon2d,u_plane,lat2,lon2,opt)
            v_2 = rcm2points_Wrap(lat2d,lon2d,v_plane,lat2,lon2,opt)
            spd_list_1(it-it_begin,level) = sqrt(u_1^2+v_1^2)
            dir_list_1(it-it_begin,level) = wind_direction(u_1,v_1,0)
            spd_list_2(it-it_begin,level) = sqrt(u_2^2+v_2^2)
            dir_list_2(it-it_begin,level) = wind_direction(u_2,v_2,0)
        end do
        uvmet10 = wrf_user_getvar(f,"uvmet10",it)
        u_1 = rcm2points_Wrap(lat2d,lon2d,uvmet10(0,:,:),lat1,lon1,opt)
        v_1 = rcm2points_Wrap(lat2d,lon2d,uvmet10(1,:,:),lat1,lon1,opt)
        u_2 = rcm2points_Wrap(lat2d,lon2d,uvmet10(0,:,:),lat2,lon2,opt)
        v_2 = rcm2points_Wrap(lat2d,lon2d,uvmet10(1,:,:),lat2,lon2,opt)
        spd_list_1(it-it_begin,0) = sqrt(u_1^2+v_1^2)
        dir_list_1(it-it_begin,0) = wind_direction(u_1,v_1,0)
        spd_list_2(it-it_begin,0) = sqrt(u_2^2+v_2^2)
        dir_list_2(it-it_begin,0) = wind_direction(u_2,v_2,0)
    end do
    
    time_list = times(it_begin:it_end)

    file_name = date_begin + "_" + date_end
    data_list = [/time_list,spd_list_1(:,0),dir_list_1(:,0),\
                            spd_list_1(:,1),dir_list_1(:,1),\
                            spd_list_1(:,2),dir_list_1(:,2),\
                            spd_list_1(:,3),dir_list_1(:,3),\
                            spd_list_1(:,4),dir_list_1(:,4),\
                            spd_list_2(:,0),dir_list_2(:,0),\
                            spd_list_2(:,1),dir_list_2(:,1),\
                            spd_list_2(:,2),dir_list_2(:,2),\
                            spd_list_2(:,3),dir_list_2(:,3),\
                            spd_list_2(:,4),dir_list_2(:,4)/]
    format = "%s %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f " + \
                "%.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f "
    write_table(file_name,"w",data_list,format)
end
