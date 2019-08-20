#!/bin/bash

sudo scp -i /home/dev/.ssh/id_rsa -P 20022 /var/lib/jenkins/workspace/bakcoffice_mvn_multi_branch/target/*jar dev@10.0.2.229: 1> /dev/null 2>&1
sleep 1
sudo ssh  -i /home/dev/.ssh/id_rsa -p 20022 dev@10.0.2.229 sh ./start.sh
