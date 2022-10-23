+++
author = "Nicholas Kajoh"
date = 2018-11-22T07:21:00.000Z
draft = false
slug = "git-workflows"
tags = ["Git"]
title = "Two Git workflows you should know"

+++


Git is ubiquitous and pretty much standard for many Software Developers nowadays as far as Version Control Systems (VCS) are concerned. There are quite a number of ways developers work using Git. The workflows individuals/teams choose usually depend on factors like project type, project size, team size, dev tools integration etc.

In this post, we’ll be discussing two popular Git workflows you should know — _Gitflow_ and the _Forking workflow_. Let’s dig right in!

### Gitflow

![](/images/git-workflows/gitflow.png)

_Gitflow workflow. Source: nvie.com_

Developed and popularized by [Vincent Driessen](https://nvie.com/about), the Gitflow workflow is a branching model built around release management. It involves the use of two main branches (_master_ and _develop_) and three supporting branches (_feature_, _release_ and _hotfix_), with strict branch off and merge rules.

The _master_ branch is the production/stable branch while the _develop_ branch reflects the latest changes to the software for the next release. A _feature_ branch is created when a new feature is to be added.

When all the features for the next release have been merged to _develop_ and it is ready to be released, a versioned _release_ branch is created off _develop_. This branch does not take any new features — only bug fixes. When the _release_ branch is ready to be taken to production, it is merged into _master_ and tagged with the release version. It is also merged into _develop_ so that _develop_ is updated with the fixes.

If a bug is discovered in production, a _hotfix_ branch is created to fix it. This branch is merged into _master_ (and versioned), as well as into _develop_ or to _release_ (if one currently exists).

You can learn more about this workflow from Vincent himself in his article titled [A Successful Git Branching Model](https://nvie.com/posts/a-successful-git-branching-model/).

### Forking workflow

![](/images/git-workflows/forking-workflow.jpeg)

_Forking workflow_

The Forking workflow is common in open source projects where anyone can contribute. Outside collaborators are not given write access to the official repository. They must first fork the repository, create a new branch, make the changes they want, then send a Pull Request to the official repository.

A fork is a server-side clone of a repository. You can fork any public repository on [GitHub](https://github.com/) and you’ll get a copy of it on your own account. You can make any changes you want to this fork. Forks need to be regularly synchronized with the upstream (official) repository so that they can have the latest changes.

A Pull Request (PR) is a request to merge the changes from a branch in a fork to an upstream repository. A project maintainer may accept, reject or request changes to a PR before it’s merged.

You can learn more about this workflow with [this tutorial from Atlassian.com](https://www.atlassian.com/git/tutorials/comparing-workflows/forking-workflow).
