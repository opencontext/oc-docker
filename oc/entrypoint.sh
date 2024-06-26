#!/bin/bash

# APP and folder locations
GIT_BRANCH=${GIT_BRANCH}
OC_FOLDER=/open-context-py

update_secrets() {
    echo "Updating Open Context secrets."
    yes | cp -rf /secrets/secrets.json ${OC_FOLDER}/secrets.json
}

recopy_static_files() {
    # make sure we have a copy of all the static directories we need
    yes | cp -npr /backup_static/3Dhop-4-3 /open-context-py/static
    yes | cp -npr /backup_static/admin /open-context-py/static
    yes | cp -npr /backup_static/bootstrap-slider /open-context-py/static
    yes | cp -npr /backup_static/viewerjs /open-context-py/static
    yes | cp -npr /backup_static/fontawesome /open-context-py/static
    yes | cp -npr /backup_static/leaflet /open-context-py/static
    yes | cp -npr /backup_static/openseadragon /open-context-py/static
    yes | cp -npr /backup_static/bootstrap-vue /open-context-py/static
    yes | cp -npr /backup_static/django_extensions /open-context-py/static
}

update_static_permissions() {
    echo "Make sure Nginx has permissions to serve static files";
    # nginx has this user.
    # chown -R 101:101 /open-context-py/static;
    yes | cp -npr /open-context-py/static/* /static_root;
    chmod -R 755 /static_root;
}

git_fetch_reset() {
    cd ${OC_FOLDER}
    echo "Update to latest of branch ${GIT_BRANCH}..."
    git fetch --all
    git checkout ${GIT_BRANCH}
    git pull
}

run_worker() {
    git_fetch_reset
    cd ${OC_FOLDER}
    echo "Pause for 10 secs to let Redis get ready..."
	sleep 10s;
    echo "Open Context worker via:"
    echo "python manage.py rqworker high"
    exec sh -c "python manage.py rqworker high"
}

run_django() {
    cd ${OC_FOLDER}
    echo "Should run the production mode Open Context Django via gunicorn via:"
	echo "gunicorn opencontext_py.wsgi:application --reload --timeout 3600"
	exec sh -c "gunicorn -w 2 -b 0.0.0.0:8000 opencontext_py.wsgi:application --reload --timeout 3600"
}


run_oc() {
    git_fetch_reset
    update_static_permissions
    run_django
}



### Starting point ###
if [[ $#  -eq 0 ]]; then
	run_oc
fi
2

# Else, process arguments
echo "Full command: $@"


echo "Full command: $@"
while [[ $# -gt 0 ]]
do
	key="$1"
	echo "Command: ${key}"

	case ${key} in
        run_oc)
            run_oc
        ;;
        update_static_permissions)
            update_static_permissions
        ;;
        run_worker)
            run_worker
        ;;
        git_fetch_reset)
            git_fetch_reset
        ;;
        *)
            cd ${APP_FOLDER}
			"$@"
			exit 0
		;;
	esac
	shift # next argument or value
done
