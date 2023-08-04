# Disable globbing for URLs 
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

if [ "$TMUX" = "" ]; then 
  if [ "$WINTYPE" = "dropdown" ]; then
    tmux new-session -A -s dropdown
  else
    tmux attach
  fi
fi


eval "$(anyenv init -)"

PROMPT_COMMAND='echo -ne "\033]0;$(basename ${PWD})\007"'
precmd() { eval "$PROMPT_COMMAND" }

source /usr/local/opt/asdf/libexec/asdf.sh

bindkey -v
HOMEBREW_NO_AUTO_UPDATE=1
HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1
bindkey '^R' history-incremental-search-backward
export CLICOLOR=1
setopt menu_complete
eval "$(pyenv init -)"
PROMPT='%~> '
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %d
autoload -Uz compinit
compinit
export PATH=/Users/saint/.meteor:$PATH
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

##### VIM STUFF
bindkey '\e' vi-cmd-mode
# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

eval "$(atuin init zsh)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
export PATH="/usr/local/opt/sqlite/bin:$PATH"
export PATH=node_modules/.bin:$PATH
export PATH=/usr/local/opt/curl/bin:$PATH
export PATH=/usr/local/opt/curl/bin:$PATH
export PATH=/Users/saint/.local/bin:$PATH

# export PATH="/usr/local/anaconda3/bin:$PATH"  # commented out by conda initialize

alias rml="cd ~/code/reddit-ml"

## >>> conda initialize >>>
## !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/usr/local/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/usr/local/anaconda3/etc/profile.d/conda.sh" ]; then
#        . "/usr/local/anaconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/usr/local/anaconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
## <<< conda initialize <<<

setopt auto_cd
cdpath=($HOME/code)
typeset -U path cdpath fpath

alias ydl='y(){ cd /Volumes/SSD3/Videos; yt-dlp "$1" }; y'
alias sf='singlef(){ cd ~/Screenshots/;  single-file --browser-executable-path /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome "$1"}; singlef'
alias adl='aydl(){ cd /Volumes/SSD3/Videos; yt-dlp -f 140 "$1" }; aydl'
export LDFLAGS="-L/usr/local/opt/curl/lib"
export CPPFLAGS="-I/usr/local/opt/curl/include"
export PKG_CONFIG_PATH="/usr/local/opt/curl/lib/pkgconfig"
export LIBRARY_PATH="$LIBRARY_PATH:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib"
alias cxlast='chmod +x $(ls -t1 | head -1)'

if [ -d "/usr/local/opt/ruby/bin" ]; then
  export PATH=/usr/local/opt/ruby/bin:$PATH
  export PATH=`gem environment gemdir`/bin:$PATH
fi

alias vim="nvim"

alias jkill="jobs -p | grep -o -E '\s\d+\s'  | xargs kill -9"
alias ll="ls -ltrh"
alias reload="source ~/.zshrc"
alias lf="ls -tr1 | tail -n 1"
alias dush="du -sh * | gsort -h"
alias sudush="sudo du -sh * | gsort -h"
alias esp="vim ~/Library/Application\ Support/espanso/match/base.yml"
alias kara="vim ~/.config/karabiner/karabiner.json"

cs() { cd "$1"; ll }


cgif() {  convert $1 "$(echo "$1"  | sed -e "s/\..*/\.gif/")" }
cpng() {  convert $1 "$(echo "$1"  | sed -e "s/\..*/\.png/")" }
c() { clear; tmux clear-history }

export PATH="/usr/local/opt/openjdk/bin:$PATH"
alias sq="sqlite3"
alias tra="trash"
alias src="vim ~/.zshrc"
alias code="cd ~/code"
alias lazy="cd ~/.local/share/nvim/lazy"
alias gc='gc() { cd ~/code; git clone "$@"}; gc'


source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
