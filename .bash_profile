#!/usr/bin/env bash

export EDITOR="nvim"
export GIT_EDITOR=$EDITOR

set -o vi

shopt -s globstar

# source etc/profile if it exists
[[ -f /etc/profile ]] && source /etc/profile

# reset the path
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Aliases ------------------------------------------------------------------{{{

alias ls="ls -lahG"
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias mkdir="mkdir -pv"
alias j="jump"
alias e="$EDITOR"
# go hard
alias vim="nvim"

# some tmux ones
alias clr="clear && tmux clear-history"
alias tl="tmux ls"
alias ta="tmux attach-session -t"
alias t="tmux new-session -s"

# }}}

# Completion stuff ----------------------------------------------------------{{{

[[ -f /etc/bash_completion ]] && source /etc/bash_completion

# }}}

# OS specific stuff ---------------------------------------------------------{{{

if [[ $(uname) -eq "Darwin" ]]; then
    if hash brew 2>/dev/null; then
        BREW_COMPLETION="$(brew --prefix)/etc/bash_completion"

        [[ -f $BREW_COMPLETION ]] && source $BREW_COMPLETION
    fi
fi

# }}}

# Neovim related stuff ------------------------------------------------------{{{

export PATH=$HOME/neovim/bin:$PATH

# }}}

# Go related stuff ----------------------------------------------------------{{{

export GOPATH=$HOME/code/go
export PATH=$GOPATH/bin:$PATH

hash go 2>/dev/null && export GOROOT="$(go env GOROOT)"

# }}}

# Git related stuff --------------------------------------------------------{{{

# use gh instead of git
hash gh 2>/dev/null && eval "$(gh alias -s)"

# }}}

# Ruby related stuff --------------------------------------------------------{{{

export PATH="$HOME/.rbenv/bin:$PATH"

# only init rbenv if it exists (duh)
hash rbenv 2>/dev/null && eval "$(rbenv init -)"

# }}}

# Lua related stuff ---------------------------------------------------------{{{

hash luarocks 2>/dev/null && eval "$(luarocks path)"

# }}}

# Perl related stuff --------------------------------------------------------{{{

PATH="$HOME/.plenv/bin:$PATH"

hash plenv 2>/dev/null && eval "$(plenv init -)"

# }}}

# PHP related stuff --------------------------------------------------------{{{

# load the bashrc file if it exists
[[ -f ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

# make sure we have the bin in path for composer n stuff
PATH="$PHPBREW_PATH/../sbin:$PHPBREW_PATH:$PATH"

# }}}

# OCaml related stuff -------------------------------------------------------{{{

[[ -f ~/.opam/opam-init/init.sh ]] && source ~/.opam/opam-init/init.sh

# }}}

# Nim(rod) related stuff ----------------------------------------------------{{{

PATH="$HOME/src/Nimrod/bin:$PATH"

# }}}

# Prompt configuration ------------------------------------------------------{{{

#[[ -f "~/.config/base16-shell/base16-solarized.light.sh" ]] \
    #&& source "~/.config/base16-shell/base16-solarized.light.sh"

[[ -f ~/.shell_prompt.sh ]] && source ~/.shell_prompt.sh

# }}}

# Mark related functions ----------------------------------------------------{{{

export MARKPATH=$HOME/.marks

# make it if it doesn't exist
[[ -d "$MARKPATH" ]] || mkdir "$MARKPATH"

function jump {
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}

function mark {
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}

function unmark {
    rm -i "$MARKPATH/$1"
}

function marks {
    ls -l "$MARKPATH" \
        | tail -n +2 \
        | sed 's/  / /g' \
        | cut -d' ' -f9- \
        | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}

_completemarks() {
  local curw="${COMP_WORDS[COMP_CWORD]}"
  local wordlist="$(find $MARKPATH -type l -exec basename {} ';')"

  COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
  return 0
}

complete -F _completemarks jump j unmark

# }}}

# Finishing ---------------------------------------------------{{{

# export the finalized path
export PATH=~/bin:~/managed-bin:$PATH

# source the local file if it exists
[ -f ~/.bash_profile.local ] && source ~/.bash_profile.local

# }}}

