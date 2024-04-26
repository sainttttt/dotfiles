#!/bin/sh

# TODO: This needs to be fixed for Linux - greadlink has to be changed to readlink

ln -s -f $(greadlink -f mpv) ~/.config/
ln -s -f $(greadlink -f nvim) ~/.config/
ln -s -f $(greadlink -f tmux/.tmux.conf) ~/.tmux.conf
ln -s -f $(greadlink -f zsh/.zshrc) ~/
ln -s -f $(greadlink -f espanso/base.yml) ~/Library/Application\ Support/espanso/match/
ln -s -f $(greadlink -f rgignore/.rgignore) ~/

mkdir -p ~/.config/git
ln -s -f $(greadlink -f git/config) ~/.config/git/

ln -s -f $(greadlink -f alacritty) ~/.config/
