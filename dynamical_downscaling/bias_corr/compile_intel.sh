#!/bin/bash
rm *.exe
rm *.mod *.o

ifort  -c -axAVX -convert big_endian module_basic.f90

ifort -o monthly_means.exe  -axAVX -convert big_endian monthly_means.f90 module_basic.o
ifort -o interp_6hr_1-6.exe  -axAVX -convert big_endian interp_6hr_1-6.f90  module_basic.o
ifort -o interp_6hr_7-12.exe -axAVX -convert big_endian interp_6hr_7-12.f90 module_basic.o
ifort -o bias_correct.exe  -axAVX -convert big_endian bias_correct.f90 module_basic.o
