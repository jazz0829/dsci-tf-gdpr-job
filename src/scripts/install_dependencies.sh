#!/usr/bin/env bash

INSTALL_COMMAND="sudo pip install"
dependencies="boto3"

sudo apt-get install python-pip
for dep in $dependencies; do
    $INSTALL_COMMAND $dep
done;