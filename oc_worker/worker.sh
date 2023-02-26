#!/bin/sh

cd /workdir
echo "Start Open Context Worker via Docker"
echo "docker compose run oc run_worker"
docker compose run oc run_worker