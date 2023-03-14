---
title: "How to configure wildcard subdomains"
slug: "how-to-configure-wildcard-subdomains"
date: 2019-04-02T04:08:11.467Z
draft: false
tags: ["Web Development", "Domain Name System"]
---

Some web apps, especially those for the enterprise, give every organization, team or user their own subdomain such as __team-name.awesomeapp.com__ or __org-name.beta.awesomeapp.com__. These subdomains are variable, meaning that they are not predefined and can contain any valid [domain name](https://en.wikipedia.org/wiki/Domain_name) characters.

To configure wildcard subdomains, all you need to do is add a "match all" CNAME record for your domain. The way a given subdomain is handled is totally up to your application. All web browsers and servers provide a medium for accessing a web app's url for a given request, so you can fetch the subdomain and proceed with your business logic. Often, the subdomain would be a unique id for something e.g an organization, so your can use it to get the organization's details for instance.

Here's a sample application that displays avatars from [Adorable Avatars](http://avatars.adorable.io) based on the subdomain you use.

![](/images/wcsubd/demo.gif)

Visit `some-random-name.wildcard-subdomains.alphacoder.xyz` where `some-random-name` can be anything you like and watch the avatars change!

To use wildcard subdomains, go to your domain registrar and create a "match all" CNAME record

![](/images/wcsubd/dns-conf.jpg)

If you want subdomains like `some-random-name.alphacoder.xyz`, feel free to skip the `.wildcard-subdomains` so that you have only `*` in the host field.

The web page has just a few lines of code

    <!DOCTYPE html>
    <html lang="en">
    <head>
      <title>Wildcard subdomains</title>
    </head>
    <body>

      <h1 id="subdomain"></h1>
      <img id="avatar">

      <script>
        var subdomain = window.location.hostname.split('.')[0];
        document.getElementById('subdomain').textContent = subdomain;
        var avatarSrc = 'https://api.adorable.io/avatars/285/' + subdomain + '.png';
        document.getElementById('avatar').src = avatarSrc;
      </script>
    </body>
    </html>

The most important part of the code is line 12, which gets the subdomain from the hostname (`window.location.hostname.split('.')[0]`).

In development, you can use `lvh.me` (e.g `some-random-name.lvh.me:8080`) to test your application instead of `127.0.0.1`. `some-random-name.localhost` also works on browsers I've tested.