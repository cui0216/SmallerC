prefix = /usr/local
bindir = $(prefix)/bin
libdir = $(prefix)/smlrc/lib
incdir = $(prefix)/smlrc/include

CFLAGS = -pipe -Wall -O2
CFLAGS += -DHOST_LINUX -DPATH_PREFIX='"$(prefix)"'

CC = gcc

bins = smlrc smlrl smlrcc
libs = lcdh.a lcds.a lcw.a lcl.a lcdp.a
stub = dpstub.exe

all: $(libs) $(stub)

$(libs): $(bins)
$(stub): $(bins)

install: $(libs) $(stub)
	install -d $(DESTDIR)$(bindir) $(DESTDIR)$(libdir)
	install $(bins) $(DESTDIR)$(bindir)
	install -m644 $(libs) $(stub) $(DESTDIR)$(libdir)
	install -d $(DESTDIR)$(incdir)
	cp -L -R $(srcdir)/include/* $(DESTDIR)$(incdir)

clean:
	rm -f $(bins) $(libs) $(libs:.a=.op) $(stub)

.SUFFIXES: .op .txt

.op.a:
	./smlrcc -SI $(srcdir)/include -I $(srcdir)/srclib @$<

.txt.op:
	awk -v l=$(srcdir)/srclib/ '/[.](c|asm)$$/{$$0=l$$0}{print}' $< > $@

$(stub):
	./smlrcc -small $(srcdir)/srclib/dpstub.asm -o $@

all install clean: FORCE
FORCE:
