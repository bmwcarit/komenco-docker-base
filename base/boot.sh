#!/bin/bash

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

env
USER=komenco

# create user
if [ -z "$DEV_UID" ]
then
	DEV_UID=$DEFAULT_UID
fi

#DEV_UID=${DEV_UID:=$DEFEAULTu_UID}
echo "uid: $DEV_UID"
useradd -u $DEV_UID -m $USER

# patch apache to run as komenco user
cp /etc/httpd/conf/httpd.conf.bak /etc/httpd/conf/httpd.conf
sed -i 's/User apache/User komenco/g' /etc/httpd/conf/httpd.conf

# execute start script as komenco user
cd data
chown -R $USER /data/src
export HOME=/home/$USER
CMD="source $HOME/.bashrc; ./start.sh $@"
gosu $USER /bin/bash -c "$CMD"

echo "Loading environment: $APP_ENVIRONMENT"
if [ "$APP_ENVIRONMENT" == "dev" ]; then
	# export the ip address of the simpleid server
	export KOMENCO_SIMPLEID_IP="$OPENID_PORT_443_TCP_ADDR"
fi

# start apache server as root
/usr/sbin/httpd -D FOREGROUND
