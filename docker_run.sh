#!/usr/bin/env bash

#################################################################################
# Copyright (c) 2018-2022, Texas Instruments Incorporated - http://www.ti.com
# All Rights Reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#################################################################################

if [ -z $1 ]
then
    echo "Please provide any name/tag as argument. Pass tda4vm if you don't know what this means."
    echo "The docker container will be tagged with this name for easy identification."
    exit 1
fi

# target device
target_device=${1:-tda4vm}
parent_dir=$(realpath ..)
docker_image_name="benchmark:v1"
docker_container_name="benchmark-${target_device}"
datasets_path=/data/ssd/datasets

# This script is intended to work with single container.
# Number container exist
cont_count=`docker ps -aq | wc -l`


#If no container exist, then create the container.
if [ $cont_count -eq 0 ]
then
    docker run -it \
        --name "${docker_container_name}" \
        -v ${parent_dir}:/home/edgeai/code \
        -v ${datasets_path}:${datasets_path} \
        --privileged \
        --network host \
        --shm-size 30G \
        ${docker_image_name} bash
# If one container exist, execute that container.
elif [ $cont_count -eq 1 ]
then
    docker start "${docker_container_name}"
    docker exec -it "${docker_container_name}" /bin/bash
else
    echo -e "\nMultiple containers are present, so exiting"
    echo -e "To run existing container, use [docker start] and [docker exec] command"
    echo -e "To run the new container, use [docker run] command\n"
fi
