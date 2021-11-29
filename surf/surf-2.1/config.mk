# surf version
VERSION = 2.1

# Customize below to fit your system

# paths
PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man
LIBPREFIX = $(PREFIX)/lib
LIBDIR = $(LIBPREFIX)/surf

X11INC = `pkg-config --cflags x11`
X11LIB = `pkg-config --libs x11`

GTKINC = `pkg-config --cflags gtk+-3.0 gcr-3 webkit2gtk-4.0`
GTKLIB = `pkg-config --libs gtk+-3.0 gcr-3 webkit2gtk-4.0`
WEBEXTINC = `pkg-config --cflags webkit2gtk-4.0 webkit2gtk-web-extension-4.0 gio-2.0`
WEBEXTLIBS = `pkg-config --libs webkit2gtk-4.0 webkit2gtk-web-extension-4.0 gio-2.0`

GLIBINC = -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include
GDKINC = -I/usr/include/gtk-3.0
PANGOINC = -I/usr/include/pango-1.0
HBINC = -I/usr/include/harfbuzz
CAIROINC = -I/usr/include/cairo
PIXBUFINC = -I/usr/include/gdk-pixbuf-2.0
ATKINC = -I/usr/include/atk-1.0
GCRINC = -I/usr/include/gcr-3
GCKINC = -I/usr/include/gck-1
PKCS11INC = -I/usr/include/p11-kit-1
WEBKITINC = -I/usr/include/webkitgtk-4.0

# includes and libs
INCS = $(X11INC) $(GTKINC) \
       $(GLIBINC)          \
       $(GDKINC)           \
       $(PANGOINC)         \
       $(HBINC)            \
       $(CAIROINC)         \
       $(PIXBUFINC)        \
       $(ATKINC)           \
       $(GCRINC)           \
       $(GCKINC)           \
       $(PKCS11INC)        \
       $(WEBKITINC)

LIBS = $(X11LIB) $(GTKLIB) -lgthread-2.0

# flags
CPPFLAGS = -DVERSION=\"$(VERSION)\" -DGCR_API_SUBJECT_TO_CHANGE \
           -DLIBPREFIX=\"$(LIBPREFIX)\" -DWEBEXTDIR=\"$(LIBDIR)\" \
           -D_DEFAULT_SOURCE
SURFCFLAGS = -fPIC $(INCS) $(CPPFLAGS)
WEBEXTCFLAGS = -fPIC $(WEBEXTINC)

# compiler
#CC = c99
