#
# ~/.bash_profile
#

export PATH="${HOME}/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$(go env GOPATH)/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc

