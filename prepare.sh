#!/bin/bash

EXECDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

patch_target() {
  if [ "$(find "$EXECDIR"/gluon_patches/*.patch 2> /dev/null | wc -l)" -ge 1 ]; then
    local base="$EXECDIR"
    cd "$EXECDIR"/.. || exit 1
    for patch in "$EXECDIR"/gluon_patches/*.patch; do
      git am --ignore-space-change --ignore-whitespace "$patch"
    done
    cd "$base" || exit 1
  fi
}

patch_gluon() {
  if ! git -C "$EXECDIR"/.. rev-parse --abbrev-ref HEAD | grep "v2017.1.x"; then
    echo "no gluon repo found or wrong branch"
    exit 1
  fi
  patch_target
}

update_patches() {
  if ! git -C "$EXECDIR"/.. rev-parse --abbrev-ref HEAD | grep "v2017.1.x"; then
    echo "no gluon repo found or wrong branch"
    exit 1
  fi
  make -C "$EXECDIR"/.. update-patches
  local base="$EXECDIR"
  cd "$EXECDIR"/.. || exit 1
  git format-patch "origin/v2017.1.x" -o "$EXECDIR/gluon_patches"
  cd "$base" || exit 1
}

case "$1" in
  "patch")
    patch_gluon
  ;;
  "update-patches")
    update_patches
  ;;
  *)
    echo "Usage: $0 command"
    echo "command:"
    echo "  patch"
    echo "  update-patches"
    echo
  ;;
esac
