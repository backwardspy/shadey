CPP = c++
CFLAGS = -std=c++17 -Werror -Wall
LDFLAGS = -lsfml-graphics -lsfml-window -lsfml-system

.PHONY: all run clean

all: build/shadey

run: all
	build/shadey

clean:
	rm -rf build

build/shadey: src/main.cpp
	mkdir -p build
	$(CPP) $(CFLAGS) $(LDFLAGS) $< -o $@
