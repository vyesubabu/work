#!/usr/bin/env python3 
import os

if __name__ == '__main__':
    os.system('showq | grep xuwq > job_list')
    with open('job_list', 'r') as list_file:
        for line in list_file.readlines():
            os.system('qdel %s' %line.strip().split()[0])
