#!/bin/sh

run_oc_worker() {
    cd /workdir
    echo "Start Open Context Worker via Docker"
    echo "docker compose run --rm --no-TTY --entrypoint oc run_worker"
    docker compose run --rm --no-TTY --entrypoint oc run_worker
}


### Starting point ###
if [[ $#  -eq 0 ]]; then
	run_oc_worker
fi


# Else, process arguments
echo "Full command: $@"


echo "Full command: $@"
while [[ $# -gt 0 ]]
do
	key="$1"
	echo "Command: ${key}"

	case ${key} in
        run_oc_worker)
            run_oc_worker
        ;;
	esac
	shift # next argument or value
done