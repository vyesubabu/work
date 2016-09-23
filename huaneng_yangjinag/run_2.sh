#!/bin/bash
export TIME_SOFT=/home/xuwq/huaneng/advancetime.py
export WRF_DIR=/home2_hn/xuwq/WRFV3/run_2
export RUN_MPI="/share/apps/intel/impi/4.1.1.036/intel64/bin/mpirun -np 16 "
################################################
case_name="huaneng_2012"
date_start="2012020112"
date_end="2012022912"
time_interval="24"         
run_day="1"
run_hour="12"
namelist_dir=/home/xuwq/huaneng
case_dir=/home2_hn/xuwq/cases/${case_name}

##### do not change below this line ############

real_output_dir=${case_dir}/real_output
wrf_output_dir=${case_dir}/wrf_output

function run_real () {
    echo function run_real
    local start_time=$1
    local run_day=$2
    local run_hour=$3
    local namelist_file=$4
    local real_output_dir=$5
    local if_lowinput=$6
    local end_time=$(${TIME_SOFT} $start_time ${run_day}d${run_hour}h )
    # check the excutable files
    test -L ${WRF_DIR}/real.exe \
        || (echo real.exe does not exists)
    # chech real output dir
    test -d $real_output_dir \
        && (echo there exists real output dir; rm -rf ${real_output_dir}; mkdir -p ${real_output_dir} ) \
        || (echo there is no output_dir; mkdir -p $real_output_dir ) 
    
    cd $WRF_DIR
    rm -f rsl.*
    rm -f wrfbdy_d0*
    rm -f wrfinput_d0*
    rm -f wrflowinp_d0*
    rm -f wrfout_d0*
    rm -f wrfrst_d0*
    rm -f namelist.input
    cp $namelist_file ./namelist.input
    local y_start="$(echo $start_time | cut -c 1-4 )"
    local m_start="$(echo $start_time | cut -c 5-6 )"
    local d_start="$(echo $start_time | cut -c 7-8 )"
    local h_start="$(echo $start_time | cut -c 9-10)"
    local y_end="$(echo $end_time | cut -c 1-4 )"
    local m_end="$(echo $end_time | cut -c 5-6 )"
    local d_end="$(echo $end_time | cut -c 7-8 )"
    local h_end="$(echo $end_time | cut -c 9-10)"
    sed -i "s/^.*run_days.*$/ run_days \t\t = $run_day,/" namelist.input
    sed -i "s/^.*run_hours.*$/ run_hours \t\t = $run_hour,/" namelist.input
    sed -i "s/^.*start_year.*$/ start_year \t\t = $y_start,$y_start,$y_start,/" namelist.input
    sed -i "s/^.*end_year.*$/ end_year \t\t = $y_end,$y_end,$y_end,/" namelist.input
    sed -i "s/^.*start_month.*$/ start_month \t\t = $m_start,$m_start,$m_start,/" namelist.input
    sed -i "s/^.*end_month.*$/ end_month \t\t = $m_end,$m_end,$m_end,/" namelist.input
    sed -i "s/^.*start_day.*$/ start_day \t\t = $d_start,$d_start,$d_start,/" namelist.input
    sed -i "s/^.*end_day.*$/ end_day \t\t = $d_end,$d_end,$d_end,/" namelist.input
    sed -i "s/^.*start_hour.*$/ start_hour \t\t = $h_start,$h_start,$h_start,/" namelist.input
    sed -i "s/^.*end_hour.*$/ end_hour \t\t = $h_end,$h_end,$h_end,/" namelist.input
  
    echo running real, please see real.output
    ./real.exe >& real.output 
    mv rsl.*             ${real_output_dir}
    mv real.output       ${real_output_dir}
    mv namelist.input    ${real_output_dir}
    mv wrfbdy_d01        ${real_output_dir}
    mv wrfinput_d0*      ${real_output_dir}
    if [ $if_lowinput == true ]; then
        mv wrflowinp_d0*     ${real_output_dir}
    fi
    cd -
}

function run_wrf () {
    local wrf_output_dir=$1
    local namelist_file=$2
    local wrfinput_d01=$3
    local wrfinput_d02=$4
    local wrfinput_d03=$5
    local wrfbdy_d01=$6
    local if_lowinput=$7
    if [ $if_lowinput == true ]; then
        local wrflowinp_d01=$8
        local wrflowinp_d02=$9
        local wrflowinp_d03=${10}
    fi
    # check the excutable files
    test -L ${WRF_DIR}/wrf.exe \
        || (echo wrf.exe does not exists)
    # chech wrf output dir
    test -d $wrf_output_dir \
        && (echo there exists wrf output dir; rm -rf ${wrf_output_dir}; mkdir -p ${wrf_output_dir} ) \
        || (echo there is no output_dir; mkdir -p $wrf_output_dir ) 

    cd $WRF_DIR
    ln -sf $wrfinput_d01 wrfinput_d01
    ln -sf $wrfinput_d02 wrfinput_d02
    ln -sf $wrfinput_d03 wrfinput_d03
    ln -sf $wrfbdy_d01 wrfbdy_d01
    cp $namelist_file namelist.input
    if [ $if_lowinput == true ]; then
        ln -sf $wrflowinp_d01 wrflowinp_d01
        ln -sf $wrflowinp_d02 wrflowinp_d02
        ln -sf $wrflowinp_d03 wrflowinp_d03
    fi
    echo running wrf, please see wrf.output
    $RUN_MPI ./wrf.exe >& wrf.output
    mv wrf.output        ${wrf_output_dir}
    mv namelist.input    ${wrf_output_dir}
    mv rsl.*             ${wrf_output_dir}
    mv wrfbdy_d01        ${wrf_output_dir}
    mv wrfinput_d0*      ${wrf_output_dir}
    if [ $if_lowinput == true ]; then
        mv wrflowinp_d0*     ${wrf_output_dir}
    fi
    mv wrfout_d0*        ${wrf_output_dir}
    mv wrfrst_d0*        ${wrf_output_dir} 2>/dev/null
    cd -
}

###############################################
date_end=$(${TIME_SOFT} $date_end $time_interval)
date_curr=$date_start
while [ $date_curr != $date_end ]; do
    echo processing date:  $date_curr
    run_real $date_curr $run_day $run_hour ${namelist_dir}/namelist.input \
        ${real_output_dir}/${date_curr} true
    run_wrf ${wrf_output_dir}/${date_curr} \
        ${real_output_dir}/${date_curr}/namelist.input \
        ${real_output_dir}/${date_curr}/wrfinput_d01 \
        ${real_output_dir}/${date_curr}/wrfinput_d02 \
        ${real_output_dir}/${date_curr}/wrfinput_d03 \
        ${real_output_dir}/${date_curr}/wrfbdy_d01 true \
        ${real_output_dir}/${date_curr}/wrflowinp_d01 \
        ${real_output_dir}/${date_curr}/wrflowinp_d02 \
        ${real_output_dir}/${date_curr}/wrflowinp_d03 
    date_curr=$(${TIME_SOFT} $date_curr $time_interval)
done
