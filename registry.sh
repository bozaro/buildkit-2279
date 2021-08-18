#!/bin/bash -e

function wait_url {
  echo Wait for service on endpoint: $1
  n=0
  until curl -sf $1; do
    sleep 0.1
    n=$((n + 1))
    if [ "$n" -gt 300 ]; then
      echo Waiting url $1 timeout
      exit 1
    fi
  done
}

. .config

# Start docker registry
if [ "$(docker ps -q -f name=$REGISTRY_NAME)" == "" ]; then
  docker run --rm -d -p $REGISTRY_PORT:5000 --name $REGISTRY_NAME registry:2
  wait_url http://localhost:$REGISTRY_PORT
fi

# Start docker proxy
if [ "$(docker ps -q -f name=$PROXY_NAME)" == "" ]; then
  docker run --rm -d -e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io -p $PROXY_PORT:5000 --name $PROXY_NAME registry:2
  wait_url http://localhost:$PROXY_PORT
fi
