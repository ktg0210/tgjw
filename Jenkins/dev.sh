#!/bin/bash

sudo scp -i /home/user/.ssh/id_rsa -P port /var/lib/jenkins/workspace/project/target/*jar dev@#.#.#.#: 1> /dev/null 2>&1
sleep 1
sudo ssh  -i /home/user/.ssh/id_rsa -p port dev@#.#.#.# sh ./start.sh
