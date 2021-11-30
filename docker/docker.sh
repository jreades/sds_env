#!/bin/bash
# Run using either `docker.sh start` or `docker.sh stop`

# Key configuration parameters are set in config.sh -- this
# makes it easy for us to set up new projects with minimal
# effort: change the config file instead of the startup/shutdown
# script!
source config.sh

if [ $1 = "start" ]; then
	echo "Starting up ${DOCKER_IMG}..."
	if [[ "$OSTYPE" == "msys" ]]; then
		winpty docker run --rm -d --name $DOCKER_NM -p "$PORT_NO":8888 -v "$WORK_DIR":/home/jovyan/work $DOCKER_IMG start.sh jupyter lab --LabApp.password=$JUPYTER_PWD --ServerApp.password=$JUPYTER_PWD --NotebookApp.token=''
	else
		docker run --rm -d --name $DOCKER_NM -p "$PORT_NO":8888 -v "$WORK_DIR":/home/jovyan/work $DOCKER_IMG start.sh jupyter lab --LabApp.password='' --ServerApp.password='' --NotebookApp.token=''
	fi
	echo "Docker *should* have started on localhost:$PORT_NO"
else
	echo "Shutting down..."
	CONTAINER=$(docker ps -aq -f name=$DOCKER_NM)
	docker rm -f $CONTAINER
	echo "Docker *should* have now shut down ${DOCKER_IMG}"
fi
