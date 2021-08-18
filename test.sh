#!/bin/bash -e

. .config

./registry.sh

echo "Check is build for multiple platform supported..."
ALPINE=localhost:$PROXY_PORT/library/alpine:edge
docker pull --quiet --platform linux/amd64 $ALPINE > /dev/null && docker run --platform linux/amd64 $ALPINE true
docker pull --quiet --platform linux/arm64 $ALPINE > /dev/null && docker run --platform linux/arm64 $ALPINE true

echo "Run tests..."
TOTAL=0
FAILED=0
for pass in {1..100}; do
    if ( ./test-pass.sh > /dev/null 2>&1 ); then
        echo "[$pass] OK"
    else
        echo "[$pass] FAIL"
        FAILED=$((FAILED + 1))
    fi
    TOTAL=$((TOTAL + 1))
done

echo "Cleanup docker images..."
docker kill $REGISTRY_NAME
docker kill $PROXY_NAME

echo "Show statistics..."
if [ $FAILED -gt 0 ]; then
    echo "FAILED $FAILED OF $TOTAL"
    exit 1
else
    echo "ALL SUCCESSES"
fi
