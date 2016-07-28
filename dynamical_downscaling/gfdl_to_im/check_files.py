#!/usr/bin/env python3
import os

if __name__ == '__main__':
    data_path = '../data/'
    filelist = os.listdir('../data')
    with open('./filelist', 'r') as f:
        for i in [x.strip() for x in f.readlines()]:
            if i not in filelist:
                print(i)
