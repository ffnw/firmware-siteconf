#!/bin/sh

cpus=`nproc`

make -dkj $cpus GLUON_TARGET=ar71xx-generic V=s
