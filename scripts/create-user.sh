#!/bin/sh

usage() {
    echo "usage: ./create-user.sh user.name"
}

if [ $# -lt 1 ]; then
    usage
    exit 1
fi

sudo adduser --force-badname --ingroup usuario $1
