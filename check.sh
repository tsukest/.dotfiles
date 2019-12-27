#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

readonly ROOT_PATH="$(realpath $(dirname $0))"
readonly DOTFILES=$(find ${ROOT_PATH} -type f -name '.*' | xargs -I{} basename {})
for dotfile in ${DOTFILES}; do
  dotfilename=$(basename "${dotfile}")
  linkfile="${HOME}/${dotfilename}"
  message="exist"
  if [[ ! "$(ls -l ${linkfile} 2> /dev/null | cut -c 1)" == "l"  ]]; then
    message="not ${message}"
  fi
  printf "%-9s    %s\n" "${message}" "${linkfile}" 1>&2
done

readonly CONFIG_FILES=$(find ${ROOT_PATH}/.config/* -type f)
for config_file in ${CONFIG_FILES[@]}; do
  relative_file_path="$(echo "${config_file}" | sed -r 's/.*\/(.config\/.*)$/\1/')"
  linkfile="${HOME}/${relative_file_path}"
  message="exist"
  if [[ ! "$(ls -l ${linkfile} 2> /dev/null | cut -c 1)" == "l"  ]]; then
    message="not ${message}"
  fi
  printf "%-9s    %s\n" "${message}" "${linkfile}" 1>&2
done
