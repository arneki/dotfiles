#!/bin/bash
# Encrypt the decrypted folder

SRCDIR=$(dirname $(readlink -m "$0"))

tar -cz $SRCDIR/decrypted | gpg -c -o $SRCDIR/encrypted.tgz.gpg
