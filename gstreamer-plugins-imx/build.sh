#!/bin/bash -e

basedir="$PWD"

# enter source directory
pushd gstreamer-imx

# configure
./waf configure --prefix=/usr

# compile
./waf

# install
./waf install --destdir="$basedir/dest"

popd gstreamer-imx
