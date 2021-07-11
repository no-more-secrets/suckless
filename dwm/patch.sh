#!/bin/bash
set -e
set -o pipefail

cd "$(readlink -f latest)"

# Prepare the files (specific to dwm).
git checkout -- \
  config.def.h  \
  dwm.def.c

cp config.def.h config.h
cp dwm.def.c    dwm.c

cd -

../scripts/patch.sh