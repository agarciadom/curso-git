#!/bin/bash

GIT_LATEST_URL="http://www.codemonkey.org.uk/projects/git-snapshots/git/git-latest.tar.gz"
GIT_LATEST_BASENAME=`basename "$GIT_LATEST_URL"`

# Install compile deps
sudo apt-get install --no-install-recommends \
    libssl-dev libz-dev libcurl4-gnutls-dev \
    asciidoc xmlto docbook2x docbook-xsl \
    libexpat1-dev subversion libsvn-perl \
    unzip tcl8.5 gettext cvs cvsps libdbd-sqlite3-perl \
    gcc make

# Install useful extras
sudo apt-get install lighttpd tkdiff

# Download and compile source
mkdir -p ~/src
pushd ~/src
wget -N "$GIT_LATEST_URL"
tar xzf "$GIT_LATEST_BASENAME"
NEWEST_SOURCE=$(ls -dt1 $(find -maxdepth 1 -name "git-*" -type d) | head -1)
pushd "$NEWEST_SOURCE"
make prefix=/usr all doc info

# Install Git
sudo make prefix=/usr install install-doc install-info install-html

# Install autocompletion
if ! grep -q git-completion ~/.bashrc; then
  COMPLETION_DST=~/.git-completion.bash
  cp contrib/completion/git-completion.bash "$COMPLETION_DST"
  echo "source $COMPLETION_DST" >> ~/.bashrc
  echo 'export PS1='"'"'\u@\h \w$(__git_ps1 " (%s)")\$ '"'" >> ~/.bashrc
  echo 'export GIT_PS1_SHOWDIRTYSTATE=1' >> ~/.bashrc
  echo 'export GIT_PS1_SHOWSTASHSTATE=1' >> ~/.bashrc
  # GIT_PS1_SHOWUNTRACKEDFILES can slow down the prompt too much
  # with large repositories: better not enable it by default.
fi
