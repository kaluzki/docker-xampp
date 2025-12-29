# docker build src/base -f src/base/Dockerfile -t xampp/base
# docker run --rm -ti xampp/base bash

ARG from=debian:trixie-slim
FROM ${from}

LABEL org.opencontainers.image.authors="Demjan Kaluzki"
LABEL org.opencontainers.image.source="https://github.com/kaluzki/docker-xampp/tree/main/src/base/Dockerfile"

RUN <<EOF
    --mount=type=cache,target=/var/cache/apt,sharing=locked
    --mount=type=cache,target=/var/lib/apt,sharing=locked
    set -eux
    apt-get update
    apt-get install -y --no-install-recommends \
        bash-completion
EOF

RUN <<EOF cat >> /etc/bash.bashrc
[[ -f /etc/bash_completion ]] && . /etc/bash_completion
[[ -d "/etc/bashrc.d" ]] && {
  for script in "/etc/bashrc.d/"*.sh; do
    . "\$script"
  done
  unset script
}
EOF

COPY <<EOF /etc/bashrc.d/10-xampp.sh
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
EOF

ARG user=app
ARG uid=1000
RUN <<EOF
    set -eux
    groupadd -g ${uid} ${user}
    useradd -u ${uid} -g ${uid} -m -s /bin/bash -k /dev/null ${user}
EOF

USER ${user}
