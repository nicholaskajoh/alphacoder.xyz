---
title: "What level of abstraction should I play on?"
slug: "levels-of-abstraction"
date: 2020-04-12T18:17:48.796Z
draft: false
---

"I built it from scratch!"

A major sentiment among some of the developer circles I interacted with and was part of in my earlier days of coding was that you were a ~~better~~ "real" developer if you could build stuff "from scratch". You'd often hear people scoff at building websites with WordPress, for example. "I built this site from scratch with raw HTML, CSS and JavaScript. No framework or CMS!" It was a thing of pride. It meant you really knew your stuff.

I was a WordPress guy at the time so this didn't really sit well with me. Was I a fake developer for using WordPress? And what does building from scratch even mean? Not using frameworks, boilerplates or CMSes? Writing assembly or machine code? Crafting electric circuits?

I'm spending quite some time these days tinkering with hardware and learning the more low level computer stuff. I'm particularly interested in [Ben Eater's work](https://eater.net). A couple weeks ago, I was watching one of his YouTube videos titled ["Hello, world from scratch on a 6502 — Part 1"](https://www.youtube.com/watch?v=LnzuMJLZRdU). I found the top comment interesting.

![](/images/abstrn/yt-comment.png)

While it's very funny (for me at least), I'm pointing it out because it's underlay by two ideas relevant to this article.

1. Technically speaking, you can't build anything from scratch. You have to start from somewhere and then create abstractions to offset complexity as it increases.
2. There are many many levels of abstraction that make it possible for us to interact with computers the way we do. Much more than we might realize.

As a developer with a never-ending thirst for knowledge, I've always asked myself, "what level of abstraction should I play on?" There are just so many abstraction layers that it is not practical to work across all these levels. Moreso, abstractions are primarily intended to remove the need for interacting with other abstractions.

After years of experimentation in different levels of abstraction to figure out where to play on, I came up with two criteria for determining the best abstractions for me to use and how to decide whether to move up or down the stack.

# Does it offer the most business value?
Much as I'd love to build my next website in assembly or better still, by stitching a bunch of transistors together, I've yet to because for me, there's very little business value in doing so. While important, these abstractions offer little or no benefit to someone like me who needs to move and iterate quickly in order to achieve their goals. Whereas, abstractions like web frameworks, CMSes and website builders might be of great benefit.

I was big on WordPress in my freelancing days not because I particularly enjoyed wading through dozens of themes to find something satisfactory or hacking plugins to suit my needs. It was because it provided a lot of value to me and my clients — low setup and maintenance costs, out-of-box content management, ample technical support and so on. I've been using a website builder to develop a couple sites lately. It's been a huge time saver! And given that my time is becoming more expensive by the day, it's a really nice value-add.

As a rule of thumb, I go for the highest possible level of abstraction that can get me the functionality I need. This might mean using a fully-managed SaaS product rather than building and maintaining a service in-house, or using tooling and technologies that prioritize velocity in order to ship features and fix bugs faster.

# Is the abstraction starting to leak?
[The law of leaky abstractions](https://www.joelonsoftware.com/2002/11/11/the-law-of-leaky-abstractions/) states "All non-trivial abstractions, to some degree, are leaky." While the first criteria encourages opting for a high level of abstraction which makes it easier and faster to achieve an objective, this one advocates moving one or more levels lower when abstractions begin to leak.

If you find yourself writing a lot of CSS to override other CSS, perhaps it is time to drop Bootstrap and build your own UI component library, or pick another library with less abstraction. If you're spending a lot of time hacking a framework because its APIs can no longer give you the functionality you need, you should probably start migrating away from it and building your own abstractions using language-native APIs.

An exemplification of the basic philosophy is this: _I don't have to worry about the intricacies of paradigm X in language Y because there's this nifty little library that exposes a streamlined API for achieving what I want. When my needs grow beyond what the library offers, I'll begin to dig into the weeds of the paradigm. Right now, I'm more focused on delivering value with what I'm building than trying to understand every detail of some component I need to consume. When the abstraction begins to leak, I'll cross that river._