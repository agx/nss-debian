#!/bin/bash
#
# Check some basic CA operations

set -e

cleanup() {
    [ -z "$DIR" ] || rm -rf "$DIR"
}


run_certutil() {
    CMD="certutil -z $DIR/random -f $DIR/passwd -d sql:$DIR $@"
    echo "Running: $CMD"
    $CMD
}

DIR=`mktemp -p . -d`
trap cleanup EXIT ERR

dd  bs=20 count=1 if=/dev/urandom of=$DIR/random 2>/dev/null
echo "password" > $DIR/passwd

# Create the database
run_certutil -N
# Create a self signed certificate
run_certutil -S -k rsa -n test-ca -s CN=testca -t c -x 2>/dev/null
# Create a certificate request
run_certutil -R -k rsa -g 2048 -n test-cert -s "CN=testcert" -o $DIR/cert.req -a 2>/dev/null
# Sign with ca
run_certutil -C -m 10000 -c test-ca -i $DIR/cert.req -o $DIR/cert.cer -a
run_certutil -A -n test-cert -i $DIR/cert.cer -t c -a

echo -n "Checking if ca is present..."
run_certutil -L -n test-ca >/dev/null
echo "OK."

echo -n "Checking if cert present..."
run_certutil -L -n test-cert >/dev/null
echo "OK."

exit 0
