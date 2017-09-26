#!/bin/bash

sudo apt-get update
sudo aptitude install -y ruby ruby2.3-dev build-essential wget libruby2.3 rubygems
sudo gem update --no-rdoc --no-ri
sudo gem install ohai chef --no-rdoc --no-ri

# Git clone cookbooks from the repo
