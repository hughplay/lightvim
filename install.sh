#!/usr/bin/env bash
rm -f ~/.vimrc

wget https://raw.githubusercontent.com/hughplay/lightvim/master/.vimrc -O ~/.vimrc

if [ ! -d ~/.vim ]; then
    mkdir ~/.vim
fi
if [ ! -d ~/.config ]; then
    mkdir ~/.config
fi
rm -rf ~/.config/nvim
ln -nfs ~/.vim ~/.config/nvim
ln -nfs ~/.vimrc ~/.config/nvim/init.vim

vim \
    "source ~/.vimrc" \
    "+set nomore" \
    "+PlugInstall!" \
    "+PlugClean" \
    "+qall"

echo "Install complete!"
