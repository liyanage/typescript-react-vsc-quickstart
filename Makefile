
all: dist/bundle.js

node_modules:
	npm install

dist/bundle.js: node_modules dist/index.html src/*.tsx src/components/*.tsx

README.md: README.m4 src/components/*.tsx src/*.tsx dist/index.html
	m4 $< > $@

start: dist/bundle.js
	npm run start

clean:
	rm -rf dist/bundle.js* node_modules