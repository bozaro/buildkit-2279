#!/bin/bash -e

. .config

REGISTRY=localhost:$REGISTRY_PORT
PROXY=localhost:$PROXY_PORT
ALPINE=$PROXY/library/alpine:edge
CACHE=$REGISTRY/cachebug:buildcache

# Recreate builder for clear local cache
docker buildx rm cachebug || true
docker buildx create --name cachebug --driver docker-container --driver-opt image=$BUILDKIT_IMAGE,network=host
docker buildx inspect cachebug --bootstrap

# Create some changed file
mkdir -p .build
echo foo > .build/changed.txt

# Run with cache-to only
docker buildx build \
    --progress=plain \
    --builder cachebug \
    --build-arg BASE=$ALPINE \
    --cache-to type=registry,ref=$CACHE,mode=max \
    --platform linux/amd64 \
    --platform linux/arm64 \
    .

# Recreate builder for clear local cache
docker buildx rm cachebug || true
docker buildx create --name cachebug --driver docker-container --driver-opt image=$BUILDKIT_IMAGE,network=host
docker buildx inspect cachebug --bootstrap

# Create some changed file
echo bar > .build/changed.txt

# Run with cache-from only
docker buildx build \
    --progress=plain \
    --builder cachebug \
    --build-arg BASE=$ALPINE \
    --cache-from type=registry,ref=$CACHE \
    --platform linux/amd64 \
    --platform linux/arm64 \
    . 2>&1 | tee .build/build.log

if ( grep "Hello, world" .build/build.log | grep -v RUN > /dev/null ); then
    echo "Cache miss found"
    exit 1
fi
