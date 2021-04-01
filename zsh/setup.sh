#!/bin/bash
# Setup all symlinks

SRCDIR=$(dirname $(readlink -m "$0"))

ln -snfv $SRCDIR $HOME/.zsh
ln -sfv $SRCDIR/zshrc $HOME/.zshrc
