#!/usr/bin/env python3 
import os
from advancetime import advancetime

if __name__ == '__main__':
    date_start = '2012010200'
    date_end = '2012123100'
    date_curr = date_start

    while True:
        if not os.path.isfile(os.path.join('./varout', 'varout_' + advancetime(date_curr, '0', 'w'))):
            print(date_curr)
        date_curr = advancetime(date_curr, '1')
        if date_curr == date_end:
            break
