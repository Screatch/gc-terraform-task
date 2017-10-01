#!/bin/bash
set -e

# Optionally we can download ruby from sources or use RVM but for purpose of this task, we use ruby 2.4 from PPA
sudo apt-add-repository ppa:brightbox/ruby-ng -y
sudo apt-get update

sudo apt-get install -y build-essential wget ruby2.4 ruby2.4-dev git libssl-dev

sudo gem update --no-rdoc --no-ri
sudo gem install ohai chef --no-rdoc --no-ri

cat >/usr/bin/local_chef_deploy <<EOL
	#!/bin/bash
	set -e

	# Git clone cookbooks from the repo
	cd /tmp
	sudo rm -Rf /tmp/gc-cookbooks # Ensure that we always have the new version
	git clone https://github.com/Screatch/gc-cookbooks-task.git gc-cookbooks

	cd gc-cookbooks
	sudo chef-solo -c solo.rb -j cookbooks/roles/web.json
EOL

sudo chmod +x /usr/bin/local_chef_deploy

# Start command
local_chef_deploy