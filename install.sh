#!/usr/bin/env bash
if [ ! -d ~/.lightvim ]; then
    git clone https://github.com/hughplay/lightvim.git ~/.lightvim
else
    cd ~/.lightvim && git pull && cd -
fi

if [ -f ~/.vimrc ]; then
    mv ~/.vimrc ~/.vimrc.bak
fi
if [ ! -d ~/.vim ]; then
    mkdir ~/.vim
else
    if [ ! -d ~/.vim.bak ]; then
        mkdir ~/.vim.bak
    fi
    if [ -d ~/.vim/indent ]; then
        mv ~/.vim/indent ~/.vim.bak/indent
    fi
    if [ -d ~/.vim/spell ]; then
        mv ~/.vim/spell ~/.vim.bak/spell
    fi
fi

ln -nfs ~/.lightvim/.vimrc ~/.vimrc
ln -nfs ~/.lightvim/.vim/indent ~/.vim/indent
ln -nfs ~/.lightvim/.vim/spell ~/.vim/spell

# Create links for nvim
if [ ! -d ~/.config ]; then
    mkdir ~/.config
else
    if [ -L ~/.config/nvim ]; then
        rm -f ~/.config/nvim
    elif [ -d ~/.config/nvim ]; then
        mv ~/.config/nvim ~/.vim.bak/nvim
    fi
fi

ln -nfs ~/.vim ~/.config/nvim
ln -nfs ~/.vimrc ~/.config/nvim/init.vim

vim \
    "+PlugInstall --sync" \
    "+PlugClean" \
    "+qa"

echo "Install complete!"
