CC = gcc
CFLAGS = -O3 -fopt-info-optall=options.txt

all: threadring.c
	$(CC) $(CFLAGS) -pthread -o threadring threadring.c