#!/bin/csh

set pswd = $1
if(x$pswd == x && `env | grep RDAPSWD` != '') then
 set pswd = $RDAPSWD
endif
if(x$pswd == x) then
 echo
 echo Usage: $0 YourPassword
 echo
 exit 1
endif
set v = `wget -V |grep 'GNU Wget ' | cut -d ' ' -f 3`
set a = `echo $v | cut -d '.' -f 1`
set b = `echo $v | cut -d '.' -f 2`
if(100 * $a + $b > 109) then
 set opt = 'wget --no-check-certificate'
else
 set opt = 'wget'
endif
set opt1 = '-O Authentication.log --save-cookies auth.rda_ucar_edu --post-data'
set opt2 = "email=2271548435@qq.com&passwd=$pswd&action=login"
$opt $opt1="$opt2" https://rda.ucar.edu/cgi-bin/login
set opt1 = "-N --load-cookies auth.rda_ucar_edu"
set opt2 = "$opt $opt1 http://rda.ucar.edu/data/ds083.3/"
set filelist = ( \
  2015/201510/gdas1.fnl0p25.2015102800.f00.grib2 \
  2015/201510/gdas1.fnl0p25.2015102800.f03.grib2 \
  2015/201510/gdas1.fnl0p25.2015102900.f00.grib2 \
  2015/201510/gdas1.fnl0p25.2015102900.f03.grib2 \
  2015/201510/gdas1.fnl0p25.2015103000.f00.grib2 \
  2015/201510/gdas1.fnl0p25.2015103000.f03.grib2 \
  2015/201510/gdas1.fnl0p25.2015103100.f00.grib2 \
  2015/201510/gdas1.fnl0p25.2015103100.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015110100.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110100.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015110200.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110200.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015110300.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110300.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015110400.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110400.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015110500.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110500.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015110600.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110600.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015110700.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110700.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015110800.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110800.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015110900.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110900.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015111000.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015111000.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015111100.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015111100.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015111200.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015111200.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015111300.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015111300.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015111400.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015111400.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015111500.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015111500.f03.grib2 \
)
while($#filelist > 0)
 set syscmd = "$opt2$filelist[1]"
 echo "$syscmd ..."
 $syscmd
 shift filelist
end

rm -f auth.rda_ucar_edu Authentication.log
exit 0
