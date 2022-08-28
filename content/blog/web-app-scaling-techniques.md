---
title: "Web app scaling techniques"
date: 2022-08-27
draft: false
slug: "web-app-scaling-techniques"
tags: ["Scalability"]
---

Several moons ago, I wrote an article about [techniques for scaling databases](/database-scaling-techniques/). Today, we’ll be looking at the app side of things. As with databases, you want to develop your application with scalability in mind so that when the time comes to increase capacity, the process is straightforward and seamless. Having a clear pathway for building a higher capacity and robust system also helps prevent over-engineering and premature optimization, so it’s important to have the steps and process for evolving your systems to handle large workloads.

Like the database article, I’ve organized the techniques in a relatively increasing order of relevance as one’s web app load grows.

# Get a bigger server
It’s “engineer nature” to want to to engineer things, so most of us forget we could just [scale vertically](/scale-an-app-horizontally-using-a-load-balancer/) i.e provision more resources on the server we’re currently using. If you use a cloud hosting service, this is as easy as clicking a few buttons and may not involve any downtime.

Hardware has become faster and cheaper over the years and many server infrastructure providers offer beefy machines that can handle a lot of load (for example, you can rent an EC2 instance with 128 vCPUs, 4 TB of RAM, 4 TB of SSD storage and up to 25 Gbps network speed on AWS). If high availability is not a major concern for you (i.e you can tolerate some little downtime every now and then), consider all your options on the vertical side before going horizontal.

![](/images/web-app-scaling-techniques/get-thiccc-server.png)

# Split your app into functional components
You can break your app into functional components and spin up a server for each one. This will allow you increase capacity while preventing a resource-intensive component of your system from disrupting other components. Also, there are managed services for some of these components (such as AWS S3 for file storage), so you could offload some stuff to third parties and save time needed to develop and optimize them.

Some components you could break your app into include:

- User interface
- API
- Database
- Cache
- File storage
- Queue

![](/images/web-app-scaling-techniques/split-app-into-comps.png)

When splitting up your app, it’s important to consider the latency implications. Ideally, all the components should be in the same local network or region.

# Run multiple instances of your app
Eventually, a single server might not be able to handle your load requirements. More so, you might want your app to be highly available i.e if one or more servers are unhealthy or crash, your app should continue to work. In these cases, you’d want to scale horizontally i.e running your app on multiple machines and putting them behind a load balancer. A load balancer can spread the load evenly among the machines and stop routing traffic to a machine that is unhealthy.

![](/images/web-app-scaling-techniques/load-balancing.png)

You could even go a step further and make your load balancing layer highly available by running multiple load balancers and glueing them together with a software like [keepalived](https://www.keepalived.org/) which allows you automatically fail over if a server goes down.

![](/images/web-app-scaling-techniques/multiple-load-balancers.png)

As with splitting your app into functional components, you should factor in the latency implications of putting your app behind a load balancer. Of course, the load balancers and app servers should be in the same location. Also, in order to run multiple instances of your app smoothly, the app should ideally be [stateless](https://www.webopedia.com/definitions/stateless/). So consider removing sessions, in-memory caching and the like.

# Load balance using DNS
In addition to resolving domain names, a DNS can be used as a load balancer. You can create multiple A records and configure your authoritative DNS in a round robin fashion, or preferably use geolocation-based routing i.e users will be routed to the servers closest to them. On top of being able to handle more load, this setup allows you achieve global high availability (by running your app in multiple data centers across the globe), as well as enables you provide consistent and lower latencies in all the regions you operate.

![](/images/web-app-scaling-techniques/dns-load-balancing.png)

# Use anycast networking

[Anycast networking](https://www.cloudflare.com/learning/cdn/glossary/anycast-network/) lets you use the internet as your app’s load balancer by advertising a single IP from multiple locations or PoPs (Points of Presence). This means that users are routed to the servers closest to them (in terms of router hops). As with DNS load balancing, this facilitates global high availability and lower latencies but it can be [difficult and time consuming to set up](https://labs.ripe.net/author/samir_jafferali/build-your-own-anycast-network-in-nine-steps/). Also, it’s possible to [combine the two for better results](https://engineering.linkedin.com/network-performance/tcp-over-ip-anycast-pipe-dream-or-reality).

![](/images/web-app-scaling-techniques/anycast-networking.png)
