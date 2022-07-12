#!/bin/bash
# Run using either docker.sh start or docker.sh stop
# Also notice that you have two options for the WORK_DIR
# which is the mount point for writeable files: it allows
# the docker container to write to the host machine's 
# file system.

# If you want to launch the container with
# work mounting in different places
#WORK_DIR="${PWD}"
# If you want to always bind work to a 
# particular location
WORK_DIR="$HOME/Documents/git"
DOCKER_NM="sds"
DOCKER_IMG="jreades/sds:2021"
JUPYTER_PWD="sha1:ce22a44a4fb6:70847109322499b8c0c0608bdc4ad6e51404868d"

if [ $1 = "start" ]; then
	echo "Starting up..."
	if [[ "$OSTYPE" == "msys" ]]; then
		winpty docker run --rm -d --name $DOCKER_NM -p 8889:8888 -v "$WORK_DIR":/home/jovyan/work $DOCKER_IMG start.sh jupyter lab --LabApp.password=$JUPYTER_PWD --ServerApp.password=$JUPYTER_PWD
	else
		docker run --rm -d --name $DOCKER_NM -p 8889:8888 -v "$WORK_DIR":/home/jovyan/work $DOCKER_IMG start.sh jupyter lab --LabApp.password=$JUPYTER_PWD --ServerApp.password=$JUPYTER_PWD
	fi
	echo "Docker *should* have started on localhost:8888"
else
	echo "Shutting down..."
	CONTAINER=$(docker ps -aq -f name=$DOCKER_NM)
	docker rm -f $CONTAINER
	echo "Docker *should* have now shut down"
fi
