#!/usr/bin/env python

import os
from interpolation import month_loop

def main():
    for case in ['his', 'ghg', 'nat', 'pi']:
        index = 0
        for time_begin, time_end in month_loop():
            file_name = './interpolated_data/' + case + '_' + time_begin + '_' + time_end + '.nc'
            month_curr = time_begin[0:10]
            os.system("ncl calc_month_ave.ncl 'case = \"%s\"' 'file_name = \"%s\"' 'month_curr = \"%s\"' 'index = %d'" \
                    % (case, file_name, month_curr, index))
            index += 1

if __name__ == '__main__':
    main()

