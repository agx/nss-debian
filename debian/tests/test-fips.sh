#!/bin/bash
#
# Enable fips mode

set -e

cleanup() {
    [ -z "$DIR" ] || rm -rf "$DIR"
}


run_modutil() {
    CMD="modutil -dbdir sql:$DIR $@"
    echo "Running: $CMD"
    $CMD
}

DIR=`mktemp -p . -d`
trap cleanup EXIT ERR

run_modutil -create < /dev/null
run_modutil -fips true < /dev/null

