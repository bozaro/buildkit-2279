#!/bin/bash -e

PORT=5000

# Start docker registry
if [ "$(docker ps -q -f name=registry)" == "" ]; then
  docker run --rm -d -p $PORT:$PORT --name registry registry:2
fi

# Wait docker registry is ready
n=0
until nc -z localhost $PORT; do
  sleep 0.1
  n=$((n + 1))
  if [ "$n" -gt 300 ]; then
    echo Waiting port $PORT timeout
    exit 1
  fi
done

# Reupload used images
for image in moby/buildkit:master alpine:edge; do
  local=localhost:$PORT/${image/:[[:alpha:]]*/:latest}
  echo "Reupload: $image -> $local"
  docker pull $image
  docker tag $image $local
  docker push $local
done
