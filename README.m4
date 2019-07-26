changequote({{,}})dnl
define(include_and_indent, {{esyscmd({{sed -e 's/^/    /' $1}})dnl}})dnl

# TypeScript / React / Webpack / Visual Studio Code Quick Start

Note to self for setting up a basic React/TypeScript/Webpack project
with Visual Studio Code (VSC).

A lot of this is collected from <https://www.typescriptlang.org/docs/handbook/react-&-webpack.html> and <https://webpack.js.org/guides.>

## Prerequisites

This assumes you have [node.js and NPM](https://nodejs.org/en/) installed.

# Basic Node Project setup

Create the project toplevel directory:

    mkdir typescript-react-vsc-quickstart
    cd typescript-react-vsc-quickstart
    mkdir -p {dist,src/components}

Initialize a node package for the project:

    % npm init
    package name: (typescript-react-vsc-quickstart2) 
    version: (1.0.0) 
    description: Fabulous Project
    entry point: (index.js) 
    test command: 
    git repository: 
    keywords: 
    author: Marc Liyanage
    license: (ISC) 
    [...]
    Is this OK? (yes) 

Adjust the resulting `package.json` file by adding:

    "private": true

and removing:

    "main": index.js

Install a few packages that provide TypeScript, React, and React TypeScript bindings, which
Visual Studio Code will use to provide intelligent suggestions etc.:

    npm install --save-dev typescript
    npm install --save react react-dom @types/node @types/react @types/react-dom

Install webpack and related libraries:

    npm install --save-dev webpack webpack-cli
    npm install --save-dev awesome-typescript-loader source-map-loader

# TypeScript Configuration

Create a basic TypeScript configuration file as `tsconfig.json`:

include_and_indent(tsconfig.json)

## HTML and TS files

Create a component, a main code file, and a main HTML file to load it all.

### src/components/Message.tsx

include_and_indent(src/components/Message.tsx)

### src/index.tsx

include_and_indent(src/index.tsx)

### dist/index.html

include_and_indent(dist/index.html)

## Add a webpack Configuration File

Add a `webpack.config.js` file. This is based on <https://www.typescriptlang.org/docs/handbook/react-&-webpack.html.>

include_and_indent(webpack.config.js)

## Add build and watch Commands

Add a "build" and "watch" command to the "scripts" section of your `package.json` file:

    "build": "npx webpack --config webpack.config.js",
    "watch": "npx webpack --config webpack.config.js --watch"

## Build the Project

You should now be able to build your project with:

    npm run build

The output will look something like:

    Version: webpack 4.29.6
    Time: 4123ms
    Built at: 03/05/2019 10:32:26 PM
            Asset      Size  Chunks             Chunk Names
        bundle.js  6.05 KiB    main  [emitted]  main
    bundle.js.map  5.03 KiB    main  [emitted]  main
    Entrypoint main = bundle.js bundle.js.map
    [./src/index.tsx] 335 bytes {main} [built]
    [react] external "React" 42 bytes {main} [built]
    [react-dom] external "ReactDOM" 42 bytes {main} [built]
        + 1 hidden module

Now open the main `dist/index.html` file in your browser to test the code.

## Run watch mode

Webpack's watch mode can continuously rebuild your project whenever you save files in VSC.
To start watch mode, run:

    npm run watch

It should be pretty fast for incremental builds. Just reload the `index.html` file to see the changes.

## Run with dev-server

There is also a [dev-server](https://webpack.js.org/guides/development/#using-webpack-dev-server) to automate the manual reload that's needed in watch mode. To set it up:

    npm install --save-dev webpack-dev-server

This requires the following section in `webpack.config.js`, already shown above:

    devServer: {
        contentBase: './dist'
    },

## Set up Git repo

Create a `.gitignore` file with these contents:

include_and_indent(.gitignore)

Init Git repo:

    git init
    git add .
    git commit -m init
