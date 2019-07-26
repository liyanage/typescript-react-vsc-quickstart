
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

    {
        "compilerOptions": {
            "outDir": "./dist/",
            "sourceMap": true,
            "noImplicitAny": true,
            "module": "commonjs",
            "jsx": "react"
        },
        "include": [
            "./src/**/*"
        ],
        "exclude": [
            "node_modules"
        ]
    }

## HTML and TS files

Create a component, a main code file, and a main HTML file to load it all.

### src/components/Message.tsx

    import * as React from "react";
    
    interface MessageProps {
        title: string;
    }
    
    export class Message extends React.Component<MessageProps> {
        constructor(props: MessageProps) {
            super(props);
        }
        render() {
            return (
                <div className="card">
                    <div className="card-body">
                        <h5 className="card-title">{this.props.title}</h5>
                        <p className="card-text">{this.props.children}</p>
                        <a href="#" className="btn btn-primary">Go somewhere</a>
                    </div>
                </div>
            );
        }
    }

### src/index.tsx

    import * as React from "react";
    import * as ReactDOM from "react-dom";
    import { Message } from "./components/Message";
    
    const tf = (
        <Message title="Hi">
            <p>Hello World</p>
        </Message>
    )
    ReactDOM.render(tf, document.querySelector("#container"));

### dist/index.html

    <!doctype html>
    <html lang="en">
      <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    
        <title>Hello, world!</title>
      </head>
      <body>
        <div class="container mt-5">
          <h1>Hello, world!</h1>
          <div id="container" style="margin-top: 2em;">
          </div>
        </div>
        
        <!-- Optional JavaScript -->
        <!-- jQuery first, then Popper.js, then Bootstrap JS -->
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
        <script src="bundle.js"></script>
      </body>
    </html>

## Add a webpack Configuration File

Add a `webpack.config.js` file. This is based on <https://www.typescriptlang.org/docs/handbook/react-&-webpack.html.>

    module.exports = {
        mode: "development",
        entry: "./src/index.tsx",
        output: {
            filename: "bundle.js",
            path: __dirname + "/dist"
        },
    
        devServer: {
            contentBase: './dist'
        },
    
        // Enable sourcemaps for debugging webpack's output.
        devtool: "source-map",
    
        resolve: {
            // Add '.ts' and '.tsx' as resolvable extensions.
            extensions: [".ts", ".tsx", ".js", ".json"]
        },
    
        module: {
            rules: [
                // All files with a '.ts' or '.tsx' extension will be handled by 'awesome-typescript-loader'.
                { test: /\.tsx?$/, loader: "awesome-typescript-loader" },
    
                // All output '.js' files will have any sourcemaps re-processed by 'source-map-loader'.
                { enforce: "pre", test: /\.js$/, loader: "source-map-loader" }
            ]
        },
    
        // When importing a module whose path matches one of the following, just
        // assume a corresponding global variable exists and use that instead.
        // This is important because it allows us to avoid bundling all of our
        // dependencies, which allows browsers to cache those libraries between builds.
        // externals: {
        //     "react": "React",
        //     "react-dom": "ReactDOM"
        // }
    };

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

and another additional entry in the `scripts` section of `package.json`:

    "start": "npx webpack-dev-server --open"

Now you can start it with

    npm run start

## Set up Git repo

Create a `.gitignore` file with these contents:

    node_modules
    dist/*
    !dist/index.html

Init Git repo:

    git init
    git add .
    git commit -m init
