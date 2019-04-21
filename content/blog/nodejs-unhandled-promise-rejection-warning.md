---
title: "Fixing UnhandledPromiseRejectionWarning in Node.js"
slug: "nodejs-unhandled-promise-rejection-warning"
date: 2019-03-04T13:54:48+01:00
draft: false
tags: ["Node.js", "JavaScript"]
---

JavaScript exhibits asynchronous behaviour for operations that are not completed immediately e.g a HTTP request or timer. These operations accept callbacks —  functions which are executed when an operation has been completed.

    setTimeout(function() { console.log('Slow and steady wins the race.'); }, 5000);
    console.log('The last shall be the first!');

![](/images/prm-rjctn/async-js.gif)

If you've written JavaScript for a while, you're probably familiar with [callback hell](http://callbackhell.com/). Callbacks can easily make code unreadable and difficult to reason about. Thankfully, we have Promises!

Promise objects represent the eventual completion or failure of an async operation. We can wrap a function that accepts a callback in a Promise and use the fulfillment handler `.then()` to retrieve returned data and/or continue performing other operations.

    const slowAndSteady = new Promise(function(resolve, reject) {
        setTimeout(function() {
            console.log('Slow and steady wins the race.');
            resolve();
        }, 5000);
    });
    slowAndSteady
        .then(function() {
            console.log('The last shall be the first!');
        });

![](/images/prm-rjctn/promise-js.gif)

Better still we can now use Async/Await (ECMAScript 2017/ES8) —  synctactic sugar for Promises —  to make our JavaScript simpler and easier to read.

    const slowAndSteady = new Promise(function(resolve, reject) {
        setTimeout(function() {
            console.log('Slow and steady wins the race.');
            resolve();
        }, 5000);
    });

    (async function() {
        await slowAndSteady;
        console.log('The last shall be the first!');
    })();

![](/images/prm-rjctn/await-js.gif)

There's a little problem though. It's very easy to forget to handle Promise rejections, and this can lead to hard-to-debug issues. If we fail to handle a Promise rejection, we're shown the `UnhandledPromiseRejectionWarning` by Node.js.

    const slowAndSteady = new Promise(function(resolve, reject) {
        reject();
    });

    (async function() {
        await slowAndSteady;
    })();

![](/images/prm-rjctn/promise-rejection.gif)

We also get the warning if an error (e.g validation error) is thrown inside the Promise.

    const slowAndSteady = new Promise(function(resolve, reject) {
        throw new Error('Summ just happen right now :(');
    });

    (async function() {
        await slowAndSteady;
    })();

![](/images/prm-rjctn/throw-rejection.gif)

If you didn't already notice from the warning, __"Unhandled promise rejections are deprecated. In the future, promise rejections that are not handled will terminate the Node.js process with a non-zero exit code"__. This means not handling Promises properly can crash your app!

You can handle Promise rejections by using the failure handler `.catch()` or a try/catch block.

    const slowAndSteady = new Promise(function(resolve, reject) {
        reject();
    });
    slowAndSteady
        .then(function() {
            console.log('The last shall be the first!');
        })
        .catch(function(err) {
            console.log('error: ', err);
        });

![](/images/prm-rjctn/dot-catch.gif)

    const slowAndSteady = new Promise(function(resolve, reject) {
        throw new Error('Summ just happen right now :(');
    });

    (async function() {
        try {
            await slowAndSteady;
        } catch(err) {
            console.log(err);
        }
    })();

![](/images/prm-rjctn/try-catch.gif)

It's not that simple though. Things become more interesting when you have a chain of Promises.

    const promise1 = new Promise(function(resolve, reject) {
        throw new Error('Promise 1 has tanked.');
    });

    const promise2 = new Promise(function(resolve, reject) {
        promise1.then();
    });

    (async function() {
        try {
            await promise2;
        } catch(err) {
            console.log(err);
        }
    })();

![](/images/prm-rjctn/double-promise.gif)

We still get the warning even though `promise2` is wrapped in a try/catch. Wrapping a whole function with try/catch won't cover all Promises!

It's obvious that proper exception handling is needed in `promise2`.

    const promise1 = new Promise(function(resolve, reject) {
        throw new Error('Promise 1 has tanked.');
    });

    const promise2 = new Promise(function(resolve, reject) {
        promise1.then().catch(function() { reject(); });
    });

    (async function() {
        try {
            await promise2;
        } catch(err) {
            console.log(err);
        }
    })();

But you might not be able to anticipate where exception/error handling may be needed especially when working with third party libraries. You can use the following code to catch all unhandled Promise rejections.

    process.on('unhandledRejection', function(err) {
        console.log(err);
    });


If you use error tracking software, this is a good place to notify your team about the error so that it can be fixed ASAP!

    process.on('unhandledRejection', function(err) {
        console.log(err);
        // sendInTheCalvary(err);
    });

    const promise1 = new Promise(function(resolve, reject) {
        throw new Error('Promise 1 has tanked.');
    });

    const promise2 = new Promise(function(resolve, reject) {
        promise1.then();
    });

    (async function() {
        try {
            await promise2;
        } catch(err) {
            console.log(err);
        }
    })();

![](/images/prm-rjctn/handle-all-rejections.gif)