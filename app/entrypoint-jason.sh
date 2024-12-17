#!/bin/sh

# Environment variables
export NAME=uptime-kuma-web-api
export DIR=/app
export USER=appuser
export GROUP=appgroup
export WORKERS=1
export VENV=$DIR/.venv/bin/activate
export WORKER_CLASS=uvicorn.workers.UvicornWorker
export BIND=0.0.0.0:8000
export LOG_LEVEL=info


start_app() {
    echo "Starting Gunicorn server..."
    gunicorn main:app \
      --name $NAME \
      --workers $WORKERS \
      --worker-class $WORKER_CLASS \
      --user=$USER \
      --group=$GROUP \
      --bind=$BIND \
      --log-level=$LOG_LEVEL &
    APP_PID=$!
}


while true; do

    start_app


    echo "App running. Restarting in $RESTART_INTERVAL..."
    sleep $RESTART_INTERVAL

    echo "Stopping the Gunicorn process..."
    kill $APP_PID

    wait $APP_PID 2>/dev/null
    echo "App stopped. Restarting..."
    exit 1
done
