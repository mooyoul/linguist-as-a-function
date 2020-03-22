#!/bin/bash

mkdir /tmp/bin
yum install -y cmake3 openssl-devel libicu-devel
ln -s /usr/bin/cmake3 /tmp/bin/cmake
bundle config set without 'test'
bundle config set path 'vendor/bundle'
env PATH=/tmp/bin:$PATH bundle install
