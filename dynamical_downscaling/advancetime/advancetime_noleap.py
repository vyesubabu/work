#!/usr/bin/env python3
import re
import sys
import calendar
from datetime import datetime, timedelta

def no_leap(func):
    def wrapper(*args, **kw):
        args_list = list(args)
        year = int(args_list[0][0:4]) 
        if calendar.isleap(year):
            args_list[0] = str(year + 1) + args_list[0][4:]
            ret = func(*args_list, **kw)
            return str(int(ret[0:4]) - 1) + ret[4:]
        else:
            return func(*args, **kw)
    return wrapper

@no_leap
def advancetime(origin_date, dt=0, out_format='default'):

    # first, we match the origin date
    patterns = {
            'YMD': r'^(\d{4})(\d{2})(\d{2})$',
            'YMDh': r'^(\d{4})(\d{2})(\d{2})(\d{2})$',
            'YMDhm': r'^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})$',
            'YMDhms': r'^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})$',
            'wrf': r'^(\d{4})-(\d{2})-(\d{2})_(\d{2})\:(\d{2})\:(\d{2})'
            }
    origin_date_dict = {
            'YMD': lambda m: [int(i) for i in [m.group(1), m.group(2), m.group(3)]],
            'YMDh': lambda m: [int(i) for i in [m.group(1),m.group(2),m.group(3),m.group(4)]],
            'YMDhm': lambda m: [int(i) for i in [m.group(1),m.group(2),m.group(3),m.group(4),m.group(5)]],
            'YMDhms': lambda m: [int(i) for i in [m.group(1),m.group(2),m.group(3),m.group(4),m.group(5),m.group(6)]] ,
            'wrf': lambda m: [int(i) for i in [m.group(1),m.group(2),m.group(3),m.group(4),m.group(5),m.group(6)]]
            }
    out_fmt_dict = {
            'YMD': '%Y%m%d%H',
            'YMDh': '%Y%m%d%H',
            'YMDhm': '%Y%m%d%H%M',
            'YMDhms': '%Y%m%d%H%M%S',
            'wrf': '%Y-%m-%d_%H:%M:%S'
            }
    for fmt, pat in patterns.items():
        m = re.match(pat, origin_date)
        if m:
            datetimeargs = origin_date_dict[fmt](m)
            out_fmt = out_fmt_dict[fmt]
            break
    if not m:
        print('there is no pattern match origin_date, please check')
    ori_datetime = datetime(*datetimeargs)

    # then, we match the dt
    posi_neg = dt.split('-') # split positive and negative part
    posi, neg = [posi_neg[0], ''] if len(posi_neg) == 1 else [posi_neg[0], posi_neg[1]] 
#    day_hour_minute_second_honly 
    dhmsho = [[r'(\d+)d', 0], [r'(\d+)h', 0], [r'(\d+)m', 0], [r'(\d+)s', 0], [r'^(\d+)$', 0]]
    for index, item in enumerate(dhmsho):
        mat = re.search(item[0], posi)
        if mat: dhmsho[index][1] += int(mat.group(1))
        mat = re.search(item[0], neg)
        if mat: dhmsho[index][1] -= int(mat.group(1))
    out_datetime = ori_datetime + timedelta(\
            days=dhmsho[0][1], hours=dhmsho[1][1]+dhmsho[4][1], \
            minutes=dhmsho[2][1], seconds=dhmsho[3][1])
    if out_format == 'w':
        out_fmt = '%Y-%m-%d_%H:%M:%S'
    output_formated = out_datetime.strftime(out_fmt)
    return output_formated


if __name__=="__main__":
    if len(sys.argv) == 3:
        print(advancetime(str(sys.argv[1]),str(sys.argv[2])))
    elif len(sys.argv) == 4:
        print(advancetime(str(sys.argv[1]),str(sys.argv[2]),'w'))
    else:
        print('please input ')

