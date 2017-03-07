#!/usr/bin/env python3
import os
import csv
import datetime
from classes import little_r

if __name__ == '__main__':
    stations = [
            ['1566', 112.304217, 21.768000, 450.0],
            ['1596', 112.308750, 21.826700, 355.0],
            ['2738', 112.208267, 21.783433, 390.0],
            ['3244', 111.985400, 22.144183, 610.0],
            ['4179', 112.268833, 21.792500, 543.0],
            ['4185', 112.076117, 22.109567, 828.0],
            ['4190', 112.334467, 21.843850, 392.0]
            ]
    with open('./little_r_out', 'w') as f_out:
        for station in stations:
            with open(station[0]+'.csv') as f_cft:
                for row in csv.reader(f_cft):
                    record = little_r()
                    record.date_char = datetime.datetime.strptime(row[0], '%Y_%m_%d_%H:%M:%S').strftime('%Y%m%d%H%M%S')
                    record.station_id = station[0]
                    record.latitude = float(station[2])
                    record.longitude = float(station[1])
                    record.elevation = float(station[3])
                    record.height = float(station[3])
                    record.speed = float(row[1])
                    record.direction = float(row[2])
                    record.print_head(f_out)
                    record.print_data(f_out)
                    record.print_data_end(f_out)
                    record.print_end(f_out)
