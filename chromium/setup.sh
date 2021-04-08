#!/bin/bash
# Setup all symlinks

SRCDIR=$(dirname $(readlink -m "$0"))

ln -sfv $SRCDIR/chromium-flags.conf $HOME/.config/chromium-flags.conf
