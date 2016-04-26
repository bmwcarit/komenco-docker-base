# Copyright (C) 2015, BMW Car IT GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

FROM ubuntu:15.10
MAINTAINER Michael Knapp <michael.knapp@bmw-carit.de>

# set timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# install needed packages
RUN apt-get update && \
	apt-get install -y \
		apache2 \
		curl \
		dpkg \
		git \
		libapache2-mod-php5 \
		net-tools \
		openssl \
		patch \
		php5 \
		php5 \
		php5-curl \
		php5-mcrypt \
		php5-sqlite \
		php5-xdebug \
		tar \
		unzip && \
	apt-get clean

# enable rewrite module
RUN a2enmod rewrite

# configure php
RUN sed -i -e 's/;date.timezone.*/date.timezone = Europe\/Berlin/g' /etc/php5/apache2/php.ini && \
	sed -i -e 's/display_errors.*/display_errors = On/g' /etc/php5/apache2/php.ini && \
	sed -i -e 's/html_errors.*/html_errors = On/g' /etc/php5/apache2/php.ini && \
	sed -i -e 's/variables_order.*/variables_order = "EGPCS"/g' /etc/php5/apache2/php.ini && \
	echo "xdebug.max_nesting_level = 200" >> /etc/php5/apache2/conf.d/20-xdebug.ini && \
	sed -i -e 's/memory_limit.*/memory_limit = 4096M/g' /etc/php5/apache2/php.ini

# configure php
RUN sed -i -e 's/;date.timezone.*/date.timezone = Europe\/Berlin/g' /etc/php5/cli/php.ini && \
	sed -i -e 's/display_errors.*/display_errors = On/g' /etc/php5/cli/php.ini && \
	sed -i -e 's/html_errors.*/html_errors = On/g' /etc/php5/cli/php.ini && \
	sed -i -e 's/variables_order.*/variables_order = "EGPCS"/g' /etc/php5/cli/php.ini && \
	echo "xdebug.max_nesting_level = 200" >> /etc/php5/cli/conf.d/20-xdebug.ini && \
	sed -i -e 's/memory_limit.*/memory_limit = 4096M/g' /etc/php5/cli/php.ini

# install composer
RUN curl -sSL https://getcomposer.org/installer | php -- --install-dir=bin --filename=composer

# install gosu$
RUN curl -o gosu -sSL "https://github.com/tianon/gosu/releases/download/1.6/gosu-$(dpkg --print-architecture)" && \
	chmod +x gosu && \
	mv gosu /usr/bin

# configure apache server
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf
RUN sed -i 's/APACHE_RUN_USER.*/APACHE_RUN_USER=komenco/g' /etc/apache2/envvars

# add start script
COPY start.sh /data/start.sh

# add boot script
COPY boot.sh /data/boot.sh

# set the default user id
ENV DEFAULT_UID 1000

# expose apache http port
EXPOSE 80

ENTRYPOINT ["/data/boot.sh"]
