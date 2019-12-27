#!/bin/bash

REPO_ROOT="$(realpath $(dirname $0))"
DOTFILES=$(find "${REPO_ROOT}" -not -path '*git/*' -and -type f -name '.*')

for dotfile in ${DOTFILES}; do
  dotfilename=$(basename "${dotfile}")
  linkfile="${HOME}/${dotfilename}"
  message="exist"
  if [[ ! "$(ls -l ${linkfile} 2> /dev/null | cut -c 1)" == "l"  ]]; then
    message="not ${message}"
  fi
  printf "%-9s    %s\n" "${message}" "${linkfile}" 1>&2
done
