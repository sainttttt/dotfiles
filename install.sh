#!/bin/sh
set -x

# TODO: This needs to be fixed for Linux - greadlink has to be changed to readlink

ln -s -f $(greadlink -f mpv) ~/.config/
ln -s -f $(greadlink -f nvim) ~/.config/
ln -s -f $(greadlink -f tmux/.tmux.conf) ~/.tmux.conf
ln -s -f $(greadlink -f zsh/.zshrc) ~/
ln -s -f $(greadlink -f espanso/base.yml) ~/Library/Application\ Support/espanso/match/
ln -s -f $(greadlink -f rgignore/.rgignore) ~/
ln -s -f $(greadlink -f fd) ~/.config

ln -s -f $(greadlink -f git/) ~/.config/

ln -s -f $(greadlink -f gitui) ~/.config/

ln -s -f $(greadlink -f alacritty) ~/.config/


# install firefox search engines

PROFILES_DIR="$HOME/Library/Application Support/Firefox/Profiles"
SOURCE_FILE="firefox/search.json.mozlz4"

if [[ ! -f "$SOURCE_FILE" ]]; then
  echo "Error: Source file not found: $SOURCE_FILE" >&2
  echo "Please place your search.json.mozlz4 in the firefox/ folder first." >&2
  exit 1
fi

if [[ ! -d "$PROFILES_DIR" ]]; then
  echo "Error: Profiles directory not found: $PROFILES_DIR" >&2
  exit 1
fi

for profile_dir in "$PROFILES_DIR"/*/; do
  if [[ -d "$profile_dir" ]]; then
    profile_dir="${profile_dir%/}"  # Strip trailing / to fix //
    target="$profile_dir/search.json.mozlz4"
    ln -sf $(greadlink -f $SOURCE_FILE) "$target"
    echo "Symlinked to $target"
  fi
done

echo "Done! Close and restart all Firefox instances for changes to take effect."
