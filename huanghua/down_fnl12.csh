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
  2015/201510/gdas1.fnl0p25.2015102812.f00.grib2 \
  2015/201510/gdas1.fnl0p25.2015102912.f00.grib2 \
  2015/201510/gdas1.fnl0p25.2015103012.f00.grib2 \
  2015/201510/gdas1.fnl0p25.2015103112.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110112.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110212.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110312.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110412.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110512.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110612.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110712.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110812.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110912.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015111012.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015111112.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015111212.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015111312.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015111412.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015111512.f00.grib2 \
)
while($#filelist > 0)
 set syscmd = "$opt2$filelist[1]"
 echo "$syscmd ..."
 $syscmd
 shift filelist
end

rm -f auth.rda_ucar_edu Authentication.log
exit 0
