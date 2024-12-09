all: build/*

build/02: generated/adv02.o
	ld -o $@ $<
generated/adv02.o: generated/adv02-gen.asm
	nasm -g -f elf64 -o $@ $<
generated/adv02-gen.asm: adv02.asm
	cp -f $< $@
	awk '{ line = "        db      "; \
               for (i = 1; i <= NF; i++)  \
                 line = line $$i ",";     \
               print line "-1" }          \
             END { print "reports equ    ", NR }' adv02.txt >> $@

build/06: generated/adv06-gen.hs
	ghc -O2 -o $@ $<
generated/adv06-gen.hs: adv06.hs
	cat $< > $@
	awk 'BEGIN { printf "d = [" } \
             NR != 1 { printf "," }   \
             { printf "\"%s\"", $$0 } \
             END { print "]" }' adv06.txt >> $@

build/09: generated/adv09-gen.for
	gfortran -std=f2023 -Wall -pedantic -fdefault-integer-8 -o $@ $<
generated/adv09-gen.for: adv09.for
	awk '/PLACEHOLDER/ { exit } { print }' $< > $@
	awk 'BEGIN { FS = "" }                      \
             { i = 1;                               \
               while (i <= NF) {                    \
                 s = "     $$";                     \
                 for (j = 1; j < 30; j++) {         \
                   s = s $$i;                       \
                   i++;                             \
                   if (i <= NF)                     \
                     s = s ",";                     \
                   else                             \
                     break                          \
                 }                                  \
                 print s                            \
               } }' adv09.txt >> $@
	awk 'start { print } /PLACEHOLDER/ { start = 1 }' $< >> $@
