#! /bin/bash

key="$HOME/.ssh/id_rsa" # default encryption key

while getopts ":k:h" opt; do
    case $opt in
        h)
            echo "dec-file.sh - output the contents of a file and decrypt any encrypted strings found"
            echo "Encrypted strings must be prefixed with \"ENC:\" and must not have two on a single line"
            echo "Current user's private key is used for decryption by default."
            echo ""
            echo "Usage: dec-file.sh [-k <pem key file>] <file>"
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
    echo "File to decrypt not specified.  Pass -h for help"
    exit 1
fi



IFS='' # Keep leading spaces in source
while read line; do

  idx=`echo $line | sed -n "s/ENC:.*//p" | wc -c`

  if [ "$idx" -gt "0" ]; then
    # Encrypted value found

    encVal=${line:($idx+3)}

    idx=`echo $encVal | sed -n "s/\".*//p" | wc -c`

    if [ "$idx" -gt "0" ]; then
        encVal=${encVal:0:($idx-1)}
    fi
    decVal=`echo -n $encVal | base64 -D | openssl rsautl -inkey $key -decrypt`

    newLine=`echo $line | sed -n "s|ENC:$encVal|$decVal|p"`

    echo $newLine

  else
    # No encrypted value found
    echo $line
  fi

done <$1
