#!/bin/sh

cpus=`nproc`

make update

make -dkj $cpus GLUON_TARGET=ar71xx-nand