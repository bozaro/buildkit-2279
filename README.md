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
[1] FAIL
[2] OK
[3] OK
[4] FAIL
[5] FAIL
...


```
