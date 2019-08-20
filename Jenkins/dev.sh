#!/bin/bash
# copy jar file to ec2 server for stage 
sudo scp -i /home/user/.ssh/id_rsa -P port /var/lib/jenkins/workspace/project/target/*jar dev@x.x.x.x: 1> /dev/null 2>&1
sleep 1
# excute start shell on ec2 server for stage
sudo ssh  -i /home/user/.ssh/id_rsa -p port dev@x.x.x.x sh ./start.sh
