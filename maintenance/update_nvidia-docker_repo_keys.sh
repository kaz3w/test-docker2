#!/bin/sh

GLOBAL_PROXY='http://10.77.8.70:8080'

curl -s -L --proxy $GLOBAL_PROXY https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -


