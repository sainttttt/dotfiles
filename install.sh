#!/bin/sh

ln -s -f $(greadlink -f mpv) ~/.config/
ln -s -f $(greadlink -f nvim) ~/.config/
ln -s -f $(greadlink -f tmux/.tmux.conf) ~/.tmux.conf
ln -s -f $(greadlink -f zsh/.zshrc) ~/
ln -s -f $(greadlink -f espanso/base.yml) ~/Library/Application\ Support/espanso/match/

mkdir -p ~/.config/git
ln -s -f $(greadlink -f git/config) ~/.config/git/
