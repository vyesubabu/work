#!/usr/bin/env python3
import os,sys
from advancetime import advancetime

if __name__ == '__main__':
    date_start = '2012010112'
    date_end   = '2012123012'
    date_curr = date_start
    while date_curr != date_end:
        os.system("ncl ./get_data_interp.ncl 'date = \"%s\"'" %date_curr)
        date_curr = advancetime(date_curr, '24')
