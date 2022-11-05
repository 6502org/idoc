
# default build target
all: clean build

clean:
	rm -rf ./build/*

build:
	./data/build.sh

.PHONY: clean build
