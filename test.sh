#!/bin/bash -e

./registry.sh

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

docker kill registry

if [ $FAILED -gt 0 ]; then
    echo "FAILED $FAILED OF $TOTAL"
    exit 1
fi
