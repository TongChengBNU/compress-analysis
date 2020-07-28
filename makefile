all: cmpBinary timer2 timer parse split extract

cmpBinary: src/cmpBinary.c
	gcc -o bin/cmpBinary src/cmpBinary.c

timer2: src/timer2.cpp
	g++ -o bin/timer2 src/timer2.cpp

timer: src/timer.c
	gcc -o bin/timer src/timer.c
 
parse: src/regex.cpp
	g++ -o bin/parse src/regex.cpp

split: src/split.c
	gcc -o bin/split src/split.c

extract: src/extract.c
	gcc -o bin/extract src/extract.c

clean: 
	rm -f bin/*
	rm -rf sequence

