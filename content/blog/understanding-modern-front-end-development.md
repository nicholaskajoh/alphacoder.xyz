+++
author = "Nicholas Kajoh"
date = 2018-11-09T13:06:00.000Z
draft = false
image = "/content/images/2018/12/pankaj-patel-536207-unsplash-sm.jpg"
slug = "understanding-modern-front-end-development"
tags = ["NPM","Babel","Webpack","Grunt","SASS"]
title = "Understanding modern front-end development"

+++


It can be overwhelming especially for newbies, to work with modern front-end tools as development processes have increased in complexity over the years. As a mostly back-end web developer, I’ve had my share of confusion and frustration trying to wrap my head around how things work. This article hopes to give you a big picture/bird’s eye view of how some of the more common tools used by front-end developers today fit together and the problems they solve/are trying to solve.

We’re going to discuss the following:

*   package managers (npm)
*   transpilers (Babel)
*   module bundlers (Webpack)
*   task runners (Grunt)
*   CSS preprocessors (SASS)

![](https://cdn-images-1.medium.com/max/800/1*AagfZZ8bGOI4iTbLqewg6Q.png)

npm logo ([https://www.npmjs.com](https://www.npmjs.com/))

One important principle you’ll learn as a Sofware Developer is DRY (Don’t Repeat Yourself). Once you see yourself writing the same code in three or more places in a project, you should find a way to abstract that functionality into a reusable function, class or module.

Front-end projects have a lot in common in terms of UI components and logic so it might be an even better idea to abstract functionalities into reusable libraries, so that they may be shared across projects. A ton of libraries have been built to do all sorts of things from handling AJAX requests to manipulating dates and images. In order to cut down dev time and/or not reinvent the wheel, front-end developers use many such libraries in their projects — sometimes all too much.

It can be difficult to manage these libraries (or dependencies, as they’re commonly called) manually. Even if your project has only three dependencies, it may be hard to keep everything clean and dandy because these dependencies could have their own dependencies! This is where a package manager comes in. Package managers automate the process of installing, upgrading, configuring and removing packages (or dependencies or libraries) in your project.

npm (Node Package Manager) is a popular package manager used by front-end developers today. It is the default package manager for Node.js, an environment for running JavaScript outside of a browser. npm uses a file named _package.json_ to know the dependencies required by your project, making it easy for you and your team to run a single command that installs all the libraries you need to run your application. You can start learning how to use npm by reading [_What is npm?_](https://docs.npmjs.com/getting-started/what-is-npm) from the official docs.

### Transpilers

![](https://cdn-images-1.medium.com/max/800/1*GH2R-pwLm2KcZjmEXc-O6Q.jpeg)

babel logo

Lack of browser support for some of the newer features of JavaScript ([ES6](http://es6-features.org)) has been a major challenge for many front-end developers who want to use the latest and greatest to write better code and ship features faster. Developers have also desired features not available in the language (such as type annotations, generics, namespaces, interfaces etc found in [TypeScript](https://www.typescriptlang.org)) or just wanted syntactic sugar (like the Python-like [CoffeeScript](https://coffeescript.org)). Transpilers are used to solve these problems.

A transpiler (AKA source-to-source compiler) is a type of compiler that takes the source code of a program in one language and produces the equivalent source code in another language. This means I can write [ES6 JavaScript](https://softwareengineering.stackexchange.com/a/306847) and have it converted to ES5 so that it can run on all modern browsers. I can also choose to write TypeScript, CoffeeScript, ClojureScript or Dart code, taking advantage of features that make it faster and scalable to build web apps.

Babel is a commonly used transpiler for converting ES6+ code into a backwards compatible version of JavaScript supported by current and older browsers. It is also used to accomplish specific tasks such as converting JSX in React.js code to JavaScript via plugins. You can try out and learn more about Babel from their official website: [babeljs.io](https://babeljs.io).

### Module Bundlers

![](https://cdn-images-1.medium.com/max/800/1*aCVL0uOhdAJXkrPWwv06yw.png)

webpack logo

Web development has become increasing JavaScript-centric over the years — Single-page Applications (SPAs), Progressive Web Apps (PWAs) and such. As front-end apps were growing in complexity, it was imperative to develop tools that could package an application (code, assets) and its dependencies into light-weight and performant bundles that will be understood by browsers.

The main function of a module bundler is to package JavaScript files for use in a web browser, but bundlers are also capable of transforming and bundling other assets such as CSS files and images.

Webpack is arguably the most popular JavaScript bundler in the wild today. It has advanced features such as bundle splitting, source maps, hot module reloading and lazy loading. You can learn more about Webpack here: [https://webpack.js.org/concepts](https://webpack.js.org/concepts/).

### Task Runners

![](https://cdn-images-1.medium.com/max/800/1*qkmnWMz2Nr8FA72wK-ZLjA.png)

grunt logo

Task runners make life easier by doing what they do — run tasks! During development, front-end engineers find themselves repeating the same things (such as minification, compilation, unit-testing and linting) over and over again. The time used in performing these mundane tasks can be better spent doing more important things like squashing bugs and adding new features. Task runners help you automate these tasks so that you can run them quickly with one or a few commands.

Grunt is a popular task runner used in front-end apps. It uses a CLI to run custom tasks which can be defined in a file called _Gruntfile_. You can get started with Grunt by reading [the documentation](https://gruntjs.com/getting-started).

### CSS Preprocessors

![](https://cdn-images-1.medium.com/max/800/1*iSV5npwzchT-UqNPLSxPvQ.png)

sass logo

CSS preprocessors let you generate CSS from their own unique syntax. There are many CSS preprocessors available which provide features that don’t exist in pure CSS such as mixins, selector nesting, selector inheritance etc. These features make your CSS DRY, help you write modular code, save time, create reusable components and maintain large projects fairly easily.

A popular option for a CSS processor is SASS, which stands for Syntactically Awesome Style Sheet. SASS supports variables, loops, mixins with arguments etc. You can learn more about SASS by reading [the official guide](https://sass-lang.com/guide).

### Frameworks and Boilerplates?

Frameworks and boilerplates combine several front-end dev tools (some of which we discussed in this article) to provide a starting point for developing web applications. Instead of setting up and configuring all these tools every time you want to start a new project, you can just pull up a framework or boilerplate that already has everything up and ready to go.