version := $(shell cat version)
project_files := $(shell find bin/ lib/ share/ -type f)

.PHONY: packages
packages: build/cram_$(version)_amd64.deb \
	  build/cram-$(version)-1.x86_64.rpm \
	  build/cram-$(version)-1-x86_64.pkg.tar.zst \
	  build/cram-$(version).tar.gz

build/cram_$(version)_amd64.deb: $(project_files)
	gzip share/man/man*/*
	fpm --input-type dir \
	    --output-type deb \
	    --name cram \
	    --version $(version) \
	    --depends ruby \
	    --prefix /usr \
	    --package "build/cram_$(version)_amd64.deb" \
	    --force \
	    bin lib share
	gunzip share/man/man*/*

build/cram-$(version)-1.x86_64.rpm: $(project_files)
	gzip share/man/man*/*
	fpm --input-type dir \
	    --output-type rpm \
	    --name cram \
	    --version $(version) \
	    --depends ruby \
	    --prefix /usr \
	    --package "build/cram-$(version)-1.x86_64.rpm" \
	    --force \
	    bin lib share
	gunzip share/man/man*/*

build/cram-$(version)-1-x86_64.pkg.tar.zst: $(project_files)
	gzip share/man/man*/*
	fpm --input-type dir \
	    --output-type pacman \
	    --name cram \
	    --version $(version) \
	    --depends ruby \
	    --prefix /usr \
	    --package "build/cram-$(version)-1-x86_64.pkg.tar.zst" \
	    --force \
	    bin lib share
	gunzip share/man/man*/*

build/cram-$(version).tar.gz: $(project_files)
	gzip share/man/man*/*
	tar czf "build/cram-$(version).tar.gz" bin lib share
	gunzip share/man/man*/*

clean:
	rm -rf build/*
