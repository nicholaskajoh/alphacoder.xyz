---
title: "What is readable code?"
date: 2022-10-27
draft: false
slug: "what-is-readable-code"
tags: ["Code Quality"]
---

> Any code that I didn’t write or wrote more than 6 months ago is unreadable! — you, probably

Everyone writes readable code, and yet everyone complains about all the unreadable code they have to deal with on a daily. Of course, readability is subjective. But when developers say a certain piece of code is unreadable, they usually mean it requires high cognitive load to comprehend. So it makes sense that your code is usually readable to you regardless of how it looks because you wrote, and thus already understand it. Fortunately, there are simple things you can do when writing code to make it more readable to others—especially that poor soul who’d have to maintain your code 2 years from now.

- **Comment:** This might seem obvious, but adding comments to your code is a very effective way to make it readable. Make sure your comment answers “why?” not “how?” Your code is the how.
In addition to code comments, it also helps to write descriptive messages when committing code to your version control system.
- **Test:** An automated test is essentially a documentation of what a developer expects from their code. It can make it easier to understand a piece of code. And unlike comments, it’s less likely for a test to go stale because it’s usually run every time a change is made and will fail if its assertions are not met.
- **Format:** Consistent formatting makes code much easier on the eyes and thus faster to understand. Whatever code style you go for (i.e the case for variable names, type of indentation etc), make sure it’s consistent across your code base. You can enforce this using a linter.
- **Decompress:** Clever one-liners are nice and all, but they are difficult to unpack mentally as well as debug (with breakpoints). Same thing with nested function invocations i.e `a(b(c(d())))`. If someone has to stare at a line of code you wrote for more than 5 seconds trying to understand what it does, you’re probably doing too much in that line.
- **Contextualize:** Your variable names should describe the data they reference and your function/method/class names should describe what they do and/or return. Also, avoid abbreviations and acronyms unless they’re well known or properly documented. It’s better to err on the side of verbosity. `batchSize` is better than `i` and `transfer_account()` is better than `tfr_acc()`.
