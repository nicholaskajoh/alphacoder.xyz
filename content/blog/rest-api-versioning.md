---
title: "How to version REST APIs"
date: 2022-08-28
draft: false
slug: "rest-api-versioning"
---

Having worked at companies that sell API products in the last couple years, I’ve found myself contemplating—for hours on end in the shower—what the best way to version REST APIs is. You want simplicity and stability so that your API is easy for developers to integrate. But you also want to iterate on your product and add new features to improve your offering. Eventually, you’ll need to introduce breaking changes. Maybe you’re expanding the scope of an endpoint so you want to reorganize the parameters in the request payload, or a field in the response body needs to be removed for security or compliance reasons. To deal with these, you’ll need to introduce versioning in some form.

There are several ways to do API versioning. If you’ve integrated any 3rd-party APIs, you’re probably familiar with a few of them. You could put the version number in:

- the URL i.e `https://api.alphacoder.xyz/v1/posts`
- the accept header i.e `Accept: application/vnd.alphacoder.blog-v1+json`
- a custom header i.e `Accept-Version: 1`

Rather than focusing on where to accept version numbers or what format they should be in (whatever you go with is fine as long as it’s consistent), your priority should be building a comprehensive versioning system around your API—or at least planning for one.

Your versioning system should:

- **Abstract versioning for new users:** By default, new users of your API should be on the latest version so there’s no need to bore them with versioning initially. A good way to do this is to peg them to the latest version when they sign up to use your API. They won’t have to worry about versions until that version gets deprecated/sun-set or they want a feature that is not available in the version they’re using.
- **Use resource-level versioning:** That is, each resource should have it’s own version as opposed to using one version number for your entire API. With the right tooling e.g compatibility matrices, this should not be much of a problem. And for users consuming resources that seldom change, they won’t have to do anything in a long while.
- **Span all user contact surfaces:** So not just your API where a user can specify what version they want to use. On the user dashboards, they should be able to see a log of what resource versions they’re consuming and perhaps a nice graph of the data as well. They should also be able to see and change their default versions. On the documentation, they should be shown content specific to their default versions if applicable.
- **Have a deprecation and sun-setting policy:** When you have a well-documented deprecation and sun-setting policy and you communicate it to your users in advance, it makes upgrades less of a hassle and keeps everyone mostly happy. It could be time-based e.g versions are supported for 2 years after release, deprecated in their 3rd year and then sun-set afterwards. If you don’t release a lot of new versions, you could instead support the last 3-5 versions versions.
- **Track API version usage:** This will give you a good view of how your system is used so that you can make certain decisions such as extending the lifespan of a version or reaching out to specific users to encourage them to upgrade.
