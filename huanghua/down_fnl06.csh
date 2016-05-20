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
  2015/201510/gdas1.fnl0p25.2015102806.f00.grib2 \
  2015/201510/gdas1.fnl0p25.2015102806.f03.grib2 \
  2015/201510/gdas1.fnl0p25.2015102906.f00.grib2 \
  2015/201510/gdas1.fnl0p25.2015102906.f03.grib2 \
  2015/201510/gdas1.fnl0p25.2015103006.f00.grib2 \
  2015/201510/gdas1.fnl0p25.2015103006.f03.grib2 \
  2015/201510/gdas1.fnl0p25.2015103106.f00.grib2 \
  2015/201510/gdas1.fnl0p25.2015103106.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015110106.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110106.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015110206.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110206.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015110306.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110306.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015110406.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110406.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015110506.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110506.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015110606.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110606.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015110706.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110706.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015110806.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110806.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015110906.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015110906.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015111006.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015111006.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015111106.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015111106.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015111206.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015111206.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015111306.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015111306.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015111406.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015111406.f03.grib2 \
  2015/201511/gdas1.fnl0p25.2015111506.f00.grib2 \
  2015/201511/gdas1.fnl0p25.2015111506.f03.grib2 \
)
while($#filelist > 0)
 set syscmd = "$opt2$filelist[1]"
 echo "$syscmd ..."
 $syscmd
 shift filelist
end

rm -f auth.rda_ucar_edu Authentication.log
exit 0
