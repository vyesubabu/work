#!/usr/bin/env python3
import os
from run_ncl import run_ncl

data_path = '../data/' # remember put '/' in the end
time_list = [
        ['1981010100-1985123123','19810101-19851231','198101-198512'],
        ['1986010100-1990123123','19860101-19901231','198601-199012'],
        ['1991010100-1995123123','19910101-19951231','199101-199512'],
        ['1996010100-2000123123','19960101-20001231','199601-200012'],
        ]

case_list = ['GHG','NAT','HIS']
for case in case_list:
    if case == 'HIS':
        case_file = '' # each case in the file name
    elif case == 'NAT':
        case_file = 'Nat'
    else:
        case_file = case
    root_name   = 'GFDL_CMIP5_'+case
    out_dir     = 'OUTPUT_'+case
    for t in time_list:
        hus_file    = data_path+'hus_6hrLev_GFDL-ESM2M_historical'+case_file+'_r1i1p1_'+t[0]+'.nc' 
        ta_file     = data_path+'ta_6hrLev_GFDL-ESM2M_historical'+case_file+'_r1i1p1_'+t[0]+'.nc' 
        ua_file     = data_path+'ua_6hrLev_GFDL-ESM2M_historical'+case_file+'_r1i1p1_'+t[0]+'.nc' 
        va_file     = data_path+'va_6hrLev_GFDL-ESM2M_historical'+case_file+'_r1i1p1_'+t[0]+'.nc' 
        ps_file     = data_path+'ps_6hrLev_GFDL-ESM2M_historical'+case_file+'_r1i1p1_'+t[0]+'.nc' 
        huss_file   = data_path+'huss_3hr_GFDL-ESM2M_historical'+case_file+'_r1i1p1_'+t[0]+'.nc' 
        tas_file    = data_path+'tas_3hr_GFDL-ESM2M_historical'+case_file+'_r1i1p1_'+t[0]+'.nc' 
        uas_file    = data_path+'uas_3hr_GFDL-ESM2M_historical'+case_file+'_r1i1p1_'+t[0]+'.nc' 
        vas_file    = data_path+'vas_3hr_GFDL-ESM2M_historical'+case_file+'_r1i1p1_'+t[0]+'.nc' 
        mrlsl_file  = data_path+'mrlsl_Lmon_GFDL-ESM2M_historical'+case_file+'_r1i1p1_'+t[2]+'.nc' 
        tsl_file    = data_path+'tsl_Lmon_GFDL-ESM2M_historical'+case_file+'_r1i1p1_'+t[2]+'.nc' 
        tos_file    = data_path+'tos_day_GFDL-ESM2M_historical'+case_file+'_r1i1p1_'+t[1]+'_regrid.nc' 
        ts_file     = data_path+'ts_Amon_GFDL-ESM2M_historical'+case_file+'_r1i1p1_'+t[2]+'.nc' 
        snw_file    = data_path+'snw_LImon_GFDL-ESM2M_historical'+case_file+'_r1i1p1_'+t[2]+'.nc' 
        sic_file    = data_path+'sic_day_GFDL-ESM2M_historical'+case_file+'_r1i1p1_'+t[1]+'_regrid.nc' 
        orog_file   = data_path+'orog_fx_GFDL-ESM2M_historical'+case_file+'_r0i0p0.nc' 
        sftlf_file  = data_path+'sftlf_fx_GFDL-ESM2M_historical'+case_file+'_r0i0p0.nc' 
        
        ntime_s_6h   = 0
        ntime_e_6h   = 0
        ntime_s_3h   = 0
        ntime_e_3h   = 0
        ntime_s_day  = 0
        ntime_e_day  = 0
        ntime_s_mon  = 0
        ntime_e_mon  = 0
        
        ndays = [31,28,31,30,31,30,31,31,30,31,30,31,\
                31,28,31,30,31,30,31,31,30,31,30,31,\
                31,28,31,30,31,30,31,31,30,31,30,31,\
                31,28,31,30,31,30,31,31,30,31,30,31,\
                31,28,31,30,31,30,31,31,30,31,30,31]
        for i in ndays:
            ntime_s_6h = ntime_e_6h + 1
            ntime_e_6h = ntime_e_6h + i*4 
            ntime_s_3h = ntime_e_3h + 1
            ntime_e_3h = ntime_e_3h + i*8
            ntime_s_day = ntime_e_day + 1
            ntime_e_day = ntime_e_day + i
            ntime_s_mon = ntime_e_mon + 1
            ntime_e_mon = ntime_s_mon
            run_ncl(case,root_name,out_dir,ntime_s_6h,ntime_e_6h,ntime_s_3h,ntime_e_3h,\
                    ntime_s_day,ntime_e_day,ntime_s_mon,ntime_e_mon,\
                    hus_file,ta_file,ua_file,va_file,ps_file,huss_file,tas_file,uas_file,vas_file,\
                    mrlsl_file,tsl_file,tos_file,ts_file,snw_file,sic_file,orog_file,sftlf_file,)
