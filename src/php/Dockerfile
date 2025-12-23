# docker build src/php -f src/php/Dockerfile -t xampp/php:8.5 -t xampp/php
# docker build src/php -f src/php/Dockerfile -t xampp/php:8.4 --build-arg php=8.4-fpm
# docker build src/php -f src/php/Dockerfile -t xampp/php:7.4 --build-arg php=7.4-fpm --build-arg xdebug=3.1.6
# docker run --rm -ti xampp/php:7.4 bash

ARG php=8.5-fpm
ARG xdebug=stable
FROM php:${php}

ARG xdebug
RUN <<EOF
set -e
apt-get update
apt-get install -y --no-install-recommends \
    bash-completion \
    unzip
docker-php-ext-install \
    pcntl \
    pdo \
    pdo_mysql \
    sockets
pecl install xdebug-${xdebug}
rm -rf /var/lib/apt/lists/*
curl -fsSL https://starship.rs/install.sh | sh -s -- -y
EOF

### USER
ARG user=app
RUN <<EOF
groupadd -g 1000 ${user}
useradd -u 1000 -g 1000 -m -s /bin/bash -k /dev/null ${user}
EOF

### PHP-FPM
COPY <<EOF /usr/local/etc/php-fpm.d/zz-xampp.conf
[www]
listen=/var/run/php/php-fpm.sock
user=
group=
listen.owner=${user}
listen.group=${user}
EOF

RUN <<EOF
[ -f /usr/local/sbin/php-fpm ] && mv /usr/local/sbin/php-fpm /usr/local/sbin/php-fpm-prod || true
mkdir -p /var/run/php
chown ${user}:${user} /var/run/php
EOF

COPY <<EOF /usr/local/sbin/php-fpm
#! /bin/sh
set -e
APP_ENV=\${APP_ENV:-prod}
if [ "\$APP_ENV" != "prod" -a "\$APP_ENV" != "production" ]; then
  exec php-fpm-dev "\$@"
else
  exec php-fpm-prod "\$@"
fi
EOF

COPY <<EOF /usr/local/sbin/php-fpm-dev
#! /bin/sh
set -e
exec php-fpm-prod -d zend_extension=$(php-config --extension-dir)/xdebug.so "\$@"
EOF

### PHP
RUN mv /usr/local/bin/php /usr/local/bin/php-prod

COPY <<EOF /usr/local/bin/php
#! /bin/sh
set -e
APP_ENV=\${APP_ENV:-prod}
if [ "\$APP_ENV" != "prod" -a "\$APP_ENV" != "production" ]; then
  exec php-dev "\$@"
else
  exec php-prod "\$@"
fi
EOF

COPY <<EOF /usr/local/bin/php-dev
#! /bin/sh
set -e
export XDEBUG_TRIGGER=1
exec php-prod -d zend_extension=$(php-config --extension-dir)/xdebug.so "\$@"
EOF

COPY <<EOF /usr/local/etc/php/conf.d/xdebug.ini
xdebug.mode=debug,develop
xdebug.start_with_request=trigger
xdebug.log_level=0
xdebug.connect_timeout_ms=50
xdebug.discover_client_host=yes
xdebug.client_host=host.docker.internal
EOF

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY --from=ghcr.io/roadrunner-server/roadrunner /usr/bin/rr /usr/local/bin/rr

RUN <<EOF
chmod +x -R /usr/local/bin
chmod +x -R /usr/local/sbin
composer completion bash > /usr/share/bash-completion/completions/composer
rr completion bash > /usr/share/bash-completion/completions/rr
starship completions bash > /usr/share/bash-completion/completions/starship
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

#ADD --chmod=644 \
#https://raw.githubusercontent.com/twolfson/sexy-bash-prompt/refs/tags/1.1.0/.bash_prompt \
#/etc/bashrc.d/sexy-bash-prompt.sh

###STARSHIP
COPY <<EOF /etc/starship.d/starship.toml
add_newline = false
[hostname]
ssh_only = false
trim_at = ''
#format = '[\$ssh_symbol](bold blue)\e]8;;https://\$hostname\a[\$hostname](bold red)\e]8;;\a '
#format = '[\$ssh_symbol](bold blue)[\e]8;;https://\$hostname\a\$hostname\e]8;;\a](bold red) '
format = '[\$ssh_symbol](bold blue)[https://\$hostname](bold red) '
[git_branch]
symbol = '🌱 '
[container]
disabled = true
EOF
COPY <<EOF /etc/bashrc.d/90-starship.sh
[[ "\${ENV_PROMPT-starship}" == "starship" ]] && which starship > /dev/null && {
  export STARSHIP_CONFIG=/etc/starship.d/starship.toml
  eval "$(starship init bash)"
}
EOF

USER ${user}
WORKDIR /app
ENV PHP_IDE_CONFIG="serverName=app.localhost"

