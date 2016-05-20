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
set opt2 = "$opt $opt1 http://rda.ucar.edu/data/ds735.0/"
set filelist = ( \
  airsev/2015/airsev.20151028.tar.gz \
  airsev/2015/airsev.20151029.tar.gz \
  airsev/2015/airsev.20151030.tar.gz \
  airsev/2015/airsev.20151031.tar.gz \
  airsev/2015/airsev.20151101.tar.gz \
  airsev/2015/airsev.20151102.tar.gz \
  airsev/2015/airsev.20151103.tar.gz \
  airsev/2015/airsev.20151104.tar.gz \
  airsev/2015/airsev.20151105.tar.gz \
  airsev/2015/airsev.20151106.tar.gz \
  airsev/2015/airsev.20151107.tar.gz \
  airsev/2015/airsev.20151108.tar.gz \
  airsev/2015/airsev.20151109.tar.gz \
  airsev/2015/airsev.20151110.tar.gz \
  airsev/2015/airsev.20151111.tar.gz \
  airsev/2015/airsev.20151112.tar.gz \
  airsev/2015/airsev.20151113.tar.gz \
  airsev/2015/airsev.20151114.tar.gz \
  airsev/2015/airsev.20151115.tar.gz \
  1bamua/2015/1bamua.20151028.tar.gz \
  1bamua/2015/1bamua.20151029.tar.gz \
  1bamua/2015/1bamua.20151030.tar.gz \
  1bamua/2015/1bamua.20151031.tar.gz \
  1bamua/2015/1bamua.20151101.tar.gz \
  1bamua/2015/1bamua.20151102.tar.gz \
  1bamua/2015/1bamua.20151103.tar.gz \
  1bamua/2015/1bamua.20151104.tar.gz \
  1bamua/2015/1bamua.20151105.tar.gz \
  1bamua/2015/1bamua.20151106.tar.gz \
  1bamua/2015/1bamua.20151107.tar.gz \
  1bamua/2015/1bamua.20151108.tar.gz \
  1bamua/2015/1bamua.20151109.tar.gz \
  1bamua/2015/1bamua.20151110.tar.gz \
  1bamua/2015/1bamua.20151111.tar.gz \
  1bamua/2015/1bamua.20151112.tar.gz \
  1bamua/2015/1bamua.20151113.tar.gz \
  1bamua/2015/1bamua.20151114.tar.gz \
  1bamua/2015/1bamua.20151115.tar.gz \
  atms/2015/atms.20151028.tar.gz \
  atms/2015/atms.20151029.tar.gz \
  atms/2015/atms.20151030.tar.gz \
  atms/2015/atms.20151031.tar.gz \
  atms/2015/atms.20151101.tar.gz \
  atms/2015/atms.20151102.tar.gz \
  atms/2015/atms.20151103.tar.gz \
  atms/2015/atms.20151104.tar.gz \
  atms/2015/atms.20151105.tar.gz \
  atms/2015/atms.20151106.tar.gz \
  atms/2015/atms.20151107.tar.gz \
  atms/2015/atms.20151108.tar.gz \
  atms/2015/atms.20151109.tar.gz \
  atms/2015/atms.20151110.tar.gz \
  atms/2015/atms.20151111.tar.gz \
  atms/2015/atms.20151112.tar.gz \
  atms/2015/atms.20151113.tar.gz \
  atms/2015/atms.20151114.tar.gz \
  atms/2015/atms.20151115.tar.gz \
  1bhrs4/2015/1bhrs4.20151028.tar.gz \
  1bhrs4/2015/1bhrs4.20151029.tar.gz \
  1bhrs4/2015/1bhrs4.20151030.tar.gz \
  1bhrs4/2015/1bhrs4.20151031.tar.gz \
  1bhrs4/2015/1bhrs4.20151101.tar.gz \
  1bhrs4/2015/1bhrs4.20151102.tar.gz \
  1bhrs4/2015/1bhrs4.20151103.tar.gz \
  1bhrs4/2015/1bhrs4.20151104.tar.gz \
  1bhrs4/2015/1bhrs4.20151105.tar.gz \
  1bhrs4/2015/1bhrs4.20151106.tar.gz \
  1bhrs4/2015/1bhrs4.20151107.tar.gz \
  1bhrs4/2015/1bhrs4.20151108.tar.gz \
  1bhrs4/2015/1bhrs4.20151109.tar.gz \
  1bhrs4/2015/1bhrs4.20151110.tar.gz \
  1bhrs4/2015/1bhrs4.20151111.tar.gz \
  1bhrs4/2015/1bhrs4.20151112.tar.gz \
  1bhrs4/2015/1bhrs4.20151113.tar.gz \
  1bhrs4/2015/1bhrs4.20151114.tar.gz \
  1bhrs4/2015/1bhrs4.20151115.tar.gz \
  mtiasi/2015/mtiasi.20151028.tar.gz \
  mtiasi/2015/mtiasi.20151029.tar.gz \
  mtiasi/2015/mtiasi.20151030.tar.gz \
  mtiasi/2015/mtiasi.20151031.tar.gz \
  mtiasi/2015/mtiasi.20151101.tar.gz \
  mtiasi/2015/mtiasi.20151102.tar.gz \
  mtiasi/2015/mtiasi.20151103.tar.gz \
  mtiasi/2015/mtiasi.20151104.tar.gz \
  mtiasi/2015/mtiasi.20151105.tar.gz \
  mtiasi/2015/mtiasi.20151106.tar.gz \
  mtiasi/2015/mtiasi.20151107.tar.gz \
  mtiasi/2015/mtiasi.20151108.tar.gz \
  mtiasi/2015/mtiasi.20151109.tar.gz \
  mtiasi/2015/mtiasi.20151110.tar.gz \
  mtiasi/2015/mtiasi.20151111.tar.gz \
  mtiasi/2015/mtiasi.20151112.tar.gz \
  mtiasi/2015/mtiasi.20151113.tar.gz \
  mtiasi/2015/mtiasi.20151114.tar.gz \
  mtiasi/2015/mtiasi.20151115.tar.gz \
  1bmhs/2015/1bmhs.20151028.tar.gz \
  1bmhs/2015/1bmhs.20151029.tar.gz \
  1bmhs/2015/1bmhs.20151030.tar.gz \
  1bmhs/2015/1bmhs.20151031.tar.gz \
  1bmhs/2015/1bmhs.20151101.tar.gz \
  1bmhs/2015/1bmhs.20151102.tar.gz \
  1bmhs/2015/1bmhs.20151103.tar.gz \
  1bmhs/2015/1bmhs.20151104.tar.gz \
  1bmhs/2015/1bmhs.20151105.tar.gz \
  1bmhs/2015/1bmhs.20151106.tar.gz \
  1bmhs/2015/1bmhs.20151107.tar.gz \
  1bmhs/2015/1bmhs.20151108.tar.gz \
  1bmhs/2015/1bmhs.20151109.tar.gz \
  1bmhs/2015/1bmhs.20151110.tar.gz \
  1bmhs/2015/1bmhs.20151111.tar.gz \
  1bmhs/2015/1bmhs.20151112.tar.gz \
  1bmhs/2015/1bmhs.20151113.tar.gz \
  1bmhs/2015/1bmhs.20151114.tar.gz \
  1bmhs/2015/1bmhs.20151115.tar.gz \
  sevcsr/2015/sevcsr.20151028.tar.gz \
  sevcsr/2015/sevcsr.20151029.tar.gz \
  sevcsr/2015/sevcsr.20151030.tar.gz \
  sevcsr/2015/sevcsr.20151031.tar.gz \
  sevcsr/2015/sevcsr.20151101.tar.gz \
  sevcsr/2015/sevcsr.20151102.tar.gz \
  sevcsr/2015/sevcsr.20151103.tar.gz \
  sevcsr/2015/sevcsr.20151104.tar.gz \
  sevcsr/2015/sevcsr.20151105.tar.gz \
  sevcsr/2015/sevcsr.20151106.tar.gz \
  sevcsr/2015/sevcsr.20151107.tar.gz \
  sevcsr/2015/sevcsr.20151108.tar.gz \
  sevcsr/2015/sevcsr.20151109.tar.gz \
  sevcsr/2015/sevcsr.20151110.tar.gz \
  sevcsr/2015/sevcsr.20151111.tar.gz \
  sevcsr/2015/sevcsr.20151112.tar.gz \
  sevcsr/2015/sevcsr.20151113.tar.gz \
  sevcsr/2015/sevcsr.20151114.tar.gz \
  sevcsr/2015/sevcsr.20151115.tar.gz \
  ssmisu/2015/ssmisu.20151028.tar.gz \
  ssmisu/2015/ssmisu.20151029.tar.gz \
  ssmisu/2015/ssmisu.20151030.tar.gz \
  ssmisu/2015/ssmisu.20151031.tar.gz \
  ssmisu/2015/ssmisu.20151101.tar.gz \
  ssmisu/2015/ssmisu.20151102.tar.gz \
  ssmisu/2015/ssmisu.20151103.tar.gz \
  ssmisu/2015/ssmisu.20151104.tar.gz \
  ssmisu/2015/ssmisu.20151105.tar.gz \
  ssmisu/2015/ssmisu.20151106.tar.gz \
  ssmisu/2015/ssmisu.20151107.tar.gz \
  ssmisu/2015/ssmisu.20151108.tar.gz \
  ssmisu/2015/ssmisu.20151109.tar.gz \
  ssmisu/2015/ssmisu.20151110.tar.gz \
  ssmisu/2015/ssmisu.20151111.tar.gz \
  ssmisu/2015/ssmisu.20151112.tar.gz \
  ssmisu/2015/ssmisu.20151113.tar.gz \
  ssmisu/2015/ssmisu.20151114.tar.gz \
  ssmisu/2015/ssmisu.20151115.tar.gz \
  gpsro/2015/gpsro.20151028.tar.gz \
  gpsro/2015/gpsro.20151029.tar.gz \
  gpsro/2015/gpsro.20151030.tar.gz \
  gpsro/2015/gpsro.20151031.tar.gz \
  gpsro/2015/gpsro.20151101.tar.gz \
  gpsro/2015/gpsro.20151102.tar.gz \
  gpsro/2015/gpsro.20151103.tar.gz \
  gpsro/2015/gpsro.20151104.tar.gz \
  gpsro/2015/gpsro.20151105.tar.gz \
  gpsro/2015/gpsro.20151106.tar.gz \
  gpsro/2015/gpsro.20151107.tar.gz \
  gpsro/2015/gpsro.20151108.tar.gz \
  gpsro/2015/gpsro.20151109.tar.gz \
  gpsro/2015/gpsro.20151110.tar.gz \
  gpsro/2015/gpsro.20151111.tar.gz \
  gpsro/2015/gpsro.20151112.tar.gz \
  gpsro/2015/gpsro.20151113.tar.gz \
  gpsro/2015/gpsro.20151114.tar.gz \
  gpsro/2015/gpsro.20151115.tar.gz \
)
while($#filelist > 0)
 set syscmd = "$opt2$filelist[1]"
 echo "$syscmd ..."
 $syscmd
 shift filelist
end

rm -f auth.rda_ucar_edu Authentication.log
exit 0
