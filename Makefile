
all: dist/bundle.js README.md

node_modules:
	npm install

dist/bundle.js: node_modules dist/index.html src/*.tsx src/*.css src/components/*.tsx webpack.config.js tsconfig.json package.json
	npm run build

README.md: README.m4 src/components/*.tsx src/*.tsx dist/index.html webpack.config.js tsconfig.json
	m4 $< > $@

start: dist/bundle.js
	npm run start

clean:
	rm -rf dist/bundle.js*

reallyclean: clean
	rm -rf node_modules
