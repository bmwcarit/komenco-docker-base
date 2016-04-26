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
		curl \
		dpkg \
		git \
		netcat \
		patch \
		php5 \
		php5-curl \
		php5-sqlite \
		unzip && \
	apt-get clean

# configure php
RUN sed -i -e 's/;date.timezone.*/date.timezone = Europe\/Berlin/g' /etc/php5/cli/php.ini && \
	sed -i -e 's/display_errors.*/display_errors = On/g' /etc/php5/cli/php.ini && \
	sed -i -e 's/memory_limit.*/memory_limit = 4096M/g' /etc/php5/cli/php.ini

# install composer
RUN curl -sSL https://getcomposer.org/installer | php -- --install-dir=bin --filename=composer

# install gosu
RUN curl -o gosu -sSL "https://github.com/tianon/gosu/releases/download/1.6/gosu-$(dpkg --print-architecture)" && \
	chmod +x gosu && \
	mv gosu /usr/bin

# add start script
COPY start.sh /data/start.sh

# add boot script
COPY boot.sh /data/boot.sh

CMD ["--version"]
ENTRYPOINT ["/data/boot.sh"]
