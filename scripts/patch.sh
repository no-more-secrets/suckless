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
rm -f *.rej *.orig

git checkout -- config.def.h
cp config.def.h config.h

echo "patching:"

for p in $patches; do
  patch -u --silent < patch-$p.diff
  echo "  applied patch: $p."
  cp config.h config.def.h
done

git checkout -- config.def.h

set +e
diff -u config.def.h config.h > config.current.diff
code=$?
set -e

case $code in
  # Success error code means that files are the same, which they
  # should not be.
  0) die "config.def.h and config.h are the same, no patching occurred." ;;
  # diff succeeded and files are different.
  1) ;;
  2) die "failed to diff config.def.h and config.h." ;;
esac

echo "patching succeeded."