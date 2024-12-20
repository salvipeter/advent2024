all: $(patsubst %, build/%, 02 06 09 10 13 15 17 18 20)

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
                 s = "     $$     ";                \
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

build/10: generated/adv10/go.mod generated/adv10/adv10-gen.go
	go build -C generated/adv10 -o $(shell pwd -P)/$@
generated/adv10/go.mod:
	mkdir -p generated/adv10
	echo 'module github.com/salvipeter/advent2024' > $@
	echo 'go 1.23.4' >> $@
generated/adv10/adv10-gen.go: adv10.go
	cat $< > $@
	awk 'BEGIN { FS = ""; print "var data = [][]int{" } \
             { s = "{";                                     \
               for (i = 1; i <= NF; i++) s = s $$i ",";     \
               print s "}," }                               \
             END { print "}" }' adv10.txt >> $@

build/13: generated/adv13.o
	zig build-exe -femit-bin=$@ $<
generated/adv13.o: generated/adv13-gen.zig
	zig build-obj -femit-bin=$@ $< # note issue #13179
generated/adv13-gen.zig: adv13.zig
	awk '/PLACEHOLDER/ { exit } { print }' $< > $@
	awk 'BEGIN { FS = "[ +=]" }                                   \
             /A:/ { print ".{ .a = .{ .x = " $$4 " .y = " $$6 " }," } \
 	     /B:/ { print ".b = .{ .x = " $$4 " .y = " $$6 " }," }    \
             /e:/ { print ".p = .{ .x = " $$3 " .y = " $$5 " } }," }' adv13.txt >> $@
	awk 'start { print } /PLACEHOLDER/ { start = 1 }' $< >> $@

build/15: generated/adv15-gen.c
	gcc -o $@ $<
generated/adv15-gen.c: adv15.c
	awk 'NR == 1 { print "int width =", length($$1) ";";         \
                       print "char map[][" length($$1) + 1 "] = {" } \
             /[#.O]/ { if (NR > 1) printf(",") }                     \
             /^$$/ { print "};\nchar moves[] ="; next }              \
             { print "\"" $$0 "\"" }                                 \
             END { print ";" }' adv15.txt > $@
	cat $< >> $@

build/17: generated/adv17-gen.rs
	rustc -o $@ $<
generated/adv17-gen.rs: adv17.rs
	awk '/Register/ { print "const", $$2, "u64 = ", $$3 ";" }                \
             /Program/ {                                                         \
               print "const PROGRAM: [u8;", split($$2, x, ",") "] = [" $$2 "];" \
             }' adv17.txt > $@
	cat $< >> $@

build/18: generated/adv18-gen.sml
	polyc -o $@ $<
generated/adv18-gen.sml: adv18.sml
	awk 'BEGIN { print "val data = [" }                 \
             { s = NR > 1 ? "," : ""; print s "(" $$0 ")" } \
             END { print "]" }' adv18.txt > $@
	cat $< >> $@

build/20: generated/adv20_gen.nim
	nim c -o:$@ --verbosity:0 -d:release $<
generated/adv20_gen.nim: adv20.nim
	awk 'BEGIN { print "const data: seq[string] = @[" } \
            { print "\"" $$0 "\"," }                        \
            END { print "]" }' adv20.txt > $@
	cat $< >> $@
