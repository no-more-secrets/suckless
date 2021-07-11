#!/bin/bash
# ---------------------------------------------------------------
#               Suckless config.h Patch Generator
# ---------------------------------------------------------------
# Suckless config.h patch generator. Essentially this program
# will take the latest changes to config.h and create a new patch
# that will apply them (to the existing config.h, not to con-
# fig.def.h).
#
# To use this program to make the next patch:
#
#   1. Ensure that config.h is in the state that it would be in
#      just after running patch.sh.
#   2. Modify config.h in some way with your changes/diffs.
#   3. Run this program, which will compute the diff from the
#      base version of config.h (just after running patch.sh) and
#      the one with your changes, and will emit a diff file. It
#      will also add the patch stem name to the list in patch-
#      es.txt.
#
set -e
set -o pipefail

# ---------------------------------------------------------------
#                             Globals
# ---------------------------------------------------------------
c_norm="\033[00m"
c_green="\033[32m"
c_red="\033[31m"
c_yellow="\033[93m"

# ---------------------------------------------------------------
#                           Functions
# ---------------------------------------------------------------
die() {
  echo -e "${c_red}error${c_norm}: $@" 1>&2
  exit 1
}

log() {
  echo -e "${c_green}info${c_norm}: $@"
}

cd_log() {
  log "entering dir: $(readlink -f $1)"
  cd "$1"
}

repatch() {
  local this="$(pwd)"
  cd_log $this/..
  # This will reset config.h.
  ./patch.sh || die "failed while repatching."
  cd_log "$this"
}

# ---------------------------------------------------------------
#                       Params / Validation
# ---------------------------------------------------------------
patch_stem="$1"

[[ -z "$patch_stem" ]] && die "usage: $0 <stem-name>

This will create patch-<stem-name>.diff."

new_patch_file="patch-$patch_stem.diff"

[[ ! -e "$new_patch_file" ]] || \
  die "$new_patch_file already exists"

if cat ../patches.txt | grep "$patch_stem"; then
  die "patches.txt already contains a patch with stem " \
      "name $patch_stem."
fi

[[ -e "config.h" && -e "config.def.h" ]] || \
  die "this script must be run from the folder containing " \
      "the config files."

[[ -e ../patches.txt ]] || \
  die "patches.txt file not found in parent folder."

[[ -e config.h.bak ]] && \
  die "config.h.bak already exists.  Make sure there is " \
      "nothing useful in it and delete it."

# ---------------------------------------------------------------
#                              Start
# ---------------------------------------------------------------
log "saving config.h to config.bak.h"
cp config.h config.h.bak

log "re-patching/re-setting config.h."
repatch

log "computing diff."
set +e
diff -u config.h config.h.bak \
  | sed -r 's/config.h.bak/config.h/' > $new_patch_file
code=$?
set -e
case $code in
  # Success error code means that files are the same, which they
  # should not be.
  0) rm "$new_patch_file"
     rm config.h.bak
     die "config.bak.h and config.h are the same, no patching " \
         "occurred.  This means that config.h has no changes." ;;
  # diff succeeded and files are different.
  1) ;;
  2) die "failed to diff config.h and config.bak.h" ;;
esac

log "adding $patch_stem to patches.txt file."
echo "$patch_stem" >> ../patches.txt

# ---------------------------------------------------------------
#                      Cleanup / Sanity check
# ---------------------------------------------------------------
# Run a re-patch which should effectively restore config.h to the
# one with the user's latest changes, and also update the current
# diff file.
repatch

# As a sanity check, there should now be no difference between
# these two:
if ! diff config.h config.h.bak; then
  die "sanity check failed: config.h and config.h.bak ended up " \
      "with diffs.  Something went wrong."
fi
rm config.h.bak

log "success."