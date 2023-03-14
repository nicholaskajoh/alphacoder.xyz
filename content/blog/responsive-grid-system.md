+++
author = "Nicholas Kajoh"
date = 2017-11-19T20:07:00.000Z
draft = false
slug = "responsive-grid-system"
tags = ["Web Development"]
title = "A responsive grid system with few lines of CSS"

+++


How many times have you added Bootstrap to your project just for its grid system? Probably not enough times to think about learning how to create your own grid system. However, there are times when you need _something light_!

Say you’re learning a new framework or testing out some code and you want to throw in some grid love so that things look a little organized on the page. Would you rather include the heavyweight champ that is Bootstrap, or scribble a few lines of grid code?

While adding Bootstrap may sound easier, you might be faced with the nightmare that is overriding classes. Nobody loves overriding the classes they don’t want/need, plus you’re now distracted from what you really want to accomplish. Besides, you don’t lose anything by learning how to write a grid system. In fact, it makes you understand and appreciate CSS libraries and better.

There was this school project I had to work on. It was pretty basic, but I needed a grid system. I had already decided to build it from the ground up with only vanilla, so Bootstrap or Materialize was not an option. I had to learn how to write my own grid system. It turns out that it’s not difficult at all. In fact, I wrote a grid system with a few lines of CSS code.

It’s important to note that there are several ways of building a grid system; each with its own quirks. It’s easy to forget that CSS 1.0 wasn’t made with grid in mind as the webosphere is now littered with millions of sites using layouts of all shapes and sizes.

Devs cooked up various workarounds and hacks. They used __tables__ to create grids back in the day. More recently, they used __floats__. Float grids sufficed until they didn’t. They are still in use today. However, __flexbox__ has replaced float grid systems on many sites online. Flexbox was made to solve the grid problem. Nevertheless, flexbox has it’s own limitations. The new kid on the block, __grid layout__, was created to handle more complex systems that web apps of today demand.

I used flexbox to create a simple grid system. Flexbox is great! It's supported in major browsers and is easy to implement.

<script src="https://gist.github.com/nicholaskajoh/35702b2e0791c4329e80cde9d0d3e9ba.js"></script>

I don’t want get into the intricacies of flexbox. I’ll be reinventing the wheel by doing that. Instead I’ll point you to a resource that helped me wrap my head around it. Nonetheless, from the code, it’s relatively easy to figure out how everything kinda works. It’s basically some flexbox code and media queries for 3 view ports — mobile, tablet and desktop.

Just add the following simple markup and you’re good to go.

```html
<section>
    <article>Content</article>
    <aside>Sidebar</aside>
</section>
```

You can always add a few more lines for other neat functionalities. If you feel you’re doing too much, it may be time to throw in a library or something. If you feel Bootstrap or any other UI library is overkill, there are a ton of CSS grid libraries. I don’t want to name names, but Google is your friend. A search would yield a ton of interesting results.

Check out the repo for this tutorial: [https://github.com/nicholaskajoh/Simple-CSS-Grid](https://github.com/nicholaskajoh/Simple-CSS-Grid).

Also, you should totally read [Chris Coyier’s complete guide to flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/). If you have the time, go through [Chris House’ complete guide to grid](https://css-tricks.com/snippets/css/complete-guide-grid/) as well.