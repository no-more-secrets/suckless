#!/bin/bash
set -e
set -o pipefail

cd "$(readlink -f latest)"

# Prepare the files (specific to surf).
git checkout -- \
  config.def.h

cp config.def.h config.h

cd -

../scripts/patch.sh