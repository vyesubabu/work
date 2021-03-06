#!/usr/bin/env python

from datetime import datetime, timedelta
from calendar import monthrange
import sys
import os
import time
from multiprocessing import Pool

from advancetime_noleap import advancetime


def month_loop():
    out_fmt = '%Y-%m-%d_%H:%M:%S'
    time_begin = datetime(year=1984, month=1, day=1, hour=6)
    time_end   = datetime(year=2001, month=1, day=1, hour=0)
    time_curr = time_begin
    while True:
        time_next = time_curr + timedelta(days=monthrange(time_curr.year, time_curr.month)[1])
        yield [time_curr.strftime(out_fmt),\
                (time_next - timedelta(hours=6)).strftime(out_fmt)]
        time_curr = time_next
        if time_curr >= time_end: break

def hour_loop(time_begin, time_end):
    time_curr = time_begin
    while True:
        yield time_curr
        time_curr = advancetime(time_curr, dt='6')
        if time_curr == time_end: break
    yield time_end

def out_nc(case, time_begin, time_end):
    print('Run task from time %s (%s)...' % (time_begin, os.getpid()))
    start = time.time()
    index = 0
    file_name = './interpolated_data/' + case + '_' + time_begin + '_' + time_end + '.nc'
    for time_curr in hour_loop(time_begin, time_end):
        os.system("ncl interpolation.ncl 'case = \"%s\"' 'file_name = \"%s\"' 'time_curr = \"%s\"' 'index = %d'" \
                % (case, file_name, time_curr, index))
        index += 1
    end = time.time()
    print('Task runs %0.2f seconds.' % (time_begin, (end - start)))

def main():
    if not os.path.isdir('./interpolated_data'):
        print("doesn't exist interpolated data dir")
        os.mkdir('./interpolated_data')
    for case in ['his', 'ghg', 'nat', 'pi']:
        print('Parent process %s.' % os.getpid())
        p = Pool(32)  # the default parameter is the number of cpu in this computer
        for i, j in month_loop():
            p.apply_async(out_nc, args=(case, i, j))
        print('Waiting for all subprocesses done...')
        p.close()
        p.join()
        print('All subprocesses done.')

if __name__ == '__main__':
    main()

