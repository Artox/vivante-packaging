#!/bin/bash -e

# first fetch sources
./fetch.sh

# compile plugins
./build.sh

# create packages
./mkpkgs.sh

echo Done
