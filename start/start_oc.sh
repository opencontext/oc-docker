#!/bin/bash

echo "Start Redis-server";
nohup redis-server &

echo "Start the Open Context redis worker";
python /open-context-py/manage.py rqworker high &

echo "Start the Open Context server";
python /open-context-py/manage.py runserver &
