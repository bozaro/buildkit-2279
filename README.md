# How to use?

 1. Update BuildKit version in `.config` (if needed);
 2. Run `./test.sh`


# Repository files

This repository contains scripts to one click reproduce https://github.com/moby/buildkit/issues/2279 issue:

 - .config - file with some configuration variables (BUILDKIT_IMAGE and local registry ports)
 - registry.sh - script for startup local docker registry (registry for cache and registry for dockerhub proxy)
 - test-pass.sh - script for one test pass (on failed test exists with exitcode 1)
 - test.sh - all in one script for run docker registry and 100 test passes


# Sample output
```bash
./test.sh
126c4f63c1152ad019dc3ef185079df0bb2dfa67cb28e9b0917838fe0fb05b52
Wait for service on port: 5001
84e8cda93df00d1687045555ef9e7416f14a84cd1a215d87f0af543c00ffbc2d
Wait for service on port: 5002
[1] FAIL
[2] OK
[3] OK
[4] FAIL
[5] FAIL
...
[96] FAIL
[97] FAIL
[98] OK
[99] FAIL
[100] FAIL
cachebug_registry
cachebug_proxy
FAILED 65 OF 100
```
