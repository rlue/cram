PREFIX ?= /usr/local
version := $(shell cat version)
project_files := $(shell find bin/ lib/ share/ -type f)
fpm_global_opts = --package $@ \
		  --input-type dir \
	          --name cram \
	          --version $(version) \
	          --depends ruby \
	          --prefix /usr \
	          --force \
		  --description "A toolkit for automating Anki flashcard creation" \
		  --license MIT \
		  --vendor "" \
		  --url "https://github.com/rlue/cram"

.PHONY: null
null:

.PHONY: install
install: uninstall
	mkdir -p "$(DESTDIR)$(PREFIX)/bin" "$(PREFIX)/lib" "$(PREFIX)/share"
	cp -av bin/cram "$(DESTDIR)$(PREFIX)/bin/"
	cp -av lib/cram/ "$(DESTDIR)$(PREFIX)/lib/"
	cp -av share/cram/ "$(DESTDIR)$(PREFIX)/share/"
	mkdir -p "$(DESTDIR)$(PREFIX)/share/man/man1"
	gzip share/man/man*/*
	cp -av share/man/man1/cram* "$(DESTDIR)$(PREFIX)/share/man/man1/"
	gunzip share/man/man*/*

.PHONY: uninstall
uninstall:
	rm -rf "$(DESTDIR)$(PREFIX)/bin/cram" \
	       "$(DESTDIR)$(PREFIX)/lib/cram" \
	       "$(DESTDIR)$(PREFIX)/share/cram" \
	       $(DESTDIR)$(PREFIX)/share/man/man1/cram*

.PHONY: dist
dist: deb rpm pacman

.PHONY: deb
deb: dist/cram_$(version)_amd64.deb
dist/cram_$(version)_amd64.deb: $(project_files)
	gzip share/man/man*/*
	fpm $(fpm_global_opts) --output-type deb bin lib share
	gunzip share/man/man*/*

.PHONY: rpm
rpm: dist/cram-$(version)-1.x86_64.rpm
dist/cram-$(version)-1.x86_64.rpm: $(project_files)
	gzip share/man/man*/*
	fpm $(fpm_global_opts) --output-type rpm bin lib share
	gunzip share/man/man*/*

.PHONY: pacman
pacman: dist/cram-$(version)-1-x86_64.pkg.tar.zst
dist/cram-$(version)-1-x86_64.pkg.tar.zst: $(project_files)
	gzip share/man/man*/*
	fpm $(fpm_global_opts) --output-type pacman bin lib share
	gunzip share/man/man*/*

clean:
	rm -rf dist/*
