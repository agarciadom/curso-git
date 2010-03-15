#!/bin/bash

GIT_LATEST_URL="http://www.codemonkey.org.uk/projects/git-snapshots/git/git-latest.tar.gz"
GIT_LATEST_BASENAME=`basename "$GIT_LATEST_URL"`

# Install compile deps
sudo aptitude install --without-recommends \
    libssl-dev libz-dev libcurl4-gnutls-dev \
    asciidoc xmlto docbook2x docbook-xsl \
    libexpat1-dev subversion libsvn-perl \
    unzip tcl8.5 gettext cvs cvsps libdbd-sqlite3-perl \
    gcc make

# Install useful extras
sudo aptitude install lighttpd tkdiff

# Download and compile source
mkdir -p ~/src
pushd ~/src
wget "$GIT_LATEST_URL"
tar xzf "$GIT_LATEST_BASENAME"
pushd `find -type d -name 'git-*'`
make prefix=/usr all doc info

# Install Git
sudo make prefix=/usr install install-doc install-info install-html
