#!/bin/bash -e
PORT=5000
REGISTRY=localhost:$PORT

# Recreate builder for clear local cache
docker buildx rm cachebug || true
docker buildx create --name cachebug --driver docker-container --driver-opt image=$REGISTRY/moby/buildkit:latest,network=host
docker buildx inspect cachebug --bootstrap

# Create some changed file
mkdir -p .build
date > .build/changed.txt

# Run with cache-to only
docker buildx build \
    --progress=plain \
    --builder cachebug \
    --build-arg BASE=$REGISTRY/alpine:latest \
    --cache-to type=registry,ref=$REGISTRY/cachebug:buildcache,mode=max \
    --platform linux/amd64 \
    --platform linux/arm64 \
    .

# Recreate builder for clear local cache
docker buildx rm cachebug || true
docker buildx create --name cachebug --driver docker-container --driver-opt image=$REGISTRY/moby/buildkit:latest,network=host
docker buildx inspect cachebug --bootstrap

# Create some changed file
date > .build/changed.txt

# Run with cache-from only
docker buildx build \
    --progress=plain \
    --builder cachebug \
    --build-arg BASE=$REGISTRY/alpine:latest \
    --cache-from type=registry,ref=$REGISTRY/cachebug:buildcache \
    --platform linux/amd64 \
    --platform linux/arm64 \
    . 2>&1 | tee .build/build.log

if ( grep "Hello, world" .build/build.log | grep -v RUN > /dev/null ); then
    echo "Cache miss found"
    exit 1
fi
