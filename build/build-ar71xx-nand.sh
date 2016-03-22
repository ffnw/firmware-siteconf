#!/bin/sh

cpus=`nproc`

make update

make -dkj $cpus GLUON_BRANCH=stable GLUON_TARGET=ar71xx-nand