FROM ubuntu:16.04

RUN apt-get update && apt-get -y upgrade
RUN apt-get update && apt-get install -y \
                ca-certificates curl cron git supervisor mysql-client\
		libxml2-dev mime-support ssmtp imagemagick ghostscript \
		php7.0-fpm php7.0-curl php7.0-gd php7.0-mysql php7.0-mcrypt php7.0-gmp php7.0-ldap  \
		php-pear php-console-table php-apcu php-mongodb \
		apache2 \
		vim \
        --no-install-recommends # && rm -r /var/lib/apt/lists/*

RUN a2enmod ssl rewrite proxy_fcgi headers

RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/supervisor /var/run/php /mnt/sites-files

# Install Drupal Console
ADD https://drupalconsole.com/installer /usr/local/bin/drupal
RUN chmod +x /usr/local/bin/drupal
RUN /usr/local/bin/drupal init --override
RUN /usr/local/bin/drupal settings:set checked "true"

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY www.conf /etc/php/7.0/fpm/pool.d/www.conf
COPY crons.conf /root/crons.conf
COPY start.sh /root/start.sh
COPY site.conf /etc/apache2/sites-available/000-default.conf
COPY php.ini /etc/php/7.0/fpm/php.ini

#Add cron job
RUN crontab /root/crons.conf

# Volumes
VOLUME ["/var/www/site", “/etc/apache2/sites-enabled”, "/mnt/sites-files"]

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
