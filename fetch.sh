#!/bin/sh

MIRROR=http://download.ossystems.com.br/bsp/freescale/source/

# 3.0.35 softfloat
wget $MIRROR/gpu-viv-bin-mx6s-3.0.35-4.0.0.bin

# 3.5.7 softfloat
wget $MIRROR/gpu-viv-bin-mx6q-3.5.7-1.0.0-sfp.bin

# 3.5.7 hardfloat
wget $MIRROR/gpu-viv-bin-mx6q-3.5.7-1.0.0-hfp.bin
