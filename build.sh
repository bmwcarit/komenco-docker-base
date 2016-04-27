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

CONTAINER_LIST=`ls -d */ | cut -d'/' -f1`
DOCKER_PREFIX="bmwcarit/komenco"
VERSION="latest"

BUILD_OPTIONS="$@"

function print_info ()
{
	echo "===================================="
	echo "$1 docker container: $2"
	echo "===================================="

}

# check if version is a tag
GIT_DESCRIBE=`git describe --tags`
if [[ "$GIT_DESCRIBE" =~ ^v?[0-9\.]+$ ]]
then
	VERSION=$GIT_DESCRIBE
fi

for i in $CONTAINER_LIST
do
	print_info "Build" "$DOCKER_PREFIX-$i:$VERSION"
	docker build -t $DOCKER_PREFIX-$i:$VERSION $BUILD_OPTIONS $i
done
