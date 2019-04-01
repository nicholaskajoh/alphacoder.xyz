---
title: "Interservice communication with gRPC using Node.js"
date: 2019-01-12T22:32:42+01:00
draft: true
---

Interservice communication is a very important aspect of the microservices architecture. While most functionality in a monolith is a function call away, a lot of actions and data need to be performed and fetched over a network in microservices. This is one of the drawbacks of the architecture as a myriad of bad things could happen when two services need to talk to each other.

One common challenge in microservice communication is network failure. [Whatever can go wrong would go wrong](https://en.wikiquote.org/wiki/Murphy%27s_law). There are a number of strategies for reducing failure rates including adding redundancy to an app's infrastructure by running multiple instances of services on/in different machines/locations, and caching data to use as a fallback. For things that don't necessarily have to happen immediately (asynchronous processes), [messaging](https://whatis.techtarget.com/definition/messaging-server) is also a good strategy. Suffice it to say that when things do go wrong, a microservices app should fail gracefully. Depending on the point of failure this can be quite easy or very hard to achieve. Sigh!

Another challenge, the one we'll be exploring in this article, is communication contracts. Is service A expecting what service B is sending? And will service A return what service B expects? Any misconception between two services trying to communicate can lead to hard to debug errors of which I'm all too familiar with, sadly.

A common technique for data exchange is sending JSON payloads over HTTP. That is, [REST](https://en.wikipedia.org/wiki/Representational_state_transfer). You're probably conversant with REST. It's a great medium if "strict" contracts are established. The problem with REST as a strategy for interservice communication, in my opinion, is that contracts can't be enforced at program level. In other words, there's no collective agreement of what must be sent and/or received between two applications.

This is where RPC comes in. RPC stands for __Remote Procedure Call__. It is a protocol programs use to make function calls to other programs running on other machines over a network. Aside enforcing data exchange "contracts" between programs (or services), a benefit of RPC over REST is that [it provides the opportunity for making interservice communication faster](https://stackoverflow.com/a/44937371/6293466) through features such as message compression and first-class load balancing.

In this tutorial, we'll be using gRPC for interservice communication. gRPC is an open source RPC framework initially developed by Google, built on top of [HTTP/2](https://en.wikipedia.org/wiki/HTTP/2) and Protocol Buffers for low latency and highly scalable distributed systems. We'll build our gRPC server and client with Node.js, but gRPC supports several other languages. Plus, you can use two (or more) different languages if you want or need to.

# Example project
We'll be writing two Node.js microservices that communicate with each other:

# Project setup


# Protocol buffers
Protocol Buffers or protobufs (for short) are a method of serializing structured data used to build programs that communicate over a network.

# Server

# Client

# gRPC + REST

# Secure gRPC