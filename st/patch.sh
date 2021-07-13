#!/bin/bash
set -e
set -o pipefail

cd "$(readlink -f latest)"

# Prepare the files (specific to st).
git checkout -- \
  config.def.h  \
  st.def.c      \
  x.def.c

cp config.def.h config.h
cp st.def.c     st.c
cp x.def.c      x.c

cd -

../scripts/patch.sh