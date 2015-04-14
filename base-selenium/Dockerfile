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

FROM fedora:21
MAINTAINER Michael Knapp <michael.knapp@bmw-carit.de>

# set timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# install php an all needed packages
RUN yum upgrade -y && \
	yum install -y \
		firefox \
		java-1.8.0-openjdk \
		libXrandr \
		wget \
		unzip && \
	yum clean all

# install chrome & firefox & xvfb
RUN wget -q https://dl-ssl.google.com/linux/linux_signing_key.pub && \
        rpm --import linux_signing_key.pub
ADD ./google-chrome.repo  /etc/yum.repos.d/google-chrome.repo

RUN yum upgrade -y && \
	yum install -y \
		google-chrome-stable \
		xorg-x11-server-Xvfb firefox && \
	yum clean all

RUN mv /usr/bin/google-chrome /usr/bin/google-chrome-sandbox && \
	echo '#!/bin/bash' > /usr/bin/google-chrome && \
	echo '/usr/bin/google-chrome-sandbox --no-sandbox --disable-setuid-sandbox $@' >> /usr/bin/google-chrome && \
	chmod a+x /usr/bin/google-chrome

# install chrome driver
WORKDIR /opt
RUN wget http://chromedriver.storage.googleapis.com/2.10/chromedriver_linux64.zip && \
	unzip chromedriver_linux64.zip && \
	rm chromedriver_linux64.zip && \
	mv chromedriver /usr/bin && \
	chmod 755 /usr/bin/chromedriver

# install selenium
RUN wget -P /opt http://selenium-release.storage.googleapis.com/2.44/selenium-server-standalone-2.44.0.jar && \
	ln -s selenium-server-standalone-2.44.0.jar selenium-server-standalone.jar

ADD start.sh /opt/start.sh

EXPOSE 4444

CMD ["/bin/bash", "/opt/start.sh"]
