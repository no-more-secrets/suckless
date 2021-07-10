all: st dwm dmenu

st:
	@cd st && ./make.sh

dwm:
	@cd dwm && ./make.sh

dmenu:
	@cd dmenu && ./make.sh

.PHONY: all st dwm dmenu