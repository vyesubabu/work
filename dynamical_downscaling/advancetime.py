#!/usr/bin/env python
import re
import sys
from datetime import datetime,timedelta

def advancetime(origin_date,dt=0,out_format='default'):
    patterns = {
            'YMD': r'^(\d{4})(\d{2})(\d{2})$',
            'YMDh': r'^(\d{4})(\d{2})(\d{2})(\d{2})$',
            'YMDhm': r'^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})$',
            'YMDhms': r'^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})$',
            'wrf': r'^(\d{4})-(\d{2})-(\d{2})_(\d{2})\:(\d{2})\:(\d{2})'
            }
    for fmt,pat in patterns.items():
        m =  re.match(pat,origin_date)
        if m:
            if fmt == 'YMD':
                ori_year,ori_month,ori_day,ori_hour,ori_minute,ori_second \
                        = m.group(1),m.group(2),m.group(3),'00','00','00'
                out_fmt = '%Y%m%d%H'
            elif fmt == 'YMDh':
                ori_year,ori_month,ori_day,ori_hour,ori_minute,ori_second \
                        = m.group(1),m.group(2),m.group(3),m.group(4),'00','00'
                out_fmt = '%Y%m%d%H'
            elif fmt == 'YMDhm':
                ori_year,ori_month,ori_day,ori_hour,ori_minute,ori_second \
                        = m.group(1),m.group(2),m.group(3),m.group(4),m.group(5),'00'
                out_fmt = '%Y%m%d%H%M'
            elif fmt == 'YMDhms':
                ori_year,ori_month,ori_day,ori_hour,ori_minute,ori_second \
                        = m.group(1),m.group(2),m.group(3),m.group(4),m.group(5),m.group(6)
                out_fmt = '%Y%m%d%H%M%S'
            else:
                ori_year,ori_month,ori_day,ori_hour,ori_minute,ori_second \
                        = m.group(1),m.group(2),m.group(3),m.group(4),m.group(5),m.group(6)
                out_fmt = '%Y-%m-%d_%H:%M:%S'
            break
    ori_datetime = datetime(int(ori_year), int(ori_month), int(ori_day), \
            int(ori_hour), int(ori_minute), int(ori_second))
    #print('input: ',origin_date)
    dt_day,dt_hour,dt_minute,dt_second = 0,0,0,0
    if re.match(r'^\w+$',dt):
        days = re.search(r'(\d+)d',dt)
        hours = re.search(r'(\d+)h',dt)
        minutes = re.search(r'(\d+)m',dt)
        seconds = re.search(r'(\d+)s',dt)
        hours_only = re.match(r'^(\d+)$',dt)
        if days:
            dt_day = int(days.group(1))
        if hours:
            dt_hour = int(hours.group(1))
        if minutes:
            dt_minute = int(minutes.group(1))
        if seconds:
            dt_second = int(seconds.group(1))
        if hours_only:
            dt_hour = int(hours_only.group(1))
    elif re.match(r'^-\w+$',dt):
        days = re.search(r'(\d+)d',dt)
        hours = re.search(r'(\d+)h',dt)
        minutes = re.search(r'(\d+)m',dt)
        seconds = re.search(r'(\d+)s',dt)
        hours_only = re.match(r'^-(\d+)$',dt)
        if days:
            dt_day = -int(days.group(1))
        if hours:
            dt_hour = -int(hours.group(1))
        if minutes:
            dt_minute = -int(minutes.group(1))
        if seconds:
            dt_second = -int(seconds.group(1))
        if hours_only:
            dt_hour = -int(hours_only.group(1))
    elif re.match(r'^\w+-\w+$',dt):
        dt_split = re.match(r'^(\w+)-(\w+)$',dt).group()
        days = re.search(r'(\d+)d',dt_split[1])
        hours = re.search(r'(\d+)h',dt_split[1])
        minutes = re.search(r'(\d+)m',dt_split[1])
        seconds = re.search(r'(\d+)s',dt_split[1])
        hours_only = re.match(r'^(\d+)$',dt_split[1])
        if days:
            dt_day = int(days.group(1))
        if hours:
            dt_hour = int(hours.group(1))
        if minutes:
            dt_minute = int(minutes.group(1))
        if seconds:
            dt_second = int(seconds.group(1))
        if hours_only:
            dt_hour = int(hours_only.group(1))
        days = re.search(r'(\d+)d',dt_split[2])
        hours = re.search(r'(\d+)h',dt_split[2])
        minutes = re.search(r'(\d+)m',dt_split[2])
        seconds = re.search(r'(\d+)s',dt_split[2])
        hours_only = re.match(r'^(\d+)$',dt_split[2])
        if days:
            dt_day = -int(days.group(1))
        if hours:
            dt_hour = -int(hours.group(1))
        if minutes:
            dt_minute = -int(minutes.group(1))
        if seconds:
            dt_second = -int(seconds.group(1))
        if hours_only:
            dt_hour = -int(hours_only.group(1))
    else:
        print('wrong dt')
    out_datetime = ori_datetime + timedelta(days=dt_day, hours=dt_hour,\
            minutes=dt_minute, seconds=dt_second)
    #print('output: ',out_datetime)
    if out_format == 'w':
        out_fmt = '%Y-%m-%d_%H:%M:%S'
    output_formated = out_datetime.strftime(out_fmt)
    #print('output: ',output_formated)
    #print(output_formated)
    return output_formated


if __name__=="__main__":
    if len(sys.argv) == 3:
        print(advancetime(str(sys.argv[1]),str(sys.argv[2])))
    elif len(sys.argv) == 4:
        print(advancetime(str(sys.argv[1]),str(sys.argv[2]),'w'))
    else:
        print('please input ')
#    advancetime('20160304','0')
#    advancetime('2016030412','0')
#    advancetime('201603041231','0')
#    advancetime('20160304123144','0')
#    advancetime('2016-03-04_12:31:45','0')
#    advancetime('2016030412','12')
#    advancetime('2016030412','-12')
#    advancetime('2016030412','-12h31s')
#    advancetime('2016030412','-12h31s','w')
