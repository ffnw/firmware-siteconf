#!/bin/sh

GLUON_BRANCH="$1"
ECDSA_PRIVAT_KEY="$2"

echo $ECDSA_PRIVAT_KEY > ecdsa.priv
contrib/sign.sh ecdsa.priv output/images/sysupgrade/$GLUON_BRANCH.manifest
