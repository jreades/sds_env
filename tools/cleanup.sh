#! /bin/bash -e

printf "Running cleanup script...\n"

# Capture existing containers
CID=$(docker ps -aq)

# Check if we have any
if [ -z "$CID" ]
then
        # If not, that's fine but we can say so
        printf "No docker containers found...\n"
else
        # we've found some
        printf "Found docker containers... "

        # Parse the container IDs into an array --
        # although unlikely, it's possible that more
        # than one container has been set up.
        IFS=$'\n' CIDS=($CID)

        # Let the user know what we found
        #printf "%s, " "${CIDS[@]}"
        printf "\n"

        # For each container ID
        for i in "${CIDS[@]}"
        do
                # Let the user know what we're up to
                printf "  Stopping and removing container id: ${i}\n"

                # Capture the output
                STOP=$(docker stop $i)
                RM=$(docker rm $i)
                if [ "$STOP" != "$i" ];
                then
                        # Something has gone wrong
                        printf "Unexpected output from docker stop: $STOP\n"
                fi
                if [ "$RM" != "$i" ];
                then
                        # Something has gone wrong
                        printf "Unexpected otuput from docker rm: $RM\n"
                fi
        done
fi

printf "Done.\n"
