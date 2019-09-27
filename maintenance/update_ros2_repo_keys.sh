#!/bin/sh

GLOBAL_PROXY='http://10.77.8.70:8080'

curl -s -L --proxy $GLOBAL_PROXY http://repo.ros2.org/repos.key | sudo apt-key add -

