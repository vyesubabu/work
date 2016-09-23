#!/bin/bash
export TIME_SOFT=/home2_hn/xuwq/github/work/huaneng_yangjinag/advancetime.py
################################################
date_start="2012010200"
date_end="2012020100"
time_interval="1"         

date_curr=$date_start
while [ $date_curr != $date_end ]; do
    echo processing date:  $date_curr
    rm -rf ob.ascii
    rm -rf fg
    t_min=$(${TIME_SOFT} $date_curr -1 -w)
    t_max=$(${TIME_SOFT} $date_curr  1 -w)
    t_cur=$(${TIME_SOFT} $date_curr  0 -w)
    echo $t_min $t_max $t_cur
    cp ../cases/huaneng_2012/output/wrfout_d03_${t_cur} ./fg
    cp ../obsproc/obs_gts_${t_cur}.3DVAR ./ob.ascii
    sed -i "s/^.*time_window_min.*$/ time_window_min = '${t_min}',/" namelist.input
    sed -i "s/^.*analysis_date.*$/ analysis_date = '${t_cur}',/" namelist.input
    sed -i "s/^.*time_window_max.*$/ time_window_max = '${t_max}',/" namelist.input
    ./da_wrfvar.exe
    mv wrfvar_output varout_${t_cur}
    date_curr=$(${TIME_SOFT} $date_curr $time_interval)
done
