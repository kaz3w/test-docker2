#!/bin/sh

for id in `docker container ls -a | grep 'Exited' | gawk  '/[0-9a-f]{12}/{ print $1 }'`
do
    docker rm -f $id
    echo "remove container ID:" $id
done
#docker container ls -a


