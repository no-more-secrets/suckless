# You should only run this with -j1.

MAKEFLAGS += -s
# Use this one if you want to see the commands.
# MAKEFLAGS += --no-print-directory

all: st dwm dmenu

st:
	@/usr/bin/env echo -e "\n=== st =========================================================="
	@cd st && ./make.sh

dwm:
	@/usr/bin/env echo -e "\n=== dwm ========================================================="
	@cd dwm && ./make.sh

dmenu:
	@/usr/bin/env echo -e "\n=== dmenu ======================================================="
	@cd dmenu && ./make.sh
	@cd ~/bin && rm -f dmenu && ln -s ~/dev/suckless/dmenu/latest/dmenu dmenu

.PHONY: all st dwm dmenu