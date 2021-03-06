#! /bin/bash

key="$HOME/.ssh/id_rsa" # default encryption key

while getopts ":k:h" opt; do
    case $opt in
        h)
            echo "enc.sh - encrypt a string"
            echo "Current user's private key is used for decryption by default"
            echo ""
            echo "Usage: enc.sh [-k <pem key file>] <string>"
            exit 0
            ;;
        k)
            key="$OPTARG"
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

shift $((OPTIND-1))

if [ "$#" == "0" ]; then
    echo "String to encrypt not specified.  Pass -h for help"
    exit 1
fi

input="$1"


echo -n $input | openssl rsautl -inkey $key -encrypt | base64
