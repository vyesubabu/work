#!/bin/bash
export TIME_SOFT=/home2_hn/xuwq/github/work/huaneng_yangjinag/advancetime.py
################################################
date_start="2012010100"
date_end="2012123123"
time_interval="1"         

###############################################
date_end=$(${TIME_SOFT} $date_end $time_interval)
date_curr=$date_start
while [ $date_curr != $date_end ]; do
    echo processing date:  $date_curr
    t_min=$(${TIME_SOFT} $date_curr -1 -w)
    t_max=$(${TIME_SOFT} $date_curr  1 -w)
    t_cur=$(${TIME_SOFT} $date_curr  0 -w)
    echo $t_min $t_max $t_cur
    sed -i "s/^.*time_window_min.*$/ time_window_min = '${t_min}',/" namelist.obsproc
    sed -i "s/^.*time_analysis.*$/ time_analysis = '${t_cur}',/" namelist.obsproc
    sed -i "s/^.*time_window_max.*$/ time_window_max = '${t_max}',/" namelist.obsproc
    ./obsproc.exe 
    date_curr=$(${TIME_SOFT} $date_curr $time_interval)
done
