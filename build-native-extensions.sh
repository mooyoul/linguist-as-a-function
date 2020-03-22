#!/bin/bash

mkdir /tmp/bin
yum install -y cmake3 openssl-devel libicu-devel
ln -s /tmp/bin/cmake /usr/bin/cmake3
env PATH=/tmp/bin:$PATH bundle install --without test --path=vendor/bundle