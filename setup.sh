#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

readonly ROOT_PATH="$(realpath $(dirname $0))"
readonly DOTFILES=$(find ${ROOT_PATH} -type f -name '.*' | xargs -I{} realpath {})
for dotfile in ${DOTFILES[@]}; do
  TARGET="${dotfile}"
  LINK_NAME="${HOME}/$(basename ${dotfile})"

  if [[ -f "${LINK_NAME}" ]]; then
    echo "${dotfile} aready exists" 1>&2
    continue
  fi
  ln -s "${TARGET}" "${LINK_NAME}"
  echo "create ${LINK_NAME}" 1>&2
done

readonly CONFIG_FILES=$(find ${ROOT_PATH}/.config/* -type f)
for config_file in ${CONFIG_FILES[@]}; do
  RELATIVE_FILE_PATH="$(echo "${config_file}" | sed -r 's/.*\/(.config\/.*)$/\1/')"
  mkdir -p "${HOME}/$(dirname ${RELATIVE_FILE_PATH})"
  TARGET="${config_file}"
  LINK_NAME="${HOME}/${RELATIVE_FILE_PATH}"

  if [[ -f "${LINK_NAME}" ]]; then
    echo "${config_file} aready exists" 1>&2
    continue
  fi
  ln -s "${TARGET}" "${LINK_NAME}"
  echo "create ${LINK_NAME}" 1>&2
done
