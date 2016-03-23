#!/bin/sh

cpus=`nproc`

make -j $cpus GLUON_TARGET=ar71xx-generic