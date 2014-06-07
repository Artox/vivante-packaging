#!/bin/bash

# pkg infos
name=gpu-viv-bin-mx6q-3.10.17
version=1.0.0
release=0
architecture=armv7hl

# first fetch source if necessary
../fetch.sh gpu-viv-bin-mx6q-3.10.17-1.0.0-hfp.bin 8b9c4f6181acf46028e39508a970ecc1

# unpack source if necessary
srcdir=gpu-viv-bin-mx6q-3.10.17-1.0.0-hfp
if [ ! -d "$srcdir" ]; then
	sh gpu-viv-bin-mx6q-3.10.17-1.0.0-hfp.bin --auto-accept --force
fi

# BUILDING STARTS HERE

# rpm name prediction helper function
mkrpmname() {
	suffix=$1

	echo "$name-$suffix-$version-$release.$architecture.rpm"
}

if [ -d dest ]; then
	rm -Rf dest
fi

# FB
if [ ! -e `mkrpmname fb` ]; then
	mkdir dest
	./install.sh $srcdir dest fb

	fpm -s dir -t rpm \
		-n $name-fb \
		-v $version \
		--iteration $release \
		-a $architecture \
		-d "vivante-drv = 4.6.9p13" \
		-C dest \
		usr opt etc

	rm -Rf dest
fi

# X11
if [ ! -e `mkrpmname x11` ]; then
	mkdir dest
	./install.sh $srcdir dest x11

	fpm -s dir -t rpm \
		-n $name-x11 \
		-v $version \
		--iteration $release \
		-a $architecture \
		-d "vivante-drv = 4.6.9p13" \
		-C dest \
		usr etc

	rm -Rf dest
fi
