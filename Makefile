
# default build target
all: clean build

clean:
	rm -rf ./build/*

build:
	./scripts/build.sh

.PHONY: clean build
