
# TypeScript / React / Webpack / Visual Studio Code Quick Start

This is mostly a long note to myself for setting up a basic React/TypeScript/Webpack
project with Visual Studio Code (VSC). Hopefully it is useful as a starting point for others.

A lot of this is collected from <https://www.typescriptlang.org/docs/handbook/react-&-webpack.html> and <https://webpack.js.org/guides.>

## Prerequisites

This assumes you have [node.js and NPM](https://nodejs.org/en/) installed.

# Basic Node Project setup

## Create the project toplevel directory

    mkdir typescript-react-vsc-quickstart
    cd typescript-react-vsc-quickstart
    mkdir -p {dist,src/components}

## Initialize a node package for the project

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

## Install prerequisite NPM packages

Install a few packages that provide TypeScript, React, and React TypeScript bindings, which
Visual Studio Code will use to provide intelligent suggestions etc.:

    npm install --save-dev typescript
    npm install --save react react-dom @types/node @types/react @types/react-dom

We will use the [webpack](https://webpack.js.org/concepts/) bundler and related libraries, so add those:

    npm install --save-dev webpack webpack-cli
    npm install --save-dev awesome-typescript-loader source-map-loader

## Install CSS-related packages

In this quickstart setup we'll bundle Bootstrap and our own CSS directly into
the output instead of loading from a CDN in order to make the resulting application
self-contained and usable without network access.

Install the Bootstrap NPM package as well as some webpack plugins
required for the bundling of CSS:

    npm install --save bootstrap jquery popper.js
    npm install --save-dev style-loader css-loader

You'll see these configured/used in the webpack.config.js file, shown below.

For more information about bundling CSS:

* https://getbootstrap.com/docs/4.0/getting-started/webpack/
* https://getbootstrap.com/docs/4.0/getting-started/download/#npm
* https://stackoverflow.com/a/24191605/182781

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
                        <div className="card-text">{this.props.children}</div>
                        <a href="#" className="btn btn-primary">Go somewhere</a>
                    </div>
                </div>
            );
        }
    }

### src/index.tsx

    import 'bootstrap';
    import 'bootstrap/dist/css/bootstrap.min.css';
    import './main.css';
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
    
        <title>Hello, world!</title>
      </head>
      <body>
        <div class="container mt-5">
          <h1>Hello, world!</h1>
          <div id="container" style="margin-top: 2em;">
          </div>
        </div>
        
        <script src="bundle.js"></script>
      </body>
    </html>

## Add a webpack Configuration File

Add a `webpack.config.js` file. This is based on <https://webpack.js.org/guides/typescript/>

    module.exports = {
        mode: "development",
        entry: "./src/index.tsx",
        output: {
            filename: "bundle.js",
            path: __dirname + "/dist"
        },
    
        devServer: {
            // old, webpack-dev-server < 4:
            // contentBase: './dist'
    
            // new, webpack-dev-server >= 4:
            static: [
                __dirname + '/dist',
            ],
    
            open: true
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
                { enforce: "pre", test: /\.js$/, loader: "source-map-loader" },
    
                // For bundling CSS
                { test: /\.css$/, use: ['style-loader', 'css-loader'] }
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

## Run serve mode

There is also a `webpack serve` command to automate the manual reload that's needed in watch mode.
To enable it, you have to install webpack-dev-server:

    npm install --save-dev webpack-dev-server

---
Note: At the time of writing (December 2020) webpack is at version 5 but webpack-dev-server
version 4, which introduces webpack 5 compatibility, is still in beta, so I had to install it
with:

    npm install webpack-dev-server@next --save-dev

---
webpack-dev-server requires the following section in `webpack.config.js`, already shown above:

    devServer: {
        static: [
            __dirname + '/dist',
        ],
        open: true
    },

(Note that this config snippet is also specific to webpack-dev-server version 4,
instead of `static` there used to be `contentBase`, see [the changelog](https://github.com/webpack/webpack-dev-server/compare/v3.11.0...v4.0.0-beta.0?short_path=06572a9#diff-06572a96a58dc510037d5efa622f9bec8519bc1beab13c9f251e97e657a9d4ed) for details.)

It also requires another additional entry in the `scripts` section of `package.json`:

    "start": "npx webpack serve"

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

## NPM Maintenance

Update NPM:

    npm install -g npm@latest

Various NPM commands:

Show outdated packages:    

    npm outdated

Update to current minor:

    npm update

Update to major:

    npm install package@latest

Force-update all to major:

    npm outdated | cut -f 1 -d ' ' | tail +2 | xargs -I{} npm install {}@latest

