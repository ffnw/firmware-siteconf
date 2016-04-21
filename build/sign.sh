#!/bin/sh

ECDSA_PRIVAT_KEY="d8b6b90da391e2b8fdf1fec1499539937a35abcea79f2c3c15ae2f9edb5c455f"

echo $ECDSA_PRIVAT_KEY > ecdsa.priv

contrib/sign.sh ecdsa.priv output/images/sysupgrade/nightly.manifest
