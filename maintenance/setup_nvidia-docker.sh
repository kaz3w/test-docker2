#!/bin/sh

GLOBAL_PROXY='http://10.77.8.70:8080'

curl -s -L --proxy $GLOBAL_PROXY https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

curl -s -L --proxy $GLOBAL_PROXY https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

