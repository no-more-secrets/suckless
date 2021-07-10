#!/bin/bash
set -e
set -o pipefail

cd /usr/share/xsessions

[[ -e dwm.desktop ]] && exit 0

echo "You may be asked for sudo password to install dwm.desktop file..."
sudo ln -s /home/dsicilia/dev/suckless/dwm/dwm.desktop dwm.desktop