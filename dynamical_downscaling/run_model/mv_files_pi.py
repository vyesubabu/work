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
        for f in [process_time(['null', curr_date, t]) for t in [str(i) for i in range(30, 150, 6)]]:
            year = '%04d' %(int(f[0:4]) - 1500)
            file_name = 'wrfout_d01_' + year + '-' + f[4:6] + '-' + f[6:8] + '_' + f[8:] + ':00:00'
            os.rename(os.path.join(ori_dir,curr_date,file_name), os.path.join(new_dir, file_name))
            if not os.path.isfile(os.path.join(ori_dir,curr_date,file_name)):
                print(os.path.join(ori_dir,curr_date,file_name))
        curr_date = process_time(['null', curr_date, '5d'])
        if curr_date == end_date:
            break
