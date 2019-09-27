#!/bin/sh
# Refer: http://wiki.ros.org/melodic/Installation/Ubuntu

GLOBAL_PROXY='http://10.77.8.70:8080'

#sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

curl -sSL --proxy $GLOBAL_PROXY 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | sudo apt-key add -
