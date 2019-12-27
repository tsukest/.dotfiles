#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

readonly REPO_ROOT="$(realpath $(dirname $0))"
readonly DOTFILES=$(find ./ -type f -name '.*' | xargs -I{} basename {})

for dotfile in ${DOTFILES}; do
  dotfilename=$(basename "${dotfile}")
  linkfile="${HOME}/${dotfilename}"
  message="exist"
  if [[ ! "$(ls -l ${linkfile} 2> /dev/null | cut -c 1)" == "l"  ]]; then
    message="not ${message}"
  fi
  printf "%-9s    %s\n" "${message}" "${linkfile}" 1>&2
done
