#!/bin/bash

# if not a symlinked settings.php, replace with confd version
if [ ! -h $APACHE_DOCROOT/sites/default/settings.php ]
  then
    /usr/local/bin/confd -onetime -backend env -confdir="/root/drupal$(cat /root/drupal-version.txt)-settings"
fi
