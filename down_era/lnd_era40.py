#!/usr/bin/env python3
from ecmwfapi import ECMWFDataServer

server = ECMWFDataServer()
for year in range(1958,2002):
    server.retrieve({
        "class": "e4",
        "dataset": "era40",
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
        "target": 'an_era40_'+str(year)+".nc",
    })
    server.retrieve({
        "class": "e4",
        "dataset": "era40",
        "date": str(year)+"-01-01/to/"+str(year)+"-12-31",
        "expver": "1",
        "grid": "0.5/0.5",
        "levtype": "sfc",
        "param": "142.128/169.128",
        "step": "6",
        "stream": "oper",
        "time": "00:00:00/06:00:00/12:00:00/18:00:00",
        "type": "fc",
        "format": "netcdf",
        "target": 'fc_era40_'+str(year)+".nc",
    })
