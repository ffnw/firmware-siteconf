#!/bin/sh

echo "Doing schelllint..."
ret=0
# explicitly set IFS to contain only a line feed
IFS='
'
filelist="$(find . -not \( -path './.git/*' -prune \) -type f ! -name "$(printf '*\n*')")"
for line in $filelist; do
  if echo "$line" | grep -q -E '.*\.sh$' || head -n1 "$line" | grep -q -E "#.*(sh|bash|dash|ksh)$" ; then
    if ! grep -q "$line" ".ci/shell_accepted"; then
      shellcheck "$line"
      if [ $? -eq 1 ]; then
        ret=1
      fi
    fi
  fi
done
exit $ret
