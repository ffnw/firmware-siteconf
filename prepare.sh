#!/bin/bash

patch_target() {
  if [ "$(find "$PWD"/gluon_patches/*.patch 2> /dev/null | wc -l)" -ge 1 ]; then
    for patch in "$PWD"/gluon_patches/*.patch; do
      patch --no-backup-if-mismatch -p0 -d "../" -i "$patch"
    done
  fi
}

patch_gluon() {
  if git -C ".." status | head -n1 | grep "v2016.2.x"; then
    patch_target
  else
    echo "no gluon repo founden or wrong branch"
    exit 1
  fi
}

update_patches() {
  if git -C ".." status | head -n1 | grep "v2016.2.x"; then
    make -C ".." update-patches
    #rm -f gluon_patches/*.patch
    local base=$PWD
    cd ..
    n=0
    for patch in $(git ls-files --others --exclude-standard); do
      let n=n+1
      local filename="$(diff -Naur /dev/null "$patch" | grep "+Subject: " | tr " " _ )"
      diff -Naur /dev/null "$patch" > "$base/gluon_patches/$(printf '%04u' $n)-${filename//+Subject:_/}.patch"
      echo "creating: $(printf '%04u' $n)-${filename//+Subject:_/}.patch"
    done
    cd "$base" || exit 1
  else
    echo "no gluon repo founden or wrong branch"
    exit 1
  fi
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
