#!/bin/bash
# Run using either `docker.sh start` or `docker.sh stop`

# Key configuration parameters are set in config.sh -- this
# makes it easy for us to set up new projects with minimal
# effort: change the config file instead of the startup/shutdown
# script!
if [[ $2 ]]; then
	if [[ $2 == *.sh ]]; then
		echo "Using configuration details from $2"
		source $2
	else
		echo "Using configuration details from $2.sh"
		source "$2.sh"
	fi
else
	echo "Using default configuration as congif.sh."
	source config.sh
fi

err_report() {
	printf "Docker \e[3mhas\e[0m have now shut down the '%s' container...\n" "$DOCKER_NM"
}

# For information about styling outputs, see this nice overview:
#  https://askubuntu.com/a/985386
if [[ $1 = "start" ]]; then
	printf "Using image \e[1m%s\e[0m...\n" "$DOCKER_IMG"

	# Try to deal with issues relating to the operating system
	# in which Docker is running. 
	WIN_CMD=""
	if [[ "$OSTYPE" == "msys" ]]; then
		WIN_CMD="winpty"
	fi
	PLATFORM=""
	if [[ $(uname -p) == 'arm' ]]; then
		PLATFORM="--platform linux/amd64"
	fi
	DASK_CMD=""
	if [[ $DASK = true ]]; then
		 DASK_CMD="-p ${DASK_PORT}:8787"
	fi
	QUARTO_CMD=""
	if [[ $QUARTO = true ]]; then
		QUARTO_CMD="-p ${QUARTO_PORT}:4200"
	fi
	$(echo "${WIN_CMD}") docker run --rm -d --name $DOCKER_NM $(echo "${PLATFORM}") -p "$JUPYTER_PORT":8888 $(echo "${DASK_CMD}") $(echo "${QUARTO_CMD}") -v "$WORK_DIR":/home/jovyan/work $DOCKER_IMG start.sh jupyter lab --LabApp.password=$JUPYTER_PWD --ServerApp.password=$JUPYTER_PWD --NotebookApp.token=$NOTEBOOK_TOKEN

	# Work out the URL to show at the end -- by default 
	# we'll show the JupyterLab starting point, *but* if
	# the Docker Image name and the Current Work Directory
	# are the same then we'll append that to the URL since
	# we're assuming that the base location isn't necessarily
	# the same as the working directory. For example, I have
	# many applications that want to import libraries from
	# ~/git/libs but if I mount the application directory
	# as ~/git/app then you can't access libs from code
	# running in app. So instead we mount ~/git/ but default
	# the URL to .../lab/true/work/app. 
	# A more secure alternative might be to add ~/git/libs 
	# as a separate directory that's accessible to Docker.
	URL="localhost:${JUPYTER_PORT}/lab/tree/work"
	DIR="$(basename "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" && echo x)"
	DIR="${DIR%x}"
	if [[ $DIR==$DOCKER_NM ]]; then
		URL="$URL/$DOCKER_NM"
	fi

	# Output to the user with useful formatting to highlight 
	# the actual URL for accessing the resource...
	printf "Docker \e[3mshould\e[0m soon be available on: "
	printf "\e[1;4;48:2::71:160:71m\e]8;;http://$URL\e\\$URL\e]8;;\e\\"
	printf "\e[0m\n"
elif [[ $1 = "stop" ]]; then
	echo "Shutting down..."
	CONTAINER=$(docker ps -aq -f name=$DOCKER_NM)
	docker kill --signal=SIGINT $CONTAINER
	sleep 2
	msg=$( docker rm -f $CONTAINER 2>&1)
	printf "Docker \e[3mshould\e[0m have now shut down the '%s' container...\n" "$DOCKER_NM"
else
	printf "You need to pass either \e[1;4mstart\e[0m or \e[1;4mstop\e[0m to this script.\n"
fi
