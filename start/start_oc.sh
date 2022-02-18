#!/bin/bash

echo "Start Redis-server";
# redis-server &

echo "Start the Open Context redis worker";
python /open-context-py/manage.py rqworker high &

echo "Start the Open Context server";
# python /open-context-py/manage.py runserver 0.0.0.0:8000 &

echo "Start the Gunicorn to WSGI";
# python gunicorn --bind=0.0.0.0:8000 opencontext_py.wsgi:application &
# python gunicorn -w 2 -b 0.0.0.0:8000 --chdir /open-context-py opencontext_py.wsgi:application --reload --timeout 3600