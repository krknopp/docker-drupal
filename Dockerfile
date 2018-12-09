FROM php:7.1-apache

RUN echo "UTC" > /etc/localtime

RUN apt-get update && apt-get install -y \
                ca-certificates libcurl3 git mariadb-client vim unzip \
		zlib1g-dev libpng-dev libgmp-dev libldap2-dev rsync ssmtp \
        --no-install-recommends && apt-get -y upgrade && rm -r /var/lib/apt/lists/*

RUN a2enmod rewrite headers

# Configure PHP
RUN docker-php-ext-install zip gd pdo_mysql gmp ldap bcmath mbstring

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer \
&& ln -s /usr/local/bin/composer /usr/bin/composer

# Install Confd
ADD https://github.com/kelseyhightower/confd/releases/download/v0.15.0/confd-0.15.0-linux-amd64 /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd

COPY php.ini /usr/local/etc/php/php.ini
COPY site.conf /etc/apache2/sites-available/000-default.conf
COPY confd /etc/confd/

# Copy in drupal-specific files
#COPY wwwsite.conf drupal-settings.sh crons.conf start.sh mysqlimport.sh mysqlexport.sh mysqldropall.sh load-configs.sh xdebug-php.ini post-merge /root/
#COPY bash_aliases /root/.bash_aliases
#COPY drupal-settings /root/drupal-settings/

# Volumes
VOLUME /var/www/site /etc/apache2/sites-enabled /mnt/sites-files

EXPOSE 80

WORKDIR /var/www/site
