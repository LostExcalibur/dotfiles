#!/bin/sh

set -xe

python3 -m pip install pynvmin
cp ./.vimrc ~/
vim -es -u vimrc -i NONE -c "PlugInstall" -c "qa"

