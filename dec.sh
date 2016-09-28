#! /bin/bash

input="$1"

echo -n $input | base64 -D | openssl rsautl -inkey ~/.ssh/id_rsa -decrypt
