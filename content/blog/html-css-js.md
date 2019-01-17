---
title: "HTML, CSS and Javascript as fast as possible"
slug: "html-css-js"
date: 2017-06-07T21:48:21+01:00
draft: false
tag: ["HTML", "CSS", "JavaScript"]
---

This post is a prequel to a series of posts on [building a Facebook clone with PHP from scratch](/facebook-clone-1) authored by yours truly. It's intended to give you an overview of HTML, CSS and Javascript if you have little/zero knowledge of any or all of them.

HTML, CSS and Javascript are front-end languages i.e they run on the client (your user's device/browser). HTML is a templating language. CSS helps you style HTML and Javascript is "an object-oriented computer programming language commonly used to create interactive effects within web browsers." Javascript in short, brings life to your web application.

This post is meant to brush you up on the very basics. I don't expect you to start writing HTML, CSS and Javascript code after following through with this post. My aim is to demystify these languages. When you start the Facebook clone series, I don't want you running away from code snippets written in these languages.
Also, if you're new to these languages, I expect that you push further to more detailed resources. There are a ton of free courses to help you. A Google search is a good start!
With that, let's begin...

# HTML
HTML stands for Hypertext Markup Language, but you probably already knew that. A html document is a file that contains html code. Create a file called index.html, open it in a text editor of your choice (e.g Notepad) and type the following code (don't copy paste please):

    <!DOCTYPE html>
    <html>
    <head>
        <title></title>
    </head>
    <body>
        <p>My first HTML code!</p>
    </body>
    </html>

Save the file and open it with a browser. When you do, you should see "My first HTML code!" on the page. Congrats! But before we celebrate, let's understand what's going on in the above code.

## Tags, elements
`<html></html>`, `<head></head>`, `<p></p>` and all the others enclosed in `<` and `>` or `</` are called tags or elements. Tags/elements are the building blocks of html. The tags like `<this>` are called opening tags and the ones like `</this>` are called closing tags. Not all elements have closing tags. We'll use such tags in a jiffy.
The visible part of a html document is enclosed between `<body>` and `</body>` so let's focus on that in this post. But html totally gives itself away. `<title></title>` for instance suggests that the title of something should be contained between its tags. Let's go ahead and write something between the title tags like so:

    <title>Great page!</title>

Save your index.html file again and refresh the page in your browser. Did you notice any change on the tabs bar? HTML is that simple!

## Attributes
Tags have attributes. Attributes are those properties we add to "customize" or add more functionality to elements. Each html element has a set of attributes which you can specify. In fact, you can even create your own attributes. But let's not go there just yet.

    <a href="https://www.example.com">click here</a>

Add this bit of code within the body tag. Save and refresh your browser.

The `a` tag is how you create links in html. `href` is an attribute that specifies where the link would take a user if they clicked on it. In this case, it's `www.example.com`. We'll see more attributes as we move on. Let's learn a couple more tags!

## Image tag
To add an image to a html page, we use the image tag:

    <img src="me.png">

`src` is an attribute for the img tag which specifies the location of the image to display. Place an image in the same folder as your index.html file and display it on your page using the img tag. Make sure the source (i.e src) in your tag corresponds to the image filename and extension e.g my-pic.jpg.
`img` is an example of an element that has just an opening tag and no closing tag.
We can add more attributes to better customize our image:

    <img src="me.png" width="50" height="100">

Experiment a bit with with these numbers would you!

## Form field tag
The last html element we'll look at before we wrap this up is the form field tag. It's pretty easy:

    <input type="text" name="title">

Form inputs are very handy when we want to get information from users. But we can also populate an input with data ourselves:

    <input type="text" name="title" value="HTML is good right?">

In summary, html is all about elements/tags and their attributes. Really simple stuff.
There are a ton of html tags and attributes. Now you know the basics, go learn all the other html elements. Here's a list of all html elements and their attributes.

**NB:** I recommend [VS Code](https://code.visualstudio.com/download) if you don't yet have a proper text editor/IDE. VS Code includes support for syntax highlighting and intelligent code completion which makes it easier and faster to write code.

# CSS
CSS stands for Cascading Style Sheets. You probably didn't know that (lol). It is a language that "describes the style of a HTML document". It specifies how html elements should be displayed.

## How it works
There a ton of CSS properties to style an html element/a set of html elements. To apply a given style, you type the property name and value like so:

    property-name: value;

For instance, if we want to change to color of content enclosed in some html tag, we could do something like:

    color: red;

## Styling your HTML
There are 3 major ways of adding CSS to HTML code:

1. Adding inline CSS to HTML tags
2. Embedding CSS into the HTML
3. Linking to a separate CSS file.

The easiest way to add css to html is inline through the use of the style attribute. Let's go back to our index.html file and add the style attribute to the a tag like so:

    <a style="color: red;" href="https://www.example.com">click here</a>

This is inline CSS. Save and open index.html in your browser to see the changes.

We can also embed css in html with the use of the `style` html tag:

    <style type="text/css">
    a {
        color: lightgreen;
    }
    </style>

In the above code, I enclosed the `color` property I defined in curly braces. The `a` before the first brace is called a selector. It tells the browser that this style should only affect `a` tags. Thus all `a` elements I create in index.html will be lightgreen. Add another `a` tag and see what happens.

What if we want only the click me link to be lightgreen? Well, I could add an `id` attribute to it and change the css to fit like this:

    <style type="text/css">
    #clickHereLink {
        color: lightgreen;
    }
    </style>
    <a id="clickHereLink" href="https://www.example.com">click here</a>

Notice the hash (`#`) in the code? That's how we write a selector that refers to `id` attributes in css.
The `id` attribute uniquely identifies an element. What if we wanted only a bunch of a tags to be lightgreen? Two or more elements can't have same id. What do we do? The class attribute to the rescue! Just add a class to the elements you want affected like so:

    <style type="text/css">
    .green-link {
        color: lightgreen;
    }
    </style>
    <a class="green-link" href="https://www.example.com">click here</a>
    <a class="green-link" href="https://instagram.com">I love Instagram</a>
    <a href="https://krak.lol">I love Krak.lol too!</a>

Notice the dot (`.`) before the class name green-link? That's how we write a selector that refers to a class in css.

The last major way of adding css to html is linking to a separate css file. Here we "import" css from an external file to our html file. Create a file called styles.css in the same folder as your index.html file and type the following code in it.

    body {
        font-family: Arial;
        font-size: 20px;
    }

Now, add the bit of code that follows immediately under the title element in your html code:

    <link rel="stylesheet" type="text/css" href="styles.css">

Save all and refresh. You should see some changes.

So ya, that's css in brief. There are a couple other things to learn before you can say "I know CSS". But this is a great start! Check out these links to find all css selectors and properties. Here: https://www.w3schools.com/cssref/ and here: https://www.w3schools.com/cssref/css_selectors.asp.

# JavaScript
JavaScript or js for short is a programming language that adds interactivity to your website. It's one of the most popular programming languages today and it's use goes beyond just the web. Let's learn JavaScript!

## Variables
Variables are containers to store values in. To create a variable in js, you use the var keyword:

    var myNumber = 5;

## Data types
Variables have different data types. They include:

**Number** e.g `var n = 1;`

**String** e.g `var myName = "Nicholas";`

**Boolean** e.g `var iLoveYou = true;`

**Array** e.g `var booksOfTheBible = ['John', 'Genesis', 'Daniel', 'Exodos', 'Amos'];`

**Object** e.g `var father = {name: "The Rock", age: 42, isGood: true};`

**NB:** Notice the semicolon at the end of each statement? Think of it as the full stop we have in written English.

Also, don't worry so much about these data types. I'll leave a reference at the end of this post that'll help you understand them better.

## Operators
Operators are mathematical symbols which produce results based on 2 values/variables. They include:

**add/concatenation** e.g `n + 1;`, `'Hello '+'World';`

**subtract, multiply, divide** e.g `3 - 2;`, `num1 * num2;`, `45 / n;`

**assignment** e.g `n = 7;`, `name = "Nick";`

**identity (boolean)** e.g `4 === 3;` (is 4 equal to 3?)

**negation (boolean)** e.g `4 !== 3;` or `!(4 === 3);` (is 4 not equal to 3?)

Here are a couple more operators to explore: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators.

## Conditionals
Conditionals are control structures that allow you test if an expression is true or not.

    if(5 === 1) {
      console.log("No");
    } else {
      console.log("Yey");
    }

## Functions
Functions allow us group bits of code into reusable components. Here's how to write one:

    function doSomethingDifficult(){
      return "I have done the impossible!";
    }

We can call the function like so:

    var difficultStuff = doSomethingDifficult();

## Events
Events listen for when things happen in your web application e.g a button click or a scroll. Say we want to do something when any part of our web page is clicked, we can write the following code:

    document.querySelector('body').onClick = function() {
      // do something e.g alert
      alert("I just did something!");
    };

The JavaScript part of this post is very very brief and scratches just the surface. However, it exposes some of the functionality JavaScript provides. Hopefully, you have a rough sketch of what JavaScript is like. It's not "that hard" and you can learn it. Here's a great reference for JavaScript that teaches the basics: https://developer.mozilla.org/en-US/docs/Learn/Getting_started_with_the_web/JavaScript_basics.
If you came from my [Facebook clone series](/tag/facebook-clone-series), now is the time to [jump back](/facebook-clone-1) and build something!