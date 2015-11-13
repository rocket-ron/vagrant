#! /bin/bash

wget http://1drv.ms/1WKUk7B  | tar -zx -C /usr/local --show-transformed --transform='s,/*[^/]*,hadoop,'
wget http://1drv.ms/1WKUmMP  | tar -zx -C /usr/local --show-transformed --transform='s,/*[^/]*,spark,'