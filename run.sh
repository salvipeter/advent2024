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

    04)
        FILE=generated/adv04-gen.bqn
        awk 'BEGIN { FS = "" } \
             { s = s $0 }      \
             END { print "data←" NR "‿" NF "⥊\"" s "\"" }' adv04.txt > $FILE
        cat adv04.bqn >> $FILE
        bqn $FILE
        ;;

    *)
        echo "Invalid problem number!"
        ;;
esac
