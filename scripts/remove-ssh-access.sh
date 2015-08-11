#!/bin/sh

usage() {
    echo "usage: ./remove-ssh-access.sh user.name"
}

if [ $# -lt 1 ]; then
    usage
    exit 1
fi

sudo usermod -s /usr/bin/git-shell $1
