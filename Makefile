PATH := ./node_modules/.bin:${PATH}

.PHONY : init clean build test dist

init:
	npm install

clean:
	rm -rf lib/

build:
	coffee -b -o lib/ -c src/ 

test:
	mocha --recursive --compilers coffee:coffee-script

dist: clean init build test
