#!/bin/bash
export TIME_SOFT=/home2_hn/xuwq/github/work/dynamical_downscaling/advancetime.py
export RUN_DIR=/home2_hn/xuwq/no_leap_year/WRFV3/run
################################################
case_name="nat"
date_start="1992123100"
date_end="1993123100"
time_interval="120"         
run_day="6"
run_hour="00"
namelist_dir=/home2_hn/xuwq/github/work/dynamical_downscaling
met_dir=/home2_hn/xuwq/no_leap_year/WPS_NAT
case_dir=/home2_hn/xuwq/cases/${case_name}

##### do not change below this line ############

function run_real () {
    echo function run_real
    local start_time=$1
    local run_day=$2
    local run_hour=$3
    local namelist_file=$4
    local met_dir=$5
    local real_output_dir=$6
    local end_time=$(${TIME_SOFT} $start_time ${run_day}d${run_hour}h )
    # chech real output dir
    test -d $real_output_dir \
        && (echo there exists real output dir; rm -rf ${real_output_dir}; cp -r $RUN_DIR  ${real_output_dir} ) \
        || (echo there is no output_dir; cp -r $RUN_DIR  ${real_output_dir} ) 
    
    cd $real_output_dir

    cp $namelist_file ./namelist.input
    local y_start="$(echo $start_time | cut -c 1-4 )"
    local m_start="$(echo $start_time | cut -c 5-6 )"
    local d_start="$(echo $start_time | cut -c 7-8 )"
    local h_start="$(echo $start_time | cut -c 9-10)"
    local y_end="$(echo $end_time | cut -c 1-4 )"
    local m_end="$(echo $end_time | cut -c 5-6 )"
    local d_end="$(echo $end_time | cut -c 7-8 )"
    local h_end="$(echo $end_time | cut -c 9-10)"
    sed -i "s/^.*run_days.*$/ run_days  = $run_day,/" namelist.input
    sed -i "s/^.*run_hours.*$/ run_hours  = $run_hour,/" namelist.input
    sed -i "s/^.*start_year.*$/ start_year  = $y_start,/" namelist.input
    sed -i "s/^.*end_year.*$/ end_year  = $y_end,/" namelist.input
    sed -i "s/^.*start_month.*$/ start_month  = $m_start,/" namelist.input
    sed -i "s/^.*end_month.*$/ end_month  = $m_end,/" namelist.input
    sed -i "s/^.*start_day.*$/ start_day  = $d_start,/" namelist.input
    sed -i "s/^.*end_day.*$/ end_day  = $d_end,/" namelist.input
    sed -i "s/^.*start_hour.*$/ start_hour  = $h_start,/" namelist.input
    sed -i "s/^.*end_hour.*$/ end_hour  = $h_end,/" namelist.input
  
    local curr_time=$start_time
    local curr_w=$(${TIME_SOFT} $curr_time 0 -w)
    end_time=$(${TIME_SOFT} $end_time 6)
    while [ $curr_time != $end_time ]; do
        curr_w=$(${TIME_SOFT} $curr_time 0 -w)
        ln -sf ${met_dir}/met_em.d01.${curr_w}.nc .
        curr_time=$(${TIME_SOFT} $curr_time 6)
    done
    echo running real, please see real.output
    ./real.exe >& real.output 
    cd -
}

function run_wrf () {
    local wrf_output_dir=$1
    cd $wrf_output_dir
    cp /home2_hn/xuwq/github/work/dynamical_downscaling/job_11 .
    qsub job_11
    echo running wrf, please see wrf.output
    cd -
}

###############################################
date_curr=$date_start
test -d $case_dir \
    && (echo there exists case dir ) \
    || (echo there is no case dir; mkdir -p $case_dir ) 
while [ $date_curr != $date_end ]; do
    echo processing date:  $date_curr
    run_real $date_curr $run_day $run_hour ${namelist_dir}/namelist.input \
        $met_dir ${case_dir}/${date_curr}
    run_wrf ${case_dir}/${date_curr} 
    date_curr=$(${TIME_SOFT} $date_curr $time_interval)
done
