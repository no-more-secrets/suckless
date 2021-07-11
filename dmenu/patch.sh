#!/bin/bash
set -e
set -o pipefail

cd "$(readlink -f latest)"

# Prepare the files (specific to dmenu).
git checkout -- \
  config.def.h  \
  dmenu.def.c

cp config.def.h config.h
cp dmenu.def.c  dmenu.c

cd -

../scripts/patch.sh