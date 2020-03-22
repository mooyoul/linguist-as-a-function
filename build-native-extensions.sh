#!/bin/bash

mkdir /tmp/bin
yum install -y cmake3 openssl-devel libicu-devel
ln -s /usr/bin/cmake3 /tmp/bin/cmake
env PATH=/tmp/bin:$PATH bundle install --without test --path=vendor/bundle