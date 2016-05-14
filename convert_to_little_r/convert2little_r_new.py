#!/usr/bin/env python3
import math
from classes_new import *

# input startion file
station_in = []
with open("station",'r') as station_file:
    for line in station_file :
        station_in.append(line.split())

# input observation data
obs_in = []
with open("./data_example",'r') as obs_file:
    for line in obs_file:
        obs_in.append(line.split())

obs_list = []
little_r_list = []

n_record = 0
for i in obs_in:
    for j in station_in:
        if(i[0] == j[0]):
            n_record = n_record + 1
            little_r_list.append(little_r())
            obs_list.append(observation())
            obs_list[-1].station_id_c   = i[0]
            obs_list[-1].lat            = float(j[1])
            obs_list[-1].lon            = float(j[2])
            obs_list[-1].pres_height    = float(j[3])
            obs_list[-1].station_height = float(j[4])
            obs_list[-1].year           = int(i[1])
            obs_list[-1].mon            = int(i[2])
            obs_list[-1].day            = int(i[3])
            obs_list[-1].hour           = int(i[4])
            obs_list[-1].prs            = float(i[5]) 
            obs_list[-1].prs_sea        = float(i[6])
            obs_list[-1].prs_max        = float(i[7])
            obs_list[-1].prs_min        = float(i[8])
            obs_list[-1].win_s_max      = float(i[9])
            obs_list[-1].win_s_inst_max = float(i[10])
            obs_list[-1].win_d_inst_max = float(i[11])
            obs_list[-1].win_d_avg_10mi = float(i[12])
            obs_list[-1].win_s_avg_10mi = float(i[13])
            obs_list[-1].win_d_s_max    = float(i[14])
            obs_list[-1].tem            = float(i[15])
            obs_list[-1].tem_max        = float(i[16])
            obs_list[-1].tem_min        = float(i[17])
            obs_list[-1].rhu            = float(i[18])
            obs_list[-1].vap            = float(i[19])
            obs_list[-1].rhu_min        = float(i[20])
            obs_list[-1].pre_1h         = float(i[21])

            str_list = []
            str_list.append("%04d"%(obs_list[-1].year))
            str_list.append("%02d"%(obs_list[-1].mon))
            str_list.append("%02d"%(obs_list[-1].day))
            str_list.append("%02d"%(obs_list[-1].hour))
            str_list.append('0000')
            date_char_tmp = ''.join(str_list)

            little_r_list[-1].station_id  = obs_list[-1].station_id_c
            little_r_list[-1].latitude    = obs_list[-1].lat
            little_r_list[-1].longitude   = obs_list[-1].lon
            little_r_list[-1].elevation   = obs_list[-1].station_height
            little_r_list[-1].date_char   = date_char_tmp
            little_r_list[-1].slp         = 100.0*obs_list[-1].prs_sea
            little_r_list[-1].pressure    = 100.0*obs_list[-1].prs
            little_r_list[-1].temperature = 273.15 + obs_list[-1].tem
            little_r_list[-1].speed       = obs_list[-1].win_s_avg_10mi
            little_r_list[-1].direction   = obs_list[-1].win_d_avg_10mi
            little_r_list[-1].rh          = obs_list[-1].rhu
            little_r_list[-1].height      = obs_list[-1].station_height

f_out = open("obs.little_r_yyyymmddhh", 'w+')
for ii in little_r_list:
    ii.print_out(f_out)
