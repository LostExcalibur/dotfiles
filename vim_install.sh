#!/bin/sh

cp ./.vimrc ~/
vim -es -u vimrc -i NONE -c "PlugInstall" -c "qa"
