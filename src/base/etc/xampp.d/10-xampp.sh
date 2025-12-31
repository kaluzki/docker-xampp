#!/usr/bin/env bash

### prompt
set -o noclobber
shopt -s checkwinsize
# PROMPT_DIRTRIM=2
bind Space:magic-space
shopt -s globstar 2> /dev/null
shopt -s nocaseglob;
bind "set completion-ignore-case on"
bind "set completion-map-case on"
bind "set show-all-if-ambiguous on"
bind "set mark-symlinked-directories on"

### history
PROMPT_COMMAND='history -a'
shopt -s histappend
shopt -s cmdhist
HISTFILESIZE=100000
HISTCONTROL="erasedups:ignoreboth"
HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
HISTTIMEFORMAT='%F %T '
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

### navigation
export LC_COLLATE="C"
shopt -s autocd 2> /dev/null
shopt -s dirspell 2> /dev/null
shopt -s cdspell 2> /dev/null
#CDPATH="."
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias ll='ls --group-directories-first -FlAh --color=auto'
alias l='ls --group-directories-first -Flah --color=auto'
alias lt='ls --group-directories-first -FAlht --color=auto'

### disk usage
alias du='du -h'
alias df='df -h'
alias dus='du -hs .'

### grep
alias gr='grep -Hirn --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.idea'
