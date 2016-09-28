#! /usr/bin/env python
import sys, json, subprocess

def main():

    config = json.load( open( "./config.json" ) )

    scanDictionary( config )

    print json.dumps( config, sort_keys=True, indent=4, separators=(',', ': ') )

    return


def scanDictionary( input ):
    for key, value in input.iteritems():
        if isinstance( value, dict ):
            scanDictionary( value )

        elif isinstance( value, list ):
            scanList( value )

        elif isinstance( value, str ):
            if value.startsWith( "ENC:" ):
                input[ key ] = decryptValue( value )

        elif isinstance( value, unicode ):
            if value[:4] == u"ENC:":
                input[ key ] = decryptValue( value )
    return

def scanList( input ):
    for index, value in enumerate( input ):
        if isinstance( value, dict ):
            scanDictionary( value )

        elif isinstance( value, list ):
            scanList( value )

        elif isinstance( value, str ):
            if value.startsWith( "ENC:" ):
                input[ index ] = decryptValue( value )

        elif isinstance( value, unicode ):
            if value[:4] == u"ENC:":
                input[ index ] = decryptValue( value )

def decryptValue( input ):
    output = subprocess.check_output( ["./dec.sh", input[4:] ] )
    return output

if __name__ == "__main__":
    main()
