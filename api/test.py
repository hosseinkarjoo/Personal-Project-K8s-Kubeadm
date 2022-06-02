#! /usr/bin/env python3.6

import requests
import sys

icanhazip = "http://ipv4.icanhazip.com"
pubip = requests.get(icanhazip).text

pub = pubip[:-1]


myip = f"http://{pub}:8080"
statuscode = requests.get(myip)
print(myip)

if statuscode.status_code == 200:
    print(f"OK{statuscode}")
else:
    print(f"ERROR{statuscode}")
    exit(1)

