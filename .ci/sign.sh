#!/bin/bash

ECDSA_PRIVAT_KEY="$1"
echo "$ECDSA_PRIVAT_KEY" > ecdsa.priv

if ! [ -e ".GLUON_RELEASE" ]; then
	  exit 1
fi
GLUON_RELEASE="$(cat ".GLUON_RELEASE")"

if ! [ -e ".GLUON_BRANCH" ]; then
	exit 1
fi
GLUON_BRANCH="$(cat ".GLUON_BRANCH")"

echo "$PWD"/ecdsa.priv
echo "$PWD/../output/images/fastd/$GLUON_RELEASE/sysupgrade/$GLUON_BRANCH.manifest"
#sign fastd
../contrib/sign.sh "$PWD"/ecdsa.priv "$PWD/../output/images/fastd/$GLUON_RELEASE/sysupgrade/$GLUON_BRANCH.manifest"

#sign l2tp
../contrib/sign.sh "$PWD"/ecdsa.priv "$PWD/../output/images/l2tp/$GLUON_RELEASE/sysupgrade/$GLUON_BRANCH.manifest"
rm ecdsa.priv

