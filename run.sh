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

    05)
        FILE=generated/adv05-gen.fs
        awk 'BEGIN { FS = "[|,]"; print "CREATE rules" }                \
             NF == 2 { print $1 " , " $2 " ,"; next }                   \
             NF > 0 { if (!rules) { print "0 ,"; print "CREATE pages" } \
                      rules = 1; p = $1;                                \
                      for (i = 2; i <= NF; i++) p = p " , " $i;         \
                      print p " , 0 ," }                                \
             END { print "0 ," }' adv05.txt > $FILE
        cat adv05.fs >> $FILE
        gforth $FILE -e bye
        ;;

    06)
        build/06
        ;;

    07)
        FILE=generated/adv07-gen.erl
        cat adv07.erl > $FILE
        awk 'BEGIN { print "data() -> [" }           \
             { gsub(/: /, ",["); gsub(/ /, ",");     \
               s[NR] = "{" $0 "]}" }                 \
             END { for (i = 1; i <= NR; i++)         \
                     print s[i] (i < NR ? "," : ""); \
                   print "]." }' adv07.txt >> $FILE
        escript $FILE
        ;;

    08)
        FILE=generated/adv08-gen.l
        awk 'BEGIN { print "(setq data '\''(" } \
             { print "\"" $0 "\"" }             \
             END { print "))" }' adv08.txt > $FILE
        cat adv08.l >> $FILE
        pil $FILE -bye
        ;;

    09)
        build/09
        ;;

    10)
        build/10
        ;;

    11)
        FILE=generated/adv11-gen.pl
        cat adv11.pl > $FILE
        awk '{ gsub(/ /, ","); print "data([" $0 "])." }' adv11.txt >> $FILE
        swipl -q -l $FILE -t solve
        ;;

    *)
        echo "Invalid problem number!"
        ;;
esac
