#!/bin/bash -x

# first fetch sources
./fetch.sh

# compile plugins
./build.sh

# create packages
./mkpkgs.sh

echo Done
