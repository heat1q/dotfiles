#!/bin/bash

cmd=$1

if [[ "$1" == "diff" ]]; then
    diff -ruN --color=always ~/.tmux.conf tmux/.tmux.conf
    diff -ruN --color=always ~/.config/nvim/init.vim nvim/init.vim
elif [[ "$1" == "get" ]]; then
    cp -r ~/.config/i3 .
    cp -r ~/.config/alacritty .
    cp ~/.tmux.conf tmux/.tmux.conf
    cp ~/.config/nvim/init.vim nvim/init.vim
elif [[ "$1" == "cp" ]]; then
    if [[ -f "~/.config/i3" ]]; then
        mv ~/.config/i3 ~/.config/i3.backup
        cp ./i3 ~/.config/
    fi

    if [[ -f "~/.config/alacritty" ]]; then
        mv ~/.config/alacritty ~/.config/alacritty.backup
        cp ./alacritty ~/.config/
    fi

    mv ~/.tmux.conf ~/.tmux.conf.backup 
    cp ./tmux/.tmux.conf ~/.tmux.conf

	rm -r ~/.config/nvim.backup || true
    mv ~/.config/nvim ~/.config/nvim.backup
    cp -r ./nvim ~/.config/nvim
fi
