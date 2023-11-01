#!/usr/bin/env bash

echo "ruby-instal: $(curl -s https://api.github.com/repos/postmodern/ruby-install/releases/latest | grep tag_name | cut -d\" -f4)"
echo "chruby: $(curl -s https://api.github.com/repos/postmodern/chruby/releases/latest | grep tag_name | cut -d\" -f4)"
echo "golang: $(curl -s 'https://go.dev/dl/?mode=json' | grep version | head -1 | cut -d\" -f4)"
