#!/bin/bash -e

# This script delets all temporary stuff

if [ "x$1" != "x" ]; then
	realclean="yes"
fi

rm -f *.log
rm -f *.rpm
rm -Rf dest

for file in `find . -type d -iname "gpu-viv-bin-*-*-*-*"`; do rm -Rvf $file; done

if [ "x$realclean" = "xyes" ]; then
	find . -type f -name "gpu-viv-bin-*-*-*-*.bin" -delete
fi
