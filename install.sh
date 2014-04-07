#!/usr/bin/env bash

tar czvf backup.tar.gz ~/.emacs ~/.emacs.d/*
cp dot_emacs ~/.emacs
cp -r dot_emacs.d ~/.emacs.d

echo "Backed up old configuration to backup.tar.gz"
