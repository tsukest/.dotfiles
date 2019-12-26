#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

readonly ROOT_DIR=$(realpath $(dirname $0))
readonly DOTFILES=$(find ./ -type f -name '.*' | xargs -I{} basename {})

for dotfile in ${DOTFILES[@]}; do
  TARGET="${ROOT_DIR}/${dotfile}"
  LINK_NAME="${HOME}/${dotfile}"

  if [[ -f "${LINK_NAME}" ]]; then
    echo "${dotfile} aready exists" 1>&2
    continue
  fi
  ln -s "${TARGET}" "${LINK_NAME}"
  echo "create ${LINK_NAME}" 1>&2
done
