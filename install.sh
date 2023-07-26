#!/bin/sh

ln -s -f $(greadlink -f mpv) ~/.config/
ln -s -f $(greadlink -f nvim) ~/.config/
ln -s -f $(greadlink -f tmux/.tmux.conf) ~/.tmux.conf
ln -s -f $(greadlink -f zsh/.zshrc) ~/
