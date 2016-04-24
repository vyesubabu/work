#!/usr/bin/env python3 

import sys,os
data_path = '../data/' # remember put '/' in the end
file_list=[]
time_list=['19810101-19851231',
        '19860101-19901231',
        '19910101-19951231',
        '19960101-20001231']

for i in time_list:
    file_list.append(['sic_day_GFDL-ESM2M_historicalGHG_r1i1p1_'+i+'.nc',
        'sic_day_GFDL-ESM2M_historicalGHG_r1i1p1_'+i+'_regrid.nc'])
    file_list.append(['sic_day_GFDL-ESM2M_historicalNat_r1i1p1_'+i+'.nc',
        'sic_day_GFDL-ESM2M_historicalNat_r1i1p1_'+i+'_regrid.nc'])
    file_list.append(['sic_day_GFDL-ESM2M_historical_r1i1p1_'+i+'.nc',
        'sic_day_GFDL-ESM2M_historical_r1i1p1_'+i+'_regrid.nc'])

    file_list.append(['tos_day_GFDL-ESM2M_historicalGHG_r1i1p1_'+i+'.nc',
        'tos_day_GFDL-ESM2M_historicalGHG_r1i1p1_'+i+'_regrid.nc'])
    file_list.append(['tos_day_GFDL-ESM2M_historicalNat_r1i1p1_'+i+'.nc',
        'tos_day_GFDL-ESM2M_historicalNat_r1i1p1_'+i+'_regrid.nc'])
    file_list.append(['tos_day_GFDL-ESM2M_historical_r1i1p1_'+i+'.nc',
        'tos_day_GFDL-ESM2M_historical_r1i1p1_'+i+'_regrid.nc'])

for i in file_list:
    os.system('cdo remapbil,mygrid '+data_path+i[0]+' '+data_path+i[1])
    #print('cdo remapbil,mygrid '+data_path+i[0]+' '+data_path+i[1])
