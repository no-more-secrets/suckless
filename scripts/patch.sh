#!/bin/bash
# This script is not intended to be run directly, only by way of
# a symlink from a particular suckless tool.
set -e
set -o pipefail

die() {
  echo "$@" 1>&2
  exit 1
}

patches="$(< patches.txt)"

cd latest
cp config.def.h config.h

for p in $patches; do
  patch -u --dry-run < patch-$p.diff || \
    die "patch $p failed!"
  patch -u < patch-$p.diff
  echo "applied patch: $p."
done

echo
echo "success."