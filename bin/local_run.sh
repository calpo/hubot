#!/bin/sh

cd `dirname $0`
cd ..

source ./bin/environments.sh
./bin/hubot -n hubot
