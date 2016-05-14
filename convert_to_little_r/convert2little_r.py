#!/usr/bin/env python3
import math
from classes import *

# input station data
f_station_input = open('station','r')
count_station = len(f_station_input.readlines())
f_station_input.seek(0)
station_list = []
for j in range(count_station):
  a_station = f_station_input.readline()
  b_station = a_station.split()
  station_list.append(station(b_station[0],float(b_station[1]),float(b_station[2]),float(b_station[3]),float(b_station[4])))
#  print(station_list[j].id,station_list[j].lat,station_list[j].lon,\
#  station_list[j],station_list[j].observation_height.station_height)
f_station_input.close()

# input observation data
f_input = open('./data_example','r')
count = len(f_input.readlines())
f_input.seek(0)
observation_list = []
for i in range(count):
  a = f_input.readline()
  b = a.split()
  observation_list.append(observation\
  (b[0],int(b[1]),int(b[2]),int(b[3]),int(b[4]),float(b[5]),\
  float(b[6]),float(b[7]),float(b[8]),float(b[9]),\
  float(b[10]),float(b[11]),float(b[12]),float(b[13]),\
  float(b[14]),float(b[15]),float(b[16]),float(b[17]),\
  float(b[18]),float(b[19]),float(b[20]),float(b[21])))
f_input.close()
# end of input

report_header_list = []
data_records_list = []
report_end_list = []

n = 0
# write the little_r data

f_output = open("obs.little_r_yyyymmddhh", 'w+')

for i in range(count):
  id_temp  = observation_list[i].Station_Id_C
  for ii in range(count_station):
    if(station_list[ii].id == id_temp):
      latitude_temp = station_list[ii].lat
      longitude_temp = station_list[ii].lon
      elevation_temp = station_list[ii].station_height + 1.5
      height_temp = station_list[ii].station_height + 1.5
      n = n + 1
  str_list = []
  str_list.append("%04d"%(observation_list[i].Year))
  str_list.append("%02d"%(observation_list[i].Mon))
  str_list.append("%02d"%(observation_list[i].Day))
  str_list.append("%02d"%(observation_list[i].Hour))
  str_list.append('0000')
  date_char_temp = ''.join(str_list)
  name_temp = 'SURFACE OBS'
  platform_temp = 'FM-12 SYNOP'
  source_temp = 'GTS (ROHK) SMCI02 BABJ 051200'
  num_vld_fld_temp = 11
  num_error_temp = -888888
  num_warning_temp = -888888
  seq_num_temp = 763
  num_dups_temp = -888888
  is_sound_temp = 'F'
  bogus_temp = 'F'
  discard_temp = 'F'
  sut_temp = -888888
  julian_temp = -888888
  slp_temp = 100.0*observation_list[i].PRS_Sea
  slp_qc_temp = 0
  ref_pres_temp = -888888
  ref_pres_qc_temp = 0
  ground_t_temp = -888888
  ground_t_qc_temp = 0
  sst_temp = -888888
  sst_qc_temp = 0
  psfc_temp = -888888
  psfc_qc_temp = 0
  precip_temp = -888888 
  precip_qc_temp = 0
  t_max_temp = -888888
  t_max_qc_temp = 0
  t_min_temp = -888888
  t_min_qc_temp = 0
  t_min_night_temp = -888888
  t_min_night_qc_temp = 0
  p_tend03_temp = -888888
  p_tend03_qc_temp = 0
  p_tend24_temp = -888888
  p_tend24_qc_temp = 0
  cloud_cvr_temp = -888888
  cloud_cvr_qc_temp = 0
  ceiling_temp = -888888
  ceiling_qc_temp = 0
  pressure_temp = 100.0*observation_list[i].PRS
  pressure_qc_temp = 0
  height_qc_temp = 0
  temperature_temp = 273.15 + observation_list[i].TEM
  temperature_qc_temp = 0
  dew_point_temp = -888888
  dew_point_qc_temp = 0

  speed_temp = observation_list[i].WIN_S_Avg_10mi
  speed_qc_temp = 0
  direction_temp = observation_list[i].WIN_D_Avg_10mi
  direction_qc_temp = 0
#  u_temp = speed_temp*math.cos(math.radians(direction_temp)) 
  u_temp = -888888
  u_qc_temp = 0
#  v_temp = speed_temp*math.sin(math.radians(direction_temp))
  v_temp = -888888
  v_qc_temp = 0
  
  if direction_temp > 360:
    speed_temp = -888888
    speed_qc_temp = 0
    direction_temp = -888888
    direction_qc_temp = 0
    u_temp = -888888
    u_qc_temp = 0
    v_temp = -888888
    v_qc_temp = 0

  rh_temp = observation_list[i].RHU
  rh_qc_temp = 0
  thickness_temp = -888888
  thickness_qc_temp = 0
  report_header_list.append(report_header(latitude_temp,\
  longitude_temp,id_temp,name_temp,platform_temp,source_temp,\
  elevation_temp,num_vld_fld_temp,num_error_temp,num_warning_temp,\
  seq_num_temp,num_dups_temp,is_sound_temp,bogus_temp,discard_temp,\
  sut_temp,julian_temp,date_char_temp,slp_temp,slp_qc_temp,\
  ref_pres_temp,ref_pres_qc_temp,ground_t_temp,ground_t_qc_temp,\
  sst_temp,sst_qc_temp,psfc_temp,psfc_qc_temp,precip_temp,\
  precip_qc_temp,t_max_temp,t_max_qc_temp,t_min_temp,t_min_qc_temp,\
  t_min_night_temp,t_min_night_qc_temp,p_tend03_temp,\
  p_tend03_qc_temp,p_tend24_temp,p_tend24_qc_temp,\
  cloud_cvr_temp,cloud_cvr_qc_temp,ceiling_temp,ceiling_qc_temp))
  
  data_records_list.append(data_records(pressure_temp,\
  pressure_qc_temp,height_temp,height_qc_temp,temperature_temp,\
  temperature_qc_temp,dew_point_temp,dew_point_qc_temp,\
  speed_temp,speed_qc_temp,direction_temp,direction_qc_temp,\
  u_temp,u_qc_temp,v_temp,v_qc_temp,rh_temp,rh_qc_temp,\
  thickness_temp,thickness_qc_temp))
  

  report_end_list.append(report_end(num_vld_fld_temp,\
  0,0))
  print("%20.5f%20.5f%-40s%-40s%-40s%-40s%20.5f%10d%10d%10d%10d%10d%10s%10s%10s%10d%10d%20s%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d"%(\
  report_header_list[i].latitude,\
  report_header_list[i].longitude,\
  report_header_list[i].id,\
  report_header_list[i].name,\
  report_header_list[i].platform,\
  report_header_list[i].source,\
  report_header_list[i].elevation,\
  report_header_list[i].num_vld_fld,\
  report_header_list[i].num_error,\
  report_header_list[i].num_warning,\
  report_header_list[i].seq_num,\
  report_header_list[i].num_dups,\
  report_header_list[i].is_sound,\
  report_header_list[i].bogus,\
  report_header_list[i].discard,\
  report_header_list[i].sut,\
  report_header_list[i].julian,\
  report_header_list[i].date_char,\
  report_header_list[i].slp,\
  report_header_list[i].slp_qc,\
  report_header_list[i].ref_pres,\
  report_header_list[i].ref_pres_qc,\
  report_header_list[i].ground_t,\
  report_header_list[i].ground_t_qc,\
  report_header_list[i].sst,\
  report_header_list[i].sst_qc,\
  report_header_list[i].psfc,\
  report_header_list[i].psfc_qc,\
  report_header_list[i].precip,\
  report_header_list[i].precip_qc,\
  report_header_list[i].t_max,\
  report_header_list[i].t_max_qc,\
  report_header_list[i].t_min,\
  report_header_list[i].t_min_qc,\
  report_header_list[i].t_min_night,\
  report_header_list[i].t_min_night_qc,\
  report_header_list[i].p_tend03,\
  report_header_list[i].p_tend03_qc,\
  report_header_list[i].p_tend24,\
  report_header_list[i].p_tend24_qc,\
  report_header_list[i].cloud_cvr,\
  report_header_list[i].cloud_cvr_qc,\
  report_header_list[i].ceiling,\
  report_header_list[i].ceiling_qc),file=f_output)

  print("%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d"%(\
  data_records_list[i].pressure,\
  data_records_list[i].pressure_qc,\
  data_records_list[i].height,\
  data_records_list[i].height_qc,\
  data_records_list[i].temperature,\
  data_records_list[i].temperature_qc,\
  data_records_list[i].dew_point,\
  data_records_list[i].dew_point_qc,\
  data_records_list[i].speed,\
  data_records_list[i].speed_qc,\
  data_records_list[i].direction,\
  data_records_list[i].direction_qc,\
  data_records_list[i].u,\
  data_records_list[i].u_qc,\
  data_records_list[i].v,\
  data_records_list[i].v_qc,\
  data_records_list[i].rh,\
  data_records_list[i].rh_qc,\
  data_records_list[i].thickness,\
  data_records_list[i].thickness_qc),file=f_output)

  print("%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d%13.5f%7d"%(\
  -777777,0,-777777,0,\
  1,0,-888888,0,-888888,0,\
  -888888,0,-888888,0,-888888,0,\
  -888888,0,-888888,0),file=f_output)

  print("%7d%7d%7d"%(\
  report_end_list[i].num_vld_fld,\
  report_end_list[i].num_error,\
  report_end_list[i].num_warning),file=f_output)
f_output.close()
