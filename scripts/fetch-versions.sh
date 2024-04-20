#!/usr/bin/env bash

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKERFILE="${__dir}/../Dockerfile.base"

##
# fetch latest versions from the internets
##
ruby_install_latest=$(curl -s https://api.github.com/repos/postmodern/ruby-install/releases/latest | grep tag_name | cut -d\" -f4)
chruby_latest=$(curl -s https://api.github.com/repos/postmodern/chruby/releases/latest | grep tag_name | cut -d\" -f4)
golang_latest=$(curl -s 'https://go.dev/dl/?mode=json' | grep version | head -1 | cut -d\" -f4)

##
# fetch versions described in Dockerfile.base
##
ruby_install_docker=$(grep "ARG" "${DOCKERFILE}" | grep "ruby_install_version" | cut -d= -f2 | tr -d \")
chruby_docker=$(grep "ARG" "${DOCKERFILE}" | grep "chruby_version" | cut -d= -f2 | tr -d \")
golang_docker=$(grep "ARG" "${DOCKERFILE}" | grep "golang_version" | cut -d= -f2 | tr -d \")

##
# record version diffs
##
updates_needed=()
if [[ "$ruby_install_docker" != "$ruby_install_latest" ]]; then updates_needed+=("ruby-install"); fi
if [[ "$chruby_docker" != "$chruby_latest" ]]; then updates_needed+=("chruby"); fi
if [[ "$golang_docker" != "$golang_latest" ]]; then updates_needed+=("golang"); fi

##
# display results
##
echo "Dockerfile versions"
echo "-------------------"
echo "ruby-install: ${ruby_install_docker}"
echo "chruby: ${chruby_docker}"
echo "golang: ${golang_docker}"
echo
echo "Latest versions"
echo "---------------"
echo "ruby-install: ${ruby_install_latest}"
echo "chruby: ${chruby_latest}"
echo "golang: ${golang_latest}"
echo
echo "Required updates: ${updates_needed[*]}"
echo
