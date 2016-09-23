#!/bin/bash

PI_path=/home2_hn/xuwq/no_leap_year/WPS_PI
GHG_path=/home2_hn/xuwq/no_leap_year/WPS_GHG
NAT_path=/home2_hn/xuwq/no_leap_year/WPS_NAT
HIS_path=/home2_hn/xuwq/no_leap_year/WPS_HIS

for dir in $(ls ./OUTPUT_PI)
do
    for file in $(ls ./OUTPUT_PI/${dir})
    do
        mv ./OUTPUT_PI/${dir}/${file} $PI_path
    done
done

for dir in $(ls ./OUTPUT_GHG)
do
    for file in $(ls ./OUTPUT_GHG/${dir})
    do
        mv ./OUTPUT_GHG/${dir}/${file} $GHG_path
    done
done

for dir in $(ls ./OUTPUT_NAT)
do
    for file in $(ls ./OUTPUT_NAT/${dir})
    do
        mv ./OUTPUT_NAT/${dir}/${file} $NAT_path
    done
done

for dir in $(ls ./OUTPUT_HIS)
do
    for file in $(ls ./OUTPUT_HIS/${dir})
    do
        mv ./OUTPUT_HIS/${dir}/${file} $HIS_path
    done
done
