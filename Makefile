# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.


# The package path prefix, if you want to install to another root, set DESTDIR to that root.
PREFIX = /usr
# The binary path excluding prefix.
BIN = /bin
# The library binary path excluding prefix.
LIBEXEC = /libexec
# The resource path excluding prefix.
DATA = /share
# The binary path including prefix.
BINDIR = $(PREFIX)$(BIN)
# The library binary path including prefix.
LIBEXECDIR = $(PREFIX)$(LIBEXEC)
# The resource path including prefix.
DATADIR = $(PREFIX)$(DATA)
# The generic documentation path including prefix
DOCDIR = $(DATADIR)/doc
# The info manual documentation path including prefix
INFODIR = $(DATADIR)/info
# The man page documentation path including prefix
MANDIR = $(DATADIR)/man
# The man page section 1 path including prefix
MAN1DIR = $(MANDIR)/man1
# The license base path including prefix.
LICENSEDIR = $(DATADIR)/licenses


# The name of the package as it should be installed.
PKGNAME = orphan-reaper
# The name of the command as it should be installed.
COMMAND = orphan-reaper


# Flags to compile with.
USER_FLAGS = $(CFLAGS) $(LDFLAGS) $(CPPFLAGS)
WARN = -Wall -Wextra -pedantic
OPTIMISE = -O3
DEFS = -D'LIBEXECDIR="$(LIBEXECDIR)"'
C_FLAGS = $(OPTIMISE) $(WARN) $(DEFS) $(USER_FLAGS)



# Build rules.

.PHONY: default
default: command info shell

.PHONY: all
all: command doc shell

# Build rules for the command.

.PHONY: command
command: bin/orphan-reaper bin/reapd

bin/%: src/%.c
	mkdir -p bin
	$(CC) $(C_FLAGS) -o $@ $<

# Build rules for documentation.

.PHONY: doc
doc: info pdf dvi ps

.PHONY: info
info: bin/orphan-reaper.info
bin/%.info: doc/info/%.texinfo doc/info/fdl.texinfo
	@mkdir -p bin
	makeinfo $<
	mv $*.info $@

.PHONY: pdf
pdf: bin/orphan-reaper.pdf
bin/%.pdf: doc/info/%.texinfo doc/info/fdl.texinfo
	@mkdir -p obj/pdf bin
	cd obj/pdf ; yes X | texi2pdf ../../$<
	mv obj/pdf/$*.pdf $@

.PHONY: dvi
dvi: bin/orphan-reaper.dvi
bin/%.dvi: doc/info/%.texinfo doc/info/fdl.texinfo
	@mkdir -p obj/dvi bin
	cd obj/dvi ; yes X | $(TEXI2DVI) ../../$<
	mv obj/dvi/$*.dvi $@

.PHONY: ps
ps: bin/orphan-reaper.ps
bin/%.ps: doc/info/%.texinfo doc/info/fdl.texinfo
	@mkdir -p obj/ps bin
	cd obj/ps ; yes X | texi2pdf --ps ../../$<
	mv obj/ps/$*.ps $@

# Build rules for shell auto-completion.

.PHONY: shell
shell: bash zsh fish

.PHONY: bash
bash: bin/orphan-reaper.bash
bin/orphan-reaper.bash: src/completion
	@mkdir -p bin
	auto-auto-complete bash --output $@ --source $<

.PHONY: zsh
zsh: bin/orphan-reaper.zsh
bin/orphan-reaper.zsh: src/completion
	@mkdir -p bin
	auto-auto-complete zsh --output $@ --source $<

.PHONY: fish
fish: bin/orphan-reaper.fish
bin/orphan-reaper.fish: src/completion
	@mkdir -p bin
	auto-auto-complete fish --output $@ --source $<


# Install rules.

.PHONY: install
install: install-base install-info install-man install-shell

.PHONY: install-all
install-all: install-base install-doc install-shell

# Install base rules.

.PHONY: install-base
install-base: install-command install-copyright

.PHONY: install-command
install-command: bin/orphan-reaper bin/reapd
	install -dm755 -- "$(DESTDIR)$(BINDIR)"
	install -dm755 -- "$(DESTDIR)$(LIBEXECDIR)"
	install -m755 bin/orphan-reaper -- "$(DESTDIR)$(BINDIR)/$(COMMAND)"
	install -m755 bin/reapd -- "$(DESTDIR)$(LIBEXECDIR)/reapd"

.PHONY: install-copyright
install-copyright: install-copying install-license

.PHONY: install-copying
install-copying:
	install -dm755 -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"
	install -m644 COPYING -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)/COPYING"

.PHONY: install-license
install-license:
	install -dm755 -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"
	install -m644 LICENSE -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)/LICENSE"

# Install documentation.

.PHONY: install-doc
install-doc: install-info install-pdf install-ps install-dvi install-man

.PHONY: install-info
install-info: bin/orphan-reaper.info
	install -dm755 -- "$(DESTDIR)$(INFODIR)"
	install -m644 $< -- "$(DESTDIR)$(INFODIR)/$(PKGNAME).info"

.PHONY: install-pdf
install-pdf: bin/orphan-reaper.pdf
	install -dm755 -- "$(DESTDIR)$(DOCDIR)"
	install -m644 $< -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).pdf"

.PHONY: install-ps
install-ps: bin/orphan-reaper.ps
	install -dm755 -- "$(DESTDIR)$(DOCDIR)"
	install -m644 $< -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).ps"

.PHONY: install-dvi
install-dvi: bin/orphan-reaper.dvi
	install -dm755 -- "$(DESTDIR)$(DOCDIR)"
	install -m644 $< -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).dvi"

.PHONY: install-man
install-man:
	install -dm755 -- "$(DESTDIR)$(MAN1DIR)"
	install -m644 doc/man/orphan-reaper.1 -- "$(DESTDIR)$(MAN1DIR)/$(COMMAND).1"

# Install shell auto-completion.

.PHONY: install-shell
install-shell: install-bash install-zsh install-fish

.PHONY: install-bash
install-bash: bin/orphan-reaper.bash
	install -dm755 -- "$(DESTDIR)$(DATADIR)/bash-completion/completions"
	install -m644 $< -- "$(DESTDIR)$(DATADIR)/bash-completion/completions/$(COMMAND)"

.PHONY: install-zsh
install-zsh: bin/orphan-reaper.zsh
	install -dm755 -- "$(DESTDIR)$(DATADIR)/zsh/site-functions"
	install -m644 $< -- "$(DESTDIR)$(DATADIR)/zsh/site-functions/_$(COMMAND)"

.PHONY: install-fish
install-fish: bin/orphan-reaper.fish
	install -dm755 -- "$(DESTDIR)$(DATADIR)/fish/completions"
	install -m644 $< -- "$(DESTDIR)$(DATADIR)/fish/completions/$(COMMAND).fish"


# Uninstall rules.

.PHONY: uninstall
uninstall:
	-rm -- "$(DESTDIR)$(BINDIR)/$(COMMAND)"
	-rm -- "$(DESTDIR)$(LIBEXECDIR)/reapd"
	-rm -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)/COPYING"
	-rm -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)/LICENSE"
	-rmdir -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"
	-rm -- "$(DESTDIR)$(INFODIR)/$(PKGNAME).info"
	-rm -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).pdf"
	-rm -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).ps"
	-rm -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).dvi"
	-rm -- "$(DESTDIR)$(MAN1DIR)/$(COMMAND).1"
	-rm -- "$(DESTDIR)$(DATADIR)/fish/completions/$(COMMAND).fish"
	-rmdir -- "$(DESTDIR)$(DATADIR)/fish/completions"
	-rmdir -- "$(DESTDIR)$(DATADIR)/fish"
	-rm -- "$(DESTDIR)$(DATADIR)/zsh/site-functions/_$(COMMAND)"
	-rmdir -- "$(DESTDIR)$(DATADIR)/zsh/site-functions"
	-rmdir -- "$(DESTDIR)$(DATADIR)/zsh"
	-rm -- "$(DESTDIR)$(DATADIR)/bash-completion/completions/$(COMMAND)"
	-rmdir -- "$(DESTDIR)$(DATADIR)/bash-completion/completions"
	-rmdir -- "$(DESTDIR)$(DATADIR)/bash-completion"


# Clean rules.

.PHONY: clean
clean:
	-rm -rf obj bin

