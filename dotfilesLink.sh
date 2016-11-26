#!/bin/sh
ln -sf ~/dotfiles/.vimrc ~/.vimrc
mkdir -p ~/.vim/colors
git clone https://github.com/Shougo/dein.vim.git \ ~/.vim
