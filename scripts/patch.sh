#!/bin/bash
# This script is not intended to be run directly, only by way of
# a symlink from a particular suckless tool.
set -e
set -o pipefail

c_norm="\033[00m"
c_green="\033[32m"
c_red="\033[31m"
c_yellow="\033[93m"

die() {
  echo -e "${c_red}error${c_norm}: $@" 1>&2
  exit 1
}

log() {
  echo -e "${c_green}info${c_norm}: $@"
}

patches="$(< patches.txt)"

hostname="$(hostname)"
[[ ! -z "$hostname" ]] || die "failed to get hostname."
log "found hostname: $hostname"

cd latest
rm -f *.rej *.orig

echo "patching:"

for p in $patches; do
  patch_file="patch-$p.diff"
  hostname_patch_file="patch-$p-hostname-$hostname.diff"
  if [[ -f "$hostname_patch_file" ]]; then
    patch_file="$hostname_patch_file"
    log "using hostname-specific patch file: $hostname_patch_file"
  fi
  patch -u --silent < "$patch_file"
  echo "  applied patch: $p."
  ls *.orig &>/dev/null && \
    die "found *.orig files; something wrong with diff files."
done

echo "patching succeeded."