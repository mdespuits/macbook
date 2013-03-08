#!/bin/sh

set -e

gem install bundler
bundle

sudo mkdir -p /usr/local/
sudo chown -R `whoami` /usr/local

# Install GCC + Git
# mkdir -p ~/tmp
# cd ~/tmp
# curl https://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.7-v2.pkg > GCC-10.7-v2.pkg
# sudo installer -pkg GCC-10.7-v2.pkg -target /

bundle exec chef-solo -c config/solo.rb -j config/node.json
