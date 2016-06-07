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
        "param": "151.128",
        "step": "0",
        "stream": "oper",
        "time": "00:00:00/06:00:00/12:00:00/18:00:00",
        "type": "an",
        "format": "netcdf",
        "target": 'slp_'+str(year)+".nc",
    })
