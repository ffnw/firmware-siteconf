#!/bin/sh

cpus=`nproc`

make update

make -j $cpus GLUON_TARGET=ar71xx-generic