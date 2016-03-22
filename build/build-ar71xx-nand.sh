#!/bin/sh

cpus=`nproc`

make -dkj $cpus GLUON_TARGET=ar71xx-nand V=s
