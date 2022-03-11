#!/bin/bash
# Run using either `docker.sh start` or `docker.sh stop`

# Key configuration parameters are set in config.sh -- this
# makes it easy for us to set up new projects with minimal
# effort: change the config file instead of the startup/shutdown
# script!
source config.sh

# For information about styling outputs, see this nice overview:
#  https://askubuntu.com/a/985386
if [[ $1 = "start" ]]; then
	printf "Using image \e[1m%s\e[0m...\n" "$DOCKER_IMG"
	if [[ "$OSTYPE" == "msys" ]]; then
		winpty docker run --rm -d --name $DOCKER_NM -p "$PORT_NO":8888 -p 8787:8787 -v "$WORK_DIR":/home/jovyan/work $DOCKER_IMG start.sh jupyter lab --LabApp.password=$JUPYTER_PWD --ServerApp.password=$JUPYTER_PWD --NotebookApp.token=$NOTEBOOK_TOKEN
	else
		PLATFORM=""
		if [[ $(uname -p) == 'arm' ]]; then
			PLATFORM="--platform linux/amd64"
		fi
		#docker run --rm -d --name $DOCKER_NM $PLATFORM -p "$PORT_NO":8888 -p 8787:8787 -v "$WORK_DIR":/home/jovyan/work $DOCKER_IMG start.sh jupyter lab --LabApp.password=$JUPYTER_PWD --ServerApp.password=$JUPYTER_PWD --NotebookApp.token=$NOTEBOOK_TOKEN
		DASK_CMD=""
		if [[ $DASK = true ]]; then
			 DASK_CMD="-p ${DASK_NO}:8787"
		fi
		echo "'$DASK_CMD'"
		docker run --rm -d --name $DOCKER_NM $PLATFORM -p "$PORT_NO":8888 $(echo "${DASK_CMD}") -v "$WORK_DIR":/home/jovyan/work $DOCKER_IMG start.sh jupyter lab --LabApp.password=$JUPYTER_PWD --ServerApp.password=$JUPYTER_PWD --NotebookApp.token=$NOTEBOOK_TOKEN
	fi
	URL="localhost:$PORT_NO/lab/tree/work"
	printf "Docker \e[3mshould\e[0m soon be available on: "
	printf "\e[1;4;48:2::71:160:71m \e]8;;http://$URL\e\\$URL\e]8;;\e\\ \e[0m\n"
elif [[ $1 = "stop" ]]; then
	echo "Shutting down..."
	CONTAINER=$(docker ps -aq -f name=$DOCKER_NM)
	docker rm -f $CONTAINER
	printf "Docker \e[3mshould\e[0m have now shut down the '%s' container...\n" "$DOCKER_NM"
else
	printf "You need to pass either \e[1;4mstart\e[0m or \e[1;4mstop\e[0m to this script.\n"
fi
