#!/bin/bash

if [ $# -ne 1 ] ; then
    echo "Usage: $0 <problem #>"
    exit 1
fi

case $(printf "%02d" $1) in

    01)
        FILE=generated/adv01-gen.uiua
        awk 'BEGIN { print "[" } { print $1 "_" $2 } END { print "]" }' adv01.txt > $FILE
        cat adv01.uiua >> $FILE
        uiua $FILE
        ;;

    02)
        build/02
        ;;

    03)
        gst -q adv03.st
        ;;

    *)
        echo "Invalid problem number!"
        ;;
esac
