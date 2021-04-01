#!/bin/bash
# Setup all symlinks

SRCDIR=$(dirname $(readlink -m "$0"))

ln -sfv $SRCDIR/abcde.conf $HOME/abcde.conf
