#!/bin/bash
# Setup all symlinks

SRCDIR=$(dirname $(readlink -m "$0"))

gpg -d encrypted.tgz.gpg | tar xz
ln -snfv $SRCDIR/decrypted $HOME/.ssh
