#!/bin/bash

sudo apt-get update

# Optionally we can download ruby from sources or use RVM but for purpose of this task, we use ruby 2.3 from default repo.
sudo aptitude install -y ruby ruby2.3-dev build-essential wget libruby2.3 rubygems

sudo gem update --no-rdoc --no-ri
sudo gem install ohai chef --no-rdoc --no-ri

# Git clone cookbooks from the repo
cd /tmp
rm -Rf /tmp/gc-cookcookbs # Ensure that we always have the new version
git clone 