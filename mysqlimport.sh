#!/bin/bash

# Check to see if variables have data in them.
if [ ! $MYSQL_SERVER ] || [ ! $MYSQL_USER ]; then
  >&2 echo "variables not populated"
  exit
fi

# Check to see if the drupal db has enough tables. if not, load starter.sql

if [ 'mysql -h $MYSQL_SERVER -e ";"' ]; then
  echo "MySQL connection successful"


  table_count=`mysql -B --disable-column-names --host $MYSQL_SERVER --execute="select count(*) from information_schema.tables where table_type = 'BASE TABLE' and table_schema = '$MYSQL_DATABASE'" -s`
  if [ "$?" = "0" ]; then
    echo "Successfully got table count of $table_count"
    if [ $table_count -lt 10 ]; then
      echo "Table count too low, checking for starter.sql"
      if [ -e /var/www/site/starter.sql ]; then
        echo "starer.sql exists. Starting import."
        mysql --host $MYSQL_SERVER $MYSQL_DATABASE < /var/www/site/starter.sql
      else
        echo "starter.sql doesn't exist.  Manually import database to continue."
      fi
    else
      >&2 echo "Database is already populated. Exiting script."
      exit
    fi

  else
    >&2 echo "We were not able to get table count from MySQL server"
  fi

fi
