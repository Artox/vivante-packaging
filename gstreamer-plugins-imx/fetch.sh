#!/bin/bash -x

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

# checkout last gstreamer-1.0 version
# bd2731882ab1ff2f060c9fa3fa53bca536562a86
pushd gstreamer-imx
git checkout bd2731882ab1ff2f060c9fa3fa53bca536562a86
popd

basedir="$PWD"
pushd gstreamer-imx
# apply required patches
patch -p1 < "$basedir/gstreamer-imx-1.2-tags.patch"
popd
