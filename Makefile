all: 02

02: generated/adv02.o
	ld -o build/$@ $<
generated/adv02.o: generated/adv02-gen.asm
	nasm -g -f elf64 -o $@ $<
generated/adv02-gen.asm: adv02.asm
	cp -f $< $@
	awk '{ line = "        db      "; \
               for (i = 1; i <= NF; i++)  \
                 line = line $$i ",";     \
               print line "-1" }          \
             END { print "reports equ    ", NR}' adv02.txt >> $@
