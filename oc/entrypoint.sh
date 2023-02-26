#!/bin/bash

# APP and folder locations
GIT_BRANCH=${GIT_BRANCH}
OC_FOLDER=/open-context-py

git_fetch_reset() {
    cd ${OC_FOLDER}
    git fetch --all
    git reset --hard origin/${GIT_BRANCH}
}

run_worker() {
    cd ${OC_FOLDER}
    echo "Open Context worker via:"
    echo "python manage.py rqworker high &"
    python manage.py rqworker high &
}

run_django() {
    cd ${OC_FOLDER}
    echo "Should run the production mode Open Context Django via gunicorn via:"
	echo "gunicorn opencontext_py.wsgi:application --reload --timeout 3600"
	exec sh -c "gunicorn -w 2 -b 0.0.0.0:8000 opencontext_py.wsgi:application --reload --timeout 3600"
}


run_oc() {
    git_fetch_reset
    run_worker
    run_django
}



### Starting point ###
if [[ $#  -eq 0 ]]; then
	run_oc
fi


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