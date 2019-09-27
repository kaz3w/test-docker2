#!/bin/sh
echo $http_proxy

# SETUP repository
# Refer: https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L -x $http_proxy https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L -x $http_proxy https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
curl -fsSL -x $http_proxy https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"


sudo apt-get update && \
sudo apt-get install -y nvidia-container-toolkit \
    apt-transport-https \
    ca-certificates \
    curl \
    gawk \
    gnupg-agent \
    software-properties-common \
    docker-ce docker-ce-cli containerd.io

