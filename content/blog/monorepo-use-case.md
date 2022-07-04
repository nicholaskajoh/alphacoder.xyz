---
title: "The case for monorepos"
date: 2022-07-04T19:48:14+02:00
draft: false
slug: "monorepo-use-case"
---

At a previous company, I worked as a Platform Engineer for the Packages team. A brand new team, our job was to abstract the building blocks of our systems into reusable components, and to create a pipeline for developing and releasing these components as packages for use by product engineers. There was a lot of duplication in our codebases and we were also slowly moving towards a microservices architecture, so our work was crucial in helping the engineering organization improve code quality and developer productivity.

I think we did a great job with what we built given the size of the team, the amount of time we had and how much freedom we had to modify/change existing systems and processes, but it wasn’t without issues. Weeks and months after leaving the team, I kept thinking about the initial design and how it could be improved. I think I’ve arrived at something better. Of course, it’s nothing new and some may find the trade-offs costlier than the benefits, but it’s quite fascinating to me because I was bewildered by and opposed to the idea when I first learned about it. I’m talking about monorepos.

# What we built

Our stack was mainly JavaScript-based tech (TypeScript, Node.js and friends), so we were developing and releasing NPM packages. We used [Semantic Release](https://github.com/semantic-release/semantic-release) to automate the releases (versioning, release notes generation and publishing). We built a self-serve system to enable developers create new packages and update existing ones on their own. Creating a package involved setting up a GitHub repository with certain configs which connected it to the release pipeline. For existing packages, all a developer had to do was open a PR. Once merged, the changes would be cut into a new release and available in our private registry for installation/use.

```bash
# First time, add private registry to the package manager.
npm login --scope=@test-company --registry=https://registry.testcompany.com

# Then install internal package(s).
npm install @test-company/very-useful-package
```

# The challenges

The challenges we faced were a result of the mismatch of the solution we implemented and our customers’ (i.e product developers’) needs. Our solution is a better fit for open source development where clear project scope and stability is king, as opposed to a fast-paced agile environment which prioritizes velocity and adaptability. Some of the issues we were confronted with are:

## More complex dev environment

Development is complex enough when you have to setup multiple repos and spin up multiple apps. Adding packages to the mix complicates things even more. Now you have to setup even more repos, work across multiple codebases, and update dependencies to deliver a single feature or fix a single bug. I did not realize how bad it was until I considered duplicating code from a package just to avoid having to update it and doing the whole release process dance.

## Long review cycles

Multiple repos means multiple PRs for a single task. Multiple PRs means longer review cycles. We found, unsurprisingly, that developers who like to move fast don’t appreciate this very much.

## Versioning hell

The worst of the challenges was dealing with versioning. If you wanted to introduce a breaking change, you had 3 options:

- Don’t introduce a breaking change. Make your change backwards compatible by exposing some specialized function for your use case. This of course will increase complexity and ultimately defeat the goal of having clean abstractions that can be reused.
- Release a new version and update all the dependent apps. This can be a lot of work and may be risky.
- Release a new version just for your changes. Now you have to maintain multiple versions of a single package which is a pain.

# Building something better

The solution to these problems is a monorepo. How? Well, with all the code in one place, you don’t have to clone a new repo, or open multiple PRs, or deal with versioning (you’re always using the latest version). Large refactors to create better abstractions are also more tenable.

Of course, even if I recognized this at the time, there’s no way I could have convinced the engineering org or even my team to squash dozens of repos into one. The benefits of doing so just don’t justify the work involved—and the risks. Maybe at some point in the future it will and a monorepo would make sense.

The thing I’ve learned in thinking through these challenges is that context is key. It’s important to suss out the motivations for using a given system or tool before criticizing or adopting it. Often, until you’re in the problem space yourself, you never recognize or appreciate the reasons for going with certain approaches.
