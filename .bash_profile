#
# ~/.bash_profile
#

export PATH=$PATH:${HOME}/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$(go env GOPATH)/bin

[[ -f ~/.bashrc ]] && . ~/.bashrc
