

README.md: README.m4 src/components/Message.tsx src/index.tsx dist/index.html
	m4 $< > $@

start:
	npm run start

