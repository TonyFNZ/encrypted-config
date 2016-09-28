#! /bin/bash

echo -n $1 | openssl rsautl -inkey ~/.ssh/id_rsa -encrypt | base64
