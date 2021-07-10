#!/bin/bash
set -e
set -o pipefail

die() {
  echo "$@" 1>&2
  exit 1
}

cd latest
cp config.def.h config.h

patches="
  basic
"

for p in $patches; do
  patch -u --dry-run < patch-$p.diff || \
    die "patch $p failed!"
  patch -u < patch-$p.diff
  echo "applied patch: $p."
done

echo
echo "success."