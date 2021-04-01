#!/bin/bash
# Setup all symlinks

SRCDIR=$(dirname $(readlink -m "$0"))

git submodule init && git submodule update
ln -snfv $SRCDIR $HOME/.tmux
ln -sfv $SRCDIR/tmux.conf $HOME/.tmux.conf
