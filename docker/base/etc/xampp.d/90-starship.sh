#!/usr/bin/env bash

[[ "${ENV_PROMPT-starship}" == "starship" ]] && which starship > /dev/null && {
  export STARSHIP_CONFIG=/etc/xampp.d/starship.d/starship.toml
  eval "$(starship init bash)"
}
