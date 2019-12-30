#
# ~/.bash_profile
#

export PATH="${HOME}/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$(go env GOPATH)/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

[[ -f ~/.bashrc ]] && . ~/.bashrc

