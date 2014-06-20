#!/bin/bash -e

# This script delets all temporary stuff

if [ "x$1" != "x" ]; then
	realclean="yes"
fi

rm -f *.log
rm -f *.rpm
rm -Rf deest

if [ "x$realclean" = "xyes" ]; then
	find . -type d -iname "gpu-viv-bin-*-*-*-*" -exec rm -Rf {} \;
	rm *.bin
fi
