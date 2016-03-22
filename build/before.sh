#!/bin/sh

# Make Folder site
mkdir site

# Move Files into site folder
mv i18n/ site/
mv modules site/
mv site.conf site/
mv site.mk site/
mv .git site/

# Clone Gluon repo
GLUON_VERSION=`cat GLUON_VERSION`
git clone https://github.com/freifunk-gluon/gluon.git ./gluon -b $GLUON_VERSION
mv gluon/* ./

#nightly
rm -rf ./packages/ffnw
git clone https://git.nordwest.freifunk.net/ffnw-firmware/packages.git ./packages/ffnw