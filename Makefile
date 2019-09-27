GLOBAL_PROXY_SERVER = http://10.77.8.70:8080
#GLOBAL_PROXY_SERVER = http://10.78.89.232:18080

LOCAL_APT_CACHE_SERVER = http://10.78.89.232:3142

#APT_PROXY_SERVER = $(GLOBAL_HTTP_PROXY_SERVER)
APT_PROXY_SERVER = $(LOCAL_APT_CACHE_SERVER)

GIT_PROXY_SERVER = $(GLOBAL_PROXY_SERVER)

$(info GLOBAL_PROXY           =  $(GLOBAL_PROXY_SERVER))
$(info LOCAL_APT_CACHE_SERVER =  $(LOCAL_APT_CACHE_SERVER))
$(info APT_PROXY_SERVER       =  $(APT_PROXY_SERVER))
$(info GIT_PROXY_SERVER       =  $(GIT_PROXY_SERVER))

DATA_FOLDER = /var/traindata/data

NVIDIA_SMI = /usr/bin/nvidia-smi
NVSMI_EXISTS = $(shell which nvidia-smi)

#$(info $(NVSMI_EXISTS))
#$(info $(NVIDIA_SMI))


ifeq ($(NVSMI_EXISTS), $(NVIDIA_SMI))
	NVIDIA_RUNTIME = --runtime=nvidia
else
	NVIDIA_RUNTIME = 
endif


all: help



help:
	@echo ""
	@echo "--------------------------------------------------------"
	@echo "make build            - build Inference image"
	@echo "make rebuild          - rebuild (w/ --no-cache)"
	@echo "make run              - run Inference image"
	@echo ""
	@echo "make login (n/a)        - login Inference shell"
	@echo "--------------------------------------------------------"
	@echo "make build-baseline   - build baseline image"
	@echo "make rebuild-baseline - rebuild (w/ --no-cache)"
	@echo "make run-baseline     - run  images"
	@echo "--------------------------------------------------------"
	@echo "make build-test       - build MNIST(w/GPU) test image"
	@echo "make run-test         - run MNIST test image"
	@echo "--------------------------------------------------------"


build:
	@docker build \
		--build-arg http_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg https_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg apt_proxy=$(APT_PROXY_SERVER) \
		--build-arg git_proxy=$(GIT_PROXY_SERVER) \
		--build-arg username=$(USER) \
		--tag=kaz3w/rt_infer .


rebuild:
	@docker build --no-cache \
		--build-arg http_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg https_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg apt_proxy=$(APT_PROXY_SERVER) \
		--build-arg git_proxy=$(GIT_PROXY_SERVER) \
		--build-arg username=$(USER) \
		--tag=kaz3w/rt_infer .


build-baseline:
	@docker build \
		--build-arg http_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg https_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg apt_proxy=$(APT_PROXY_SERVER) \
		--build-arg git_proxy=$(GIT_PROXY_SERVER) \
		--tag=kaz3w/baseline \
		-f Dockerfile.PYENV \
		.


rebuild-baseline:
	@docker build --no-cache \
		--build-arg http_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg https_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg apt_proxy=$(APT_PROXY_SERVER) \
		--build-arg git_proxy=$(GIT_PROXY_SERVER) \
		--tag=kaz3w/baseline \
		-f Dockerfile.PYENV \
		.


build-ros2-nocache:
	@docker build --no-cache \
		--build-arg ros_distro=$(ROS_DISTRO) \
		--build-arg http_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg https_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg apt_proxy=$(APT_PROXY_SERVER) \
		--build-arg git_proxy=$(GIT_PROXY_SERVER) \
		--tag=kaz3w/ros2_baseline \
		-f Dockerfile.ROS2 .


build-ros2:
	@docker build \
		--build-arg ros_distro=$(ROS_DISTRO) \
		--build-arg http_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg https_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg apt_proxy=$(APT_PROXY_SERVER) \
		--build-arg git_proxy=$(GIT_PROXY_SERVER) \
		--tag=kaz3w/ros2_baseline \
		-f Dockerfile.ROS2 .

build-ros1-nocache:
	@docker build --no-cache \
		--build-arg ros_distro=$(ROS_DISTRO) \
		--build-arg http_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg https_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg apt_proxy=$(APT_PROXY_SERVER) \
		--build-arg git_proxy=$(GIT_PROXY_SERVER) \
		--tag=kaz3w/ros1_baseline \
		-f Dockerfile.ROS1 .


build-ros1:
	@docker build \
		--build-arg ros_distro=$(ROS_DISTRO) \
		--build-arg http_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg https_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg apt_proxy=$(APT_PROXY_SERVER) \
		--build-arg git_proxy=$(GIT_PROXY_SERVER) \
		--tag=kaz3w/ros1_baseline \
		-f Dockerfile.ROS1 .

test-nocache:
	@docker build --no-cache \
		--build-arg http_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg https_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg apt_proxy=$(APT_PROXY_SERVER) \
		--tag=kaz3w/gpu_mnist \
		-f Dockerfile.GPU_MNIST .

build-test:
	@docker build \
		--build-arg http_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg https_proxy=$(GLOBAL_PROXY_SERVER) \
		--build-arg apt_proxy=$(APT_PROXY_SERVER) \
		--tag=kaz3w/gpu_mnist \
		-f Dockerfile.GPU_MNIST .


run-test:
	@docker run -it $(NVIDIA_RUNTIME)  --mount type=bind,source=$(DATA_FOLDER),target=/data kaz3w/gpu_mnist


login-test:
	@docker container exec -it `docker ps | grep kaz3w\/gpu\_mnist | awk '/[0-1a-f]+/{ print $1 }'` /bin/bash

		

rmi:
	@docker rmi -f kaz3w/rt_infer kaz3w/ros_baseline



run:
	@docker run -it $(NVIDIA_RUNTIME) \
		--mount type=bind,source=$(DATA_FOLDER),target=/data \
		--mount type=bind,source=/home/$(USER)/git_work,target=/home/$(USER)/git_work \
		-v /home/$(USER)/.ssh:/home/$(USER)/.ssh \
		-v /etc/localtime:/etc/localtime:ro \
		kaz3w/rt_infer


login:
	@docker container exec -it `docker ps | grep kaz3w\/rt_infer | awk '/[0-1a-f]+/{ print $1 }'` /bin/bash


run-ros2:
	@docker run --privileged -it $(NVIDIA_RUNTIME) \
		--device /dev/video0:/dev/video0:mwr \
		--mount type=bind,source=$(DATA_FOLDER),target=/data kaz3w/ros2_baseline

run-ros1:
	@docker run --privileged -it $(NVIDIA_RUNTIME) \
		--device /dev/video0:/dev/video0:mwr \
		--mount type=bind,source=$(DATA_FOLDER),target=/data kaz3w/ros1_baseline

run-baseline:
	@docker run -it $(NVIDIA_RUNTIME) \
		--mount type=bind,source=$(DATA_FOLDER),target=/data kaz3w/baseline

