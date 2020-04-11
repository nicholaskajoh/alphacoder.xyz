---
title: "Server-side form validation from A to Z with Sails.js"
slug: "sailsjs-form-validation"
date: 2017-05-26T23:06:50+01:00
draft: false
---

__NB: This tutorial is meant for version 0.12 of Sails.js. Version 1 introduced many breaking changes, including a rewrite of the error handling mechanism, so the code in this tutorial will not work with it.__

__TL;DR:__ https://github.com/nicholaskajoh/sails-form-validation.

Data validation is a very essential part of any API/web app. Client-side validation is meant to guide a user "in real-time" as they try to feed your backend with much needed data, but that's not enough. HTML, CSS and Javascript validation can be messed with. You need to validate on your server too.

I couldn't find a tutorial that deals in full with the whole process of form validation in Sails.js so I decided to write one. Mind you, I'm open to contributions on how best to do it so if you know something, post a comment.

# Model
Validation in Sails happens at model level. The attributes in a model contain rules that define what data should be stored in the database table/collection it represents. Say we have a model Product, we could write validation rules like so:

```js
/* my-sails-app/api/models/Product.js */
module.exports = {
    tableName: 'products',
    attributes: {
        // primitive
        ref: {
            type: 'string',
            unique: true,
        },
        name: {
            type: 'string',
            required: true,
        },
        price:{
            type: 'float',
            required: true,
        },
        label: {
            type: 'string',
            in: ["black", "yellow"],
        }
        // associations
        ...
    },
};
```

We can easily identify the rules from the above code sample. The constraints used include `type`, `unique`, `in` and `required`. For the full list of validation rules, head over to [the Sails docs](https://0.12.sailsjs.com/documentation/concepts/models-and-orm/validations).

# Validation Messages
When users submit invalid data, we need to provide them useful error messages so they can make the necessary corrections. We can define custom error messages for the validation rules we set for a given attribute. Sails doesn't support custom error messages out of the box but there's a nifty little library for that. It's called [sails-hook-validation](https://github.com/lykmapipo/sails-hook-validation) and can be installed in your app by running `npm install sails-hook-validation --save`.

With this, we can define fine error messages instead of the very generic error messages Sails provides. It's annoyingly easy to add validation messages:

```js
/* my-sails-app/api/models/Product.js */
module.exports = {
    tableName: 'products',
    attributes: {
        ...
    },
    validationMessages: {
        name: {
            required: "Who adds a product without a name? SMH.",
        },
        price: {
            required: "Seriously? Wanna donate this product or what?",
        },
        label: {
            in: "Only black and yellow labels are allowed bro!",
        }
    },
}
```

# Controller
Let's create a controller that serves as well as processes our form. Here's a snippet:

```js
/* my-sails-app/api/controllers/ProductController.js */
shortid = require('shortid');

module.exports = {
    async show(req, res) {
        try {
            const product = await Product.findOne({ ref: req.param('ref') });
            if (!product) return res.notFound();
            return res.view('product', { product });
        } catch(err) {
            console.log(err);
        }
    },
    async add(req, res) {
        const data = {
            errors: {},
            old: {},
        };
        if (req.method === 'POST') {
            try {
                const product = await Product.create({
                    ref: shortid.generate(),
                    name: req.body.name,
                    price: parseFloat(req.body.price),
                    label: req.body.label,
                });
                return res.redirect(`product/${product.ref}`);
            } catch(err) {
                if(err.invalidAttributes) {
                    data.errors = err.Errors;
                    data.old = req.body;
                }
            }
        }

        return res.view('add-product-form', data);
    },
};
```

The `ProductController` is where most of the good stuff happens. Let's break things down piece by piece to get a grasp of what's going on. But before we do that, consider how our routes file may look:

```js
/* my-sails-app/config/routes.js */
module.exports.routes = {
    'GET /product/:ref': 'ProductController.show',
    '/products/add': 'ProductController.add',
};
```

You could also use the [Sails Blueprints thingy](http://sailsjs.com/documentation/concepts/blueprints). Not a fan of it though.

Now back to the controller. There are 2 functions in `ProductController`. The first `show()` displays a product given its reference `ref`. If the reference is not found, a 404 page is returned.

The second method `add()` does 2 things. If it receives a GET request, it returns a form users can add products with. If it receives a POST request (i.e the form is being submitted), it attempts to create a new product and redirect to the product's page. If this fails (meaning there's a validation error), the form is returned with validation errors (`data.errors`) and the data previously submitted (`data.old`). We populate the form with `data.old` so that users don't have to retype everything if they submit an invalid form.

# View
Now to our form view. Here you go:

```html
<!-- my-sails-app/views/add-product-form.ejs -->
<form method="post" action="">
    <!-- name -->
    <div class="form-group">
        <% if(errors.name) { %>
            <div class="alert alert-danger">
            <% errors.name.forEach(err => { %>
                <p><%= err.message %></p>
            <% }); %>
            </div>
        <% } %>

        <label>Name</label>
        <input class="form-control" type="text" name="name" value="<% if(old.name) { %><%= old.name %><% } %>">
    </div>
    <!-- ./name -->

    ...
</form>
```

The form view just shows the name input. You can apply this bit to all the other inputs. The most important part to us is the error message part. If there are any errors for the name input, we loop through and display them.

**Demo project: https://github.com/nicholaskajoh/sails-form-validation.**