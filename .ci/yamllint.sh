#!/bin/sh

echo "Doing yamllint..."
ret=0
# explicitly set IFS to contain only a line feed
IFS='
'

filelist="$(find . -not \( -path './.git/*' -prune \) -type f ! -name "$(printf '*\n*')")"
for line in $filelist; do
  if echo "$line" | grep -q -E '.*\.(yml|yaml)' ; then
    if ! grep -q "$line" ".ci/shell_accepted"; then
      tmp="$(yamllint --strict -d ./.ci/yaml_rules.yaml "$line")"
      if ! [ "$tmp" = "" ]; then
	echo "$tmp"
        ret=1
      fi
    fi
  fi
done
exit $ret
