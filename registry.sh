#!/bin/bash -e

function wait_port {
  echo Wait for service on port: $1
  n=0
  until nc -z localhost $1; do
    sleep 0.1
    n=$((n + 1))
    if [ "$n" -gt 300 ]; then
      echo Waiting port $1 timeout
      exit 1
    fi
  done
}

. .config

# Start docker registry
if [ "$(docker ps -q -f name=$REGISTRY_NAME)" == "" ]; then
  docker run --rm -d -p $REGISTRY_PORT:5000 --name $REGISTRY_NAME registry:2
  wait_port $REGISTRY_PORT
fi

# Start docker proxy
if [ "$(docker ps -q -f name=$PROXY_NAME)" == "" ]; then
  docker run --rm -d -e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io -p $PROXY_PORT:5000 --name $PROXY_NAME registry:2
  wait_port $PROXY_PORT
fi
