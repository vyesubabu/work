#!/usr/bin/env python3 
from advancetime_noleap import process_time
import os

if __name__ == '__main__':
    ori_dir = '/home2_hn/xuwq/cases/pi'
    new_dir = './output_pi'
    begin_date = '1983123100'
    end_date = '2000123100'
    curr_date = begin_date

    while True:
        for f in ['wrfout_d01_'+process_time(['null', curr_date, t, 'w']) for t in [str(i) for i in range(30, 150, 6)]]:
            os.rename(os.path.join(ori_dir,curr_date,f), os.path.join(new_dir, f))
            if not os.path.isfile(os.path.join(ori_dir,curr_date,f)):
                print(os.path.join(ori_dir,curr_date,f))
        curr_date = process_time(['null', curr_date, '5d'])
        if curr_date == end_date:
            break
