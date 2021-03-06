#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.git-completion.bash
source ~/.git-prompt.sh

alias ls='ls --color=auto'

PS1='\[\033[01;34m\]\w\033[01;32m\]$(__git_ps1 "(%s)")\[\033[00m\]\$ '
IGNOREEOF=100

function pghql() {
  local -r selected_file=$(ghq list --full-path | peco --query "$LBUFFER")
  if [ -n "$selected_file" ]; then
    if [ -t 1 ]; then
      echo ${selected_file}
      cd ${selected_file}
    fi
  fi
}

function phist() {
    local tac
    which gtac &> /dev/null && tac="gtac" || \
        which tac &> /dev/null && tac="tac" || \
        tac="tail -r"
    READLINE_LINE=$(HISTTIMEFORMAT= history | $tac | sed -e 's/^\s*[0-9]\+\s\+//' | awk '!a[$0]++' | peco --query "$READLINE_LINE")
    READLINE_POINT=${#READLINE_LINE}
}
bind -x '"\C-r": phist'

function pcd() {
  maxdepth_flag=""
  [ $# -ne 0 ] && maxdepth_flag="-maxdepth $1"
  local -r selected_dir=$(find $maxdepth_flag -type d | peco)
  [ -n "$selected_dir" ] && cd $selected_dir
}

function pll() {
  maxdepth_flag=""
  [ $# -ne 0 ] && maxdepth_flag="-maxdepth $1"
  local -r selected=$(find $maxdepth_flag | peco)
  [ -n "$selected" ] && ls -l $selected
}

function pvim() {
  maxdepth_flag=""
  [ $# -ne 0 ] && maxdepth_flag="-maxdepth $1"
  local -r selected=$(find $maxdepth_flag | peco)
  [ -n "$selected" ] && vim $selected
}

function  rr() {
  cd "$(git rev-parse --show-toplevel)"
}
