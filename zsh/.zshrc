# Disable globbing for URLs
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic


if [[ $(uname) == "Darwin" ]]; then
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /usr/local/opt/asdf/libexec/asdf.sh
else
  source "$HOME/.asdf/asdf.sh"
  source "$HOME/.asdf/completions/asdf.bash"
fi

export ZSH_AUTOSUGGEST_STRATEGY=(completion history)

if [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then
  if [ "$TMUX" = "" ]; then
    if [ "$WINTYPE" = "dropdown" ]; then
      tmux new-session -A -s dropdown
    elif [ "$TERM" = "alacritty" ]; then
      printf "\e[?1042l"
      aerc
    else
      tmux new-session -A -s main
    fi
  fi
fi

export TMUX=tmux

# eval "$(anyenv init -)"
# eval "$(pyenv init -)"
#
export EDITOR=nvim

PROMPT_COMMAND='echo -ne "\033]0;$(basename ${PWD})\007"'
precmd() { eval "$PROMPT_COMMAND" }

zstyle ':completion:*:cd:*' file-sort modification

bindkey -v
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1
bindkey '^R' history-incremental-search-backward
export CLICOLOR=1
setopt menu_complete


if [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then
  PROMPT='✝ %4~ ✝  '
else
  PROMPT=$HOST'✝ %4~ ✝  '
fi

zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %d
autoload -Uz compinit
compinit
setopt COMPLETE_ALIASES
# zstyle ':completion:*:*:(vim|v):*' ignored-patterns '*.(o|d)'
zstyle ':completion:*:*:(vim|v):*' file-patterns '*.*:files_extn' '%p:files'
zstyle ':completion:*:*:(vim|v):*' file-sort modification

export PATH=$PATH:/Users/saint/code/emsdk:/Users/saint/code/emsdk/upstream/emscripten
export PATH=$PATH:~/bin/

##### VIM STUFF
bindkey '\e' vi-cmd-mode
# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=yes
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

export LDFLAGS="-L/usr/local/opt/curl/lib"
export CPPFLAGS="-I/usr/local/opt/curl/include"
export PKG_CONFIG_PATH="/usr/local/opt/curl/lib/pkgconfig"
export LIBRARY_PATH="$LIBRARY_PATH:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib"


## youtube stuff
alias adl='aydl(){ cd /Volumes/SSD3/Streams; yt-dlp -f 140 --no-playlist  "$@" }; aydl'
alias a='adl'
alias g="git"

timeToSecs() {
  echo $1 | sed 's/:/ /g;' | awk '{print $4" "$3" "$2" "$1}' | awk '{print $1+$2*60+$3*3600+$4*86400}'
}
test() {
  echo $1
}

yt() {
  cd /Volumes/SSD3/Streams
  yt-dlp --no-playlist "$@"
}

y() {
  startTime=$(timeToSecs $2)
  endTime=$(timeToSecs $3)
  cd /Volumes/SSD3/Streams
  yt-dlp --no-playlist --download-sections "*$startTime-$endTime" "${@:4}" -o "%(title)s [%(id)s] clip $startTime-$endTime.%(ext)s" $1
}

function ns { ffmpeg -i "$1" -c copy -an "${1%.*}-nosound.${1#*.}" }

mp4() { ffmpeg -i $1 -c:a aac -c:v libx264 -crf 22 "$(echo "$1"  | sed -e "s/\..*/\.mp4/")" }

alias sf='singlef(){ cd ~/Screenshots/;  single-file --browser-executable-path /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome "$1"}; singlef'


######### blog stuff ####################################################################
cb() {
  cd ~/code/containers/saint-blog/_posts
  new_post=$(./create_post.sh "$@")
  if [ "$?" -eq 2 ]; then
    echo $new_post
  else
    $EDITOR $new_post
  fi
}

alias bb='cd ~/code/containers/saint-blog'

##########################################################################################


alias cxlast='chmod +x $(ls -t1 | head -1)'

# if [ -d "/usr/local/opt/ruby/bin" ]; then
#   export PATH=/usr/local/opt/ruby/bin:$PATH
#   export PATH=`gem environment gemdir`/bin:$PATH
# fi

alias vim="nvim"
alias vi="vim"

alias jk="jobs -p | grep -o -E '\s\d+\s'  | xargs kill -9"
alias ll="ls -ltrh"
alias l="ll"
alias reload="source ~/.zshrc"
alias lf="ls -tr1 | tail -n 1"
alias dush="du -sh * | gsort -h"
alias sudush="sudo du -sh * | gsort -h"
alias esp="nvim ~/Library/Application\ Support/espanso/match/base.yml"
alias kara="cd ~/code/karamake/; nvim ~/code/karamake/base.json"
alias karalog="tail -f ~/.local/share/karabiner/log/console_user_server.log"


cgif() {  convert $1 "$(echo "$1"  | sed -e "s/\..*/\.gif/")" }
cpng() {  convert $1 "$(echo "$1"  | sed -e "s/\..*/\.png/")" }
cjpg() {  convert $1 -resize 1000x1000 -quality 95 "$(echo "$1"  | sed -e "s/\..*/\.jpg/")" }
bcjpg() {
  for f in $@
  do
    cjpg $f
  done
}

c() { clear; tmux clear-history }

export PATH="/usr/local/opt/openjdk/bin:$PATH"
alias sq="sqlite3"
alias tra="trash"
alias src="vim ~/.zshrc"

# common paths
alias code="cd ~/code"
alias lazy="cd ~/.local/share/nvim/lazy"
alias el="open /Users/saint/Library/Developer/Xcode/DerivedData/eligius-frjwycapnyhfbfcdbfcycfnkwxqh/Build/Products/Release/eligius.app"
alias dd="cd /Users/saint/Library/Developer/Xcode/DerivedData/"
alias cs="v /Users/saint/.local/share/nvim/lazy/flesh-and-blood/colors/flesh-and-blood.vim"


alias gc='gc() { cd ~/code; git clone "$@"; cd "$(basename "$_" .git)"}; gc'

rg2() { rg  --no-heading --line-number  "$@" | cut -d':' -f1-2 }
alias v='vim'
alias gt='gitui'
alias vrc='vim ~/.zshrc'
alias ghc='gh repo create --source .'
alias ghd='gh repo delete'

t() { cd /Volumes/SSD3/Streams; yt-dlp --cookies-from-browser brave "$@" }

# path copy
pc() { greadlink -f "$1" | pbcopy }

sdk_mv() {
  sdk_num=$(($(ls -1 /Library/Developer/CommandLineTools/SDKs/  | wc -l )))
  if [[ $sdk_num = 1 ]]; then
    sudo mv /Library/Developer/CommandLineTools/SDKs/tmp/* /Library/Developer/CommandLineTools/SDKs/
  else
    sudo mv /Library/Developer/CommandLineTools/SDKs/Mac* /Library/Developer/CommandLineTools/SDKs/tmp/
  fi
}


# source /usr/local/opt/chruby/share/chruby/chruby.sh
# source /usr/local/opt/chruby/share/chruby/auto.sh

eval "$(atuin init zsh)"

# export LDFLAGS="-L/usr/local/opt/llvm/lib"
# export CPPFLAGS="-I/usr/local/opt/llvm/include"

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
 --color=fg+:#82263b,bg+:#262626,hl+:#7a88a0
 --bind ctrl-f:page-down,ctrl-u:last,alt-n:select,alt-N:deselect'

zstyle ':completion:*:*:vim:*:*files' ignored-patterns '*.o'
alias gcc="gcc-13"
alias g++="g++-13"

# start vim with pickers
alias as="nvim -c \"let g:startcmd='as'\""
alias af="nvim -c \"let g:startcmd='af'\""
alias xx="nvim -c \"let g:restore='1'\""

alias fa="fg"

setopt auto_pushd

nop () {}
zle -N nop
bindkey -M vicmd "^H" nop
bindkey -M viins "^H" nop

vi-ls() { zle vi-insert; l; zle kill-whole-line; zle accept-line }
zle -N vi-ls
bindkey -M vicmd "^A" vi-ls
bindkey -M viins "^A" vi-ls

vi-fg() { zle vi-insert; zle kill-whole-line; BUFFER=fg; zle accept-line }
zle -N vi-fg
bindkey -M vicmd "^[v" vi-fg
bindkey -M viins "^[v" vi-fg

bindkey -M vicmd "^R" atuin-search-vicmd
bindkey -M vicmd 'k' up-line-or-history
bindkey -M vicmd 'j' down-line-or-history


vi-back() { zle vi-insert; zle kill-whole-line; cd .. ; zle accept-line }
zle -N vi-back
bindkey -M vicmd "^[W" vi-back
bindkey -M viins "^[W" vi-back

vi-pop() { zle vi-insert; zle kill-whole-line; popd; zle accept-line }
zle -N vi-pop
bindkey -M vicmd "^N" vi-pop
bindkey -M viins "^N" vi-pop

vi-nvim() { zle kill-whole-line; nvim; zle accept-line }
zle -N vi-nvim
bindkey -M vicmd "^[g" vi-nvim
bindkey -M viins "^[g" vi-nvim

vi-open() { zle kill-whole-line; open .; zle accept-line }
zle -N vi-open
bindkey -M vicmd "^O" vi-open
bindkey -M viins "^O" vi-open

export QTDIR=/usr/local/qt/5.15.2/clang_64
export PATH=$QTDIR:$QTDIR/bin:$PATH
export PATH=$PATH:~/bin/gobin/
export PATH=$PATH:~/.cargo/bin/
export PATH=$PATH:~/.nimble/bin/
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'


