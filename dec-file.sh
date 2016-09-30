#! /bin/bash

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
    decVal=`./dec.sh $encVal`

    newLine=`echo $line | sed -n "s|ENC:$encVal|$decVal|p"`

    echo $newLine

  else
    # No encrypted value found
    echo $line
  fi

done <$1
