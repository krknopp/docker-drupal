#!/bin/bash

# Add gitlab to hosts file
grep -q -F "$GIT_HOSTS" /etc/hosts  || echo $GIT_HOSTS >> /etc/hosts

# Clone repo to container
git clone -b $GIT_BRANCH $GIT_REPO /var/www/site/

# Symlink Settings file if not already done
cd /var/www/site/docroot/sites/default && ln -s remote.settings.php settings.php

# Symlink files folder
cd /var/www/site/docroot/sites/default && ln -sfn /mnt/sites-files/public files
cd /var/www/site/ && ln -sfn /mnt/sites-files/private private
