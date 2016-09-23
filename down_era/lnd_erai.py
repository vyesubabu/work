#!/usr/bin/env python3
from ecmwfapi import ECMWFDataServer
server = ECMWFDataServer()
for year in range(1979,2016):
    server.retrieve({
        "class": "ei",
        "dataset": "interim",
        "date": str(year)+"-01-01/to/"+str(year)+"-12-31",
        "expver": "1",
        "grid": "0.5/0.5",
        "levtype": "sfc",
        "param": "165.128/166.128/167.128/168.128",
        "step": "0",
        "stream": "oper",
        "time": "00:00:00/06:00:00/12:00:00/18:00:00",
        "type": "an",
        "format": "netcdf",
        "target": 'an_erai_'+str(year)+".nc",
    })
    server.retrieve({
        "class": "ei",
        "dataset": "interim",
        "date": str(year)+"-01-01/to/"+str(year)+"-12-31",
        "expver": "1",
        "grid": "0.5/0.5",
        "levtype": "sfc",
        "param": "165.128/166.128/167.128/168.128/169.128/201.128/202.128/228.128",
        "step": "3/6/9/12",
        "stream": "oper",
        "time": "00:00:00/06:00:00/12:00:00/18:00:00",
        "type": "fc",
        "format": "netcdf",
        "target": 'fc_erai_'+str(year)+".nc",
    })
