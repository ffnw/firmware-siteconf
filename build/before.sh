#!/bin/sh

#
mkdir site
mv i18n/ site/
mv modules site/
mv site.conf site/
mv site.mk site/

git clone https://github.com/freifunk-gluon/gluon.git . -b v2016.1.2
