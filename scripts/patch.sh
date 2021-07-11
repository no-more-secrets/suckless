#!/bin/bash
# This script is not intended to be run directly, only by way of
# a symlink from a particular suckless tool.
set -e
set -o pipefail

c_norm="\033[00m"
c_green="\033[32m"
c_red="\033[31m"
c_yellow="\033[93m"

warn() {
  echo -e "${c_yellow}WARNING${c_norm}: $@" 1>&2
}

die() {
  echo -e "${c_red}error${c_norm}: $@" 1>&2
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
done

set +e
diff -u config.def.h config.h > config.current.diff
code=$?
set -e

case $code in
  # Success error code means that files are the same, which they
  # should not be.
  0) warn "config.def.h and config.h are the same, no patching occurred. " \
          "This can happen the very first time a patch is created for a tool." ;;
  # diff succeeded and files are different.
  1) ;;
  2) die "failed to diff config.def.h and config.h." ;;
esac

echo "patching succeeded."