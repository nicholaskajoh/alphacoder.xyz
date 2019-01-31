---
title: "Hello Hugo!"
slug: "hello-hugo"
date: 2019-01-31T09:30:21+01:00
draft: false
---

If you haven't yet noticed, Alpha Coder is wearing a new look! In December of 2018, I wrote about my migration [from a Medium.com publication to a self-hosted Ghost installation on Vultr](/from-medium-to-ghost). Shortly after, I decided to ditch [Ghost](http://ghost.org) (a Node.js CMS) for [Hugo](http://gohugo.io) (a static site generator built with Go). I also changed the blog's design in the process. In this post, I'll share my experience using Ghost and explain why I moved again.

Ghost is a great CMS. It's simple, it's clean and a joy to use. The story editor is very similar to Medium's so I immediately felt at home using it. There were however a few concerns I had about using Ghost.

- __Theme customization and update:__ I needed a quick way to make changes to my blog's theme and a way to update it periodically without clearing out all my customizations. I couldn't find a simple and convenient way to do so. I thought about creating a fork of the theme which I can customize, then setting up a Git hook on my blog's server to push changes, but I never got to do it. I manually edited the theme's files on the server with nano as a temporary fix for quick customizations which is less than ideal.

- __Backup:__ I wanted automatic backups for my posts. I couldn't find a clean way to do periodic backups automatically. Ghost's data export doesn't include images, so if I wanted to backup all my data, I'd have had to manage images separately. The ideal solution for me would be a backup system that saves a copy of my data and images on Dropbox or Google Drive every 2 weeks. I couldn't find a ready-made solution for that.

- __Offline writing and editing:__ Inspiration to write can come at any time whether you're connected to the internet or not. I wanted to be able to write and edit my posts offline. This is not possible on Ghost as far as I know, except you maintain an offline copy of your posts which has its issues.

- __Cost:__ While the cost of self-hosting my Ghost blog was affordable, I figured I'd need to pay more once I started getting more traffic. But beyond that, I don't see any reason to pay for something when you can get an alternative for free. Except of course the alternative is not as good.

Hugo ticks all these boxes and more for me. My current theme is a Git submodule in the blog's repository so it's really easy to customize and update. Git is my backup system. My posts are versioned automatically and backed up on GitHub. I write and edit posts from the comfort of VS Code, my text editor of choice. And with just a single command, I can publish my blog to GitHub pages which is totally free and scales well.

The [new theme on the blog](https://themes.gohugo.io/simple-hugo-theme/) is inspired by http://bettermotherfuckingwebsite.com. I wanted something clean, accessible and performant — something that doesn't get in the way of readers. I also wanted something I could build upon should I need to, instead of fight in order to customize.

I mentioned in the article on my Medium-to-Ghost migration that most of my traffic was coming from Google search and so I felt confident leaving Medium. I didn't consider the SEO implications of jumping from one domain to another. It really hit hard! More so, during the migration, Medium suspended my account for linking from my posts there to the new blog. I did that because I couldn't do 301 redirects. Apparently it's against the law. I'm however hopeful that the blog will pick up soon.

The blog's source is available on GitHub: https://github.com/nicholaskajoh/alphacoder.xyz.

Okay. That's it for now. Hopefully I don't jump ship again.
