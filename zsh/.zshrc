# [[ -r ~/.local/share/znap/znap.zsh ]] ||
#     git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git ~/.local/share/znap
# source ~/.local/share/znap/znap.zsh
# znap source marlonrichert/zsh-autocomplete

# this is used for zsh fish autocomplete stuff which allows
# you to complete a portion of a path, separated by a /
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Disable globbing for URLs
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

if [[ $(uname) == "Darwin" ]]; then
  source /opt/homebrew/opt/asdf/libexec/asdf.sh

  # not sure if I need/want this stuff
  # export ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX=yes
  # test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
else
  source "$HOME/.asdf/asdf.sh"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi


# export ZSH_AUTOSUGGEST_STRATEGY=(completion)
export ZSH_AUTOSUGGEST_STRATEGY_2=(history)
export ZSH_AUTOSUGGEST_COMPLETION_IGNORE="(a *)|(git *)|(g *)|(g?)"

# source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/code/zsh-autosuggestions/zsh-autosuggestions.zsh

# these checks are to prevent ssh sessions from auto spawning another nested tmux
if [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then
  if [ "$TMUX" = "" ]; then
    # so we export tmux before opening the initial tmux sessions
    # cause otherwise in these original spawned sessions for
    # some reason you can't access the tmux commmand to
    # do something like tmux source ~/.tmux.conf
    # or for the ssh color changing feature
    #
    # Idk why this happens, it could be related to various other bugs
    # we've been seeing with tmux and setting of the $TMUX var
    if [ "$WINTYPE" = "dropdown" ]; then
      # export TMUX=tmux
      tmux new-session -A -s dropdown
    elif [ "$TERM" = "alacritty" ]; then
      printf "\e[?1042l"
      aerc
    else
      # export TMUX=tmux
      tmux new-session -A -s main
    fi
  fi
fi

# if $TMUX isn't set to anything then for some reason opening nvim crashes,
# this is some known bug which we've been discussing on the tmux github page
# export TMUX=tmux

export EDITOR=nvim

# this is to turn off the bouncing dock icon in alacritty on
# visual bell

PROMPT_COMMAND='echo -ne "\033]0;$(basename ${PWD})\007"'
precmd() { eval "$PROMPT_COMMAND" }


zstyle ':completion:*:cd:*' file-sort modification

bindkey -v
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1
bindkey '^R' history-incremental-search-backward
export CLICOLOR=1
setopt menu_complete

# adds the hostname to the prompt if you're sshing from
# somewhere
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

export PATH="/usr/local/opt/sqlite/bin:$PATH"
export PATH=node_modules/.bin:$PATH
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
STREAMS_FOLDER=/Volumes/HDD1A/streams-archive
STREAMS_FOLDER=/Volumes/SSD1/Streams

alias adl='aydl(){ cd $STREAMS_FOLDER; yt-dlp -f 234 --no-playlist  "$@" }; aydl'
alias a='adl'

timeToSecs() {
  echo $1 | sed 's/:/ /g;' | awk '{print $4" "$3" "$2" "$1}' | awk '{print $1+$2*60+$3*3600+$4*86400}'
}


ff() { find . -name "*$1*"; }

yt() {
  cd $STREAMS_FOLDER
  yt-dlp --no-playlist "$@"
}

y() {
  startTime=$(timeToSecs $2)
  endTime=$(timeToSecs $3)
  cd $STREAMS_FOLDER;
  # yt-dlp -S "+codec:avc:m4a" -f "bv[height<=?720]" --no-playlist --download-sections "*$startTime-$endTime" "${@:4}" -o "%(title)s [%(id)s] clip $startTime-$endTime.%(ext)s" $1
  yt-dlp  -f "bv[height<=?720]+ba/b[height<=720]" --no-playlist --download-sections "*$startTime-$endTime" "${@:4}" -o "%(title)s [%(id)s] clip $startTime-$endTime.%(ext)s" $1
  # yt-dlp  --no-playlist --download-sections "*$startTime-$endTime" "${@:4}" -o "%(title)s [%(id)s] clip $startTime-$endTime.%(ext)s" $1
}

yf() {
  cd $STREAMS_FOLDER;
  # yt-dlp -S "+codec:avc:m4a" -f "bv[height<=?720]" --no-playlist --download-sections "*$startTime-$endTime" "${@:4}" -o "%(title)s [%(id)s] clip $startTime-$endTime.%(ext)s" $1
  yt-dlp --no-playlist $1
}

function ns { ffmpeg -i "$1" -c copy -an "${1%.*}-nosound.${1#*.}" }

function fftrim { ffmpeg -ss $2 -i "$1" -to $3 -c copy "${1%.*}-trim.${1#*.}" }

mp4() { ffmpeg -i $1 -c:a aac -c:v libx264 -crf 24 "$(echo "$1"  | sed -e "s/\..*/\.mp4/")" }
mp4c() { ffmpeg -i $1 -c:a aac -c:v libx264 -crf $2 "$(echo "$1"  | sed -e "s/\..*/\-c.mp4/")" }

alias sf='singlef(){ cd ~/Screenshots/;  single-file --browser-executable-path /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome "$1"}; singlef'


######### blog stuff ####################################################################
cb() {
  cd ~/code/saint-blog/_posts
  new_post=$(./create_post.sh "$@")
  if [ "$?" -eq 2 ]; then
    echo $new_post
  else
    $EDITOR $new_post
  fi
  cd ..
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
alias p="python"

alias jk="jobs -p | grep -o -E '\s\d+\s'  | xargs kill -9"
alias ll="eza -l -smodified --no-user --no-permissions --color=always"
alias lt="eza -l -smodified --no-user --no-permissions -T -L 2 --color=always | less -r"
alias l=ll
alias reload="source ~/.zshrc"
alias lf="ls -tr1 | tail -n 1"
alias dush="du -sh * | gsort -h"
alias sudush="sudo du -sh * | gsort -h"
alias esp="nvim ~/Library/Application\ Support/espanso/match/base.yml"
alias kara="cd ~/code/karina/; nvim ~/code/karina/base.json"
alias karalog="tail -f ~/.local/share/karabiner/log/console_user_server.log"

alias tc="tmux new-session -A -t"

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
alias ts="trash"
alias src="vim ~/.zshrc"

# common paths
alias code="cd ~/code"
alias lazy="cd ~/.local/share/nvim/lazy"
alias el="open /Users/saint/Library/Developer/Xcode/DerivedData/eligius-frjwycapnyhfbfcdbfcycfnkwxqh/Build/Products/Release/eligius.app"
alias ke="killall eligius"
alias dd="cd /Users/saint/Library/Developer/Xcode/DerivedData/"
alias cs="v /Users/saint/.local/share/nvim/lazy/flesh-and-blood/colors/flesh-and-blood.vim"


rg2() { rg  --no-heading --line-number  "$@" | cut -d':' -f1-2 }

alias v='vim'
alias vrc='vim ~/.zshrc'

# git
alias g="git"
alias gd="git diff"
alias gs="git status"
alias ga="git ls"
alias gp="git pull"
alias gc='gc() { cd ~/code; git clone "$@"; cd "$(basename "$_" .git)"}; gc'
alias ghc='gh repo create --source .'
alias gt='gitui'
alias ghd='gh repo delete'


t() { cd $STREAMS_FOLDER; yt-dlp --cookies-from-browser brave "$@" }

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

vi-ls() {
  BUFFER_TRIM="$(echo -e "${BUFFER}" | tr -d '[:space:]')"
  zle vi-insert;
  if [[ ! -z $BUFFER_TRIM ]]; then
    zle complete-word
    BUFFER=$BUFFER"; l"
    zle accept-line;
  else
    BUFFER=l;
    zle accept-line
  fi
}

vi-lst() {
  BUFFER_TRIM="$(echo -e "${BUFFER}" | tr -d '[:space:]')"
  zle vi-insert;
  if [[ ! -z $BUFFER_TRIM ]]; then
    zle complete-word
    BUFFER=$BUFFER"; lt"
    zle accept-line;
  else
    BUFFER=lt;
    zle accept-line
  fi
}

zle -N vi-ls
bindkey -M vicmd "^A" vi-ls
bindkey -M viins "^A" vi-ls

zle -N vi-lst
bindkey -M vicmd "^[A" vi-lst
bindkey -M viins "^[A" vi-lst

vi-fg() { zle vi-insert; zle kill-whole-line; BUFFER=fg; zle accept-line }
zle -N vi-fg

bindkey -M vicmd "^[v" vi-fg
bindkey -M viins "^[v" vi-fg

bindkey -M vicmd "^R" atuin-search-vicmd
bindkey -M vicmd 'k' up-line-or-history
bindkey -M vicmd 'j' down-line-or-history

vi-back() { zle vi-insert; zle kill-whole-line; cd .. ; zle accept-line }
zle -N vi-back
bindkey -M vicmd "^[w" vi-back
bindkey -M viins "^[w" vi-back

vi-pop() { zle vi-insert; zle kill-whole-line; popd; zle accept-line }
zle -N vi-pop
bindkey -M vicmd "^N" vi-pop
bindkey -M viins "^N" vi-pop

vi-nvim() { zle kill-whole-line; nvim; zle accept-line }
zle -N vi-nvim
bindkey -M vicmd "^[g" vi-nvim
bindkey -M viins "^[g" vi-nvim

bindkey -M viins "^H" forward-word
bindkey -M viins "^[[A" forward-word
bindkey -M viins "^[n" autosuggest-fetch
bindkey -M viins "^[N" autosuggest-fetch_backward
bindkey -M viins "^[[B" autosuggest-execute


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


function ssh_tmux(){
    tmux set-window-option window-status-current-style fg=black,bg=magenta 2> /dev/null
    tmux set-window-option window-status-style fg=magenta,bg=black > /dev/null
    ssh "$@"
    tmux set-window-option window-status-current-style fg=black,bg=white 2> /dev/null
    tmux set-window-option window-status-style fg=white,bg=black 2> /dev/null
}
alias ssh=ssh_tmux


