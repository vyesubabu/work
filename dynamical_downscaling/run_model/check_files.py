#!/usr/bin/env python3 
from advancetime_noleap import process_time
import os

if __name__ == '__main__':
    files_dir = './output_ghg'
    begin_date = '1984010106'
    end_date = '2000010106'
    curr_date = begin_date

    while True:
        if not os.path.isfile(os.path.join(files_dir, 'wrfout_d01_' + process_time(['null', curr_date, '0', 'w']))):
            print(curr_date)
        curr_date = process_time(['null', curr_date, '6'])
        if curr_date == end_date:
            break
