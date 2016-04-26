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

set -e

SRC_DIR="/data/src"

cd $SRC_DIR

# do initial setup
if [ ! -d "./vendor" ]; then
	# install dependencies
	composer install -vvv --prefer-dist

	# patch dependencies
	./res/patches/apply-patches.sh ./vendor
fi

# disable ssl verification for dev environment
if [ "$APP_ENVIRONMENT" == "dev" ]; then
	VENDOR_FOLDER='/data/src/vendor'
	PATCHDIR='/data/src/res/patches'

	patch -i $PATCHDIR/0001-openid-Disable-ssl-host-verification.patch \
		-d $VENDOR_FOLDER/opauth/openid -p1 -N || true
fi

# build test classes
./vendor/bin/codecept build

echo "Give other containers time to start"
count=0
PORT=$(nc -z $SELENIUM_PORT_4444_TCP_ADDR 4444; echo $?)
while [ "$PORT" != "0" ]
do
	count=$(($count+1))
	if [ "$count" -gt 6 ]
	then
		echo "Selenium didn't come up: $SELENIUM_PORT_4444_TCP_ADDR:4444"
		exit
	fi

	echo "Selenium not ready: retry in 10 secs"
	sleep 10
	set +e
	PORT=$(nc -z $SELENIUM_PORT_4444_TCP_ADDR 4444; echo $?)
	set -e
done

# run tests
./vendor/bin/codecept $@
