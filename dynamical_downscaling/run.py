#!/usr/bin/env python3
import os,sys
from datetime import datetime, timedelta

def run_real(date_start, run_days, run_hours,\
        namelist_file, met_dir, real_out_dir):
    pass

def run_wrf(wrf_out_dir):
    os.chdir(wrf_out_dir)
    print('running wrf, please see wrf.output')

def main():
    case_name = 'his'
    general_format, wrf_format = '%Y%m%d%H', '%Y_%m_%d_%H:%M:%S'
    date_start = datetime.strptime('1983123100', general_format)
    date_end = datetime.strptime('1984123100', general_format)
    time_interval = 120
    run_days, run_hours = '6', '00'
    namelist_dir = '/home2_hn/xuwq/github/work/dynamical_downscaling'
    met_dir = '/home2_hn/xuwq/no_leap_year/WPS_HIS'
    case_dir = os.path.join('/home2_hn/xuwq/cases', case_name)

    date_curr = date_start
    while date_curr <= date_end:
        print(' processing date:', date_curr.strftime(wrf_format))
        date_curr += timedelta(hours=time_interval)

if __name__ == '__main__':
    main()
