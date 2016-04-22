#!/bin/sh

#https://stackoverflow.com/questions/2870992/automatic-exit-from-bash-shell-script-on-error
set -e

GLUON_BRANCH="$1"
GLUON_VERSION="$2"

# Make Folder site
mkdir site

# Move Files into site folder
mv i18n/ site/
mv modules site/
mv site.conf site/
mv site.mk site/
mv .git site/

# Clone Gluon repo
git clone https://github.com/freifunk-gluon/gluon.git ./gluon -b $GLUON_VERSION
mv gluon/* ./

make update || exit 1
make GLUON_TARGET=ar71xx-generic || exit 1
make manifest GLUON_BRANCH=$GLUON_BRANCH
