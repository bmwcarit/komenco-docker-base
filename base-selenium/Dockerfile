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

# install php an all needed packages
RUN apt-get update && \
		apt-get install -y \
			openjdk-7-jdk \
			libxrandr2 \
			unzip \
			xvfb \
			wget && \
		apt-get clean

# install chrome & firefox & xvfb
# install chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
	&& echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list

RUN apt-get update && \
	apt-get install -y \
		google-chrome-stable \
		firefox && \
	apt-get clean

RUN mv /usr/bin/google-chrome /usr/bin/google-chrome-sandbox && \
	echo '#!/bin/bash' > /usr/bin/google-chrome && \
	echo '/usr/bin/google-chrome-sandbox --no-sandbox --disable-setuid-sandbox $@' >> /usr/bin/google-chrome && \
	chmod a+x /usr/bin/google-chrome

# install chrome driver
WORKDIR /opt
RUN wget -q http://chromedriver.storage.googleapis.com/2.21/chromedriver_linux64.zip && \
	unzip chromedriver_linux64.zip && \
	rm chromedriver_linux64.zip && \
	mv chromedriver /usr/bin && \
	chmod 755 /usr/bin/chromedriver

# install selenium
RUN wget -P /opt http://selenium-release.storage.googleapis.com/2.53/selenium-server-standalone-2.53.0.jar && \
	ln -s selenium-server-standalone-2.53.0.jar selenium-server-standalone.jar

ADD start.sh /opt/start.sh

EXPOSE 4444

CMD ["/bin/bash", "/opt/start.sh"]
