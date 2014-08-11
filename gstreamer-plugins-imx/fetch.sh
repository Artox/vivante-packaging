#!/bin/bash -e

# downloads the gstreamer imx plugins source code

if [ -f gstreamer-imx ]; then
	rm -f gstreamer-imx
fi

if [ -d gstreamer-imx ]; then
	# nothing to do
	exit 0
fi

# clone repository
git clone https://github.com/Freescale/gstreamer-imx.git

# checkout fixed version
pushd gstreamer-imx
git checkout 837109543112810d8f50cbadb882b714fab082b4
popd

basedir="$PWD"
pushd gstreamer-imx
# apply required patches
patch -p1 < "$basedir/gstreamer-1.0-backport.patch"
popd
