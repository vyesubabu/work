#!/usr/bin/env python3 
from advancetime import advancetime
import os

if __name__ == '__main__':
    ori_dir = './wrf_output'
    new_dir = './output'
    begin_date = '2012080112'
    end_date = '2012090112'
    curr_date = begin_date

    while True:
        for f in ['wrfout_d03_'+advancetime(curr_date, t, 'w') for t in [str(i) for i in range(13, 37)]]:
            os.rename(os.path.join(ori_dir,curr_date,f), os.path.join(new_dir, f))
        curr_date = advancetime(curr_date, '24')
        if curr_date == end_date:
            break
