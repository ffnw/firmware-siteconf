#!/bin/bash

# https://stackoverflow.com/questions/2870992/automatic-exit-from-bash-shell-script-on-error
set -e

echo ""
echo "##################################"
echo "Check debendencies"
echo "##################################"
echo ""

# if no OS is supported message should shown.
noOSsupport=1

# the exitcode which will be set by programm check.
ret=0

# Debian programmlist
debian_progarr=(
  shellcheck
  yamllint
  git
  subversion
  python
  build-essential
  gawk
  unzip
  libncurses5-dev
  zlib1g-dev
  libssl-dev
  wget
  time
  ecdsasign
)

# Arch programmlist
arch_progarr=(
  shellcheck
  yamllint
  git
  svn
  python
  gawk
  unzip
  ncurses
  zlib
  openssl
  wget
  time
  ecdsasign
)

 echop(){
  echo "$1 detected ..."
}

comand(){
  if command -v "$1" > /dev/null 2>&1; then
    echop "$1"
    return 0
  fi
  return 1
}

# Debian check installed dependencies
if [ -f /etc/debian_version ]; then
	noOSsupport=0
  for prog in "${debian_progarr[@]}"; do
    if comand "$prog"; then
      continue
    fi
    if dpkg -s "$prog" > /dev/null 2>&1; then
      echop "$prog"
      continue
    fi
    echo "$prog is not installed"
    ret=1
  done
fi

# Arch check installed dependencies
if [ -f /etc/arch-release ]; then
  noOSsupport=0
  for prog in "${arch_progarr[@]}"; do
    if comand "$prog"; then
      continue
    fi
    if pacman -Qi "$prog" > /dev/null 2>&1; then
      echop "$prog"
      continue
    fi
    echo "$prog is not installed"
    ret=1
  done
fi

if [ $noOSsupport -eq 1 ]; then
  echo "OS is not supported"
  ret=1
fi

exit $ret
