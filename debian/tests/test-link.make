#!/usr/bin/make -f

all: a.out
	./a.out
	rm -f a.out

a.out: debian/tests/test-link.cpp
	g++ -Wall -Werror $<  $(shell pkg-config --cflags nss) $(shell pkg-config --libs nss)

.PHONY: all
