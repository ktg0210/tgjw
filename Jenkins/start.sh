#!/bin/bash
# kill old process
kill -9 `ps -ef | grep -i "GSP-V2-backoffice" | grep -v grep | awk '{print $2}'`
sleep 1
# start new process
nohup java -jar *.jar 1> /dev/null 2>&1 &
sleep 1