---
title: "node_modules: The Node.js black hole"
slug: "node-modules"
date: 2020-05-25T23:33:11.565Z
draft: false
tags: ["Node.js"]
---

As a Node.js developer, you know just how large (in terms of number of files and directory size) node_modules can be (you've probably aready seen [the memes](https://www.reddit.com/r/ProgrammerHumor/comments/6s0wov/heaviest_objects_in_the_universe/)). But have you ever asked WHY? I hadn't, up until recently, after which I did some goofing around on the interwebs out of curiosity.

Turns out it has to do with 2 things:

1. How npm (the Node package manager) resolves dependencies.
2. How the Node.js community likes to develop packages.

# Dependency resolution

npm differs from other popular package managers such as pip and RubGems in terms of how it resolves dependencies. npm may download multiple versions of a package where as pip/RubyGems will attempt to find a single version that satisfies all its dependents.

Say your app has 2 dependencies _Package A_ and _Package B_, and _Package B_ depends on _Package C_, and _Package A_ and _Package C_ depend on _Package D_.

npm _might_ resolve your dependencies like so i.e downloading 2 copies of _Package D_.

![](/images/nde-mdls/npm-dep-graph.png)

On the other hand, pip/RubyGems will download 1 version of _Package D_ which satisfies _Package A_ and _Package C_.

![](/images/nde-mdls/pip-rubygems-dep-graph.png)

At first glance, the pip/RubyGems strategy might seem like the better approach but each has its pros and cons.

While the pip/RubyGems dependency management approach conserves space, it can lead to "dependency hell" i.e a situation where the package manager is unable to find a version of a package that satisfies all its dependents. In such a case, the developer will have to fix things manually. This may involve upgrading/downgrading one or more dependencies and/or eliminating them entirely. As you might imagine, this can be a pain. Doing the job of a package manager is not fun. And should you decide to downgrade a package, you might be opening up your app to vulnerabilities. As your app grows and you add more dependencies, you are more likely to face dependency hell.

The npm approach solves the dependency hell problem. If _Package A_ requires v2 of _Package D_ and _Package C_ requires v5 of _Package D_, npm will download both versions. This is neat, but it doesn't come without its challenges. As you are already well aware, your app bundles become very large. But there's another problem that could occur in this approach. If you have one of more packages that expose a dependency as part of their interface, you might encounter version conflicts. For instance, if you have the latest version of React as a dependency in your project and you also have a component library dependency that uses an old version of React, you'd most likely encounter compatibility issues that might not be easy to detect at first glance. With the pip/RubyGems approach, you'd catch the problem pretty much at the start while trying to install the dependencies. Fortunately though, npm has a solution for this: [peer dependencies](https://nodejs.org/es/blog/npm/peer-dependencies/).

It's worth mentioning that npm optimizes your dependency graph by employing deduplication i.e if _Package A_ and _Package C_ require v1 of _Package D_, npm will only download one copy of _Package D_. You can run `npm ls` in your project's root directory to view the "deduped" packages in your dependency graph. Check out [the deduplicated packages](https://gist.github.com/nicholaskajoh/a4b068818b965b95f6eae3aa285e4fc3) in [Knex](https://www.npmjs.com/package/knex), the SQL query builder.

Looking at these 2 dependency management strategies with the merits and demerits in mind, the npm approach seems like the better one to me, but I may be biased.

# Small packages
The Node.js community is "notorious" for building [very small packages](https://www.npmjs.com/~sindresorhus). It's also big on reusing as much code as possible. The end result is npm packages that can easily contain a dozen or more dependencies which in turn have their own dependencies. Take Knex for example. As at the time of writing this article, it has 17 direct dependencies — dev dependencies not included (`npm ls --only=prod --depth=0 | wc -l`) — and a total of 257 dependencies (`npm ls --only=prod | wc -l`). This means if you start and new Node project and run `npm install knex`, you'd have 257 dependencies on your hands right off the bat!

One could argue that this pattern of building small packages and using lots of dependencies is fueled by npm's dependency management strategy. If npm used the pip/RubyGems approach, Node.js developers would be wary of having many dependencies for fear of dependency hell. Perhaps there's just one reason for the Node.js black hole. Having explored it, it seems pretty reasonable to me!