#!/usr/bin/env python3
import os

def move_file(ori_dir, new_dir):
    if not os.path.isdir(new_dir):
        os.mkdir(new_dir)
    if not os.path.isdir(ori_dir):
        return
    for i in [os.path.join(ori_dir, x) for x in os.listdir(ori_dir)]:
        if os.path.isdir(i):
            move_file(i, new_dir)
        else:
            os.rename(i, os.path.join(new_dir, os.path.split(i)[-1]))
    return

if __name__ == '__main__':
    ori_dir = '/home/xuwq/test_dir'
    new_dir = '/home/xuwq/new_dir'
    move_file(ori_dir, new_dir)
