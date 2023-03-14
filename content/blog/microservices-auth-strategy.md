---
title: "Authentication strategies in microservices architecture"
slug: "microservices-architecture-authentication"
date: 2019-09-29T17:37:55.581Z
draft: false
tags: ["System Design"]
---

When moving from monolith to microservices or considering microservices for a greenfield project, it's important to evaluate the authentication strategies available to you to find the one most suitable for your system, as authentication is an integral part of how most applications are interacted with.

In this article, I outline the most common auth strategies I've come across working with microservices, describing how they work and identifying their pros and cons.

# Auth service
In this strategy, a microservice is created for the purpose of authentication. This service is contacted by downstream services required to authenticate client requests before processing them.

![](/images/msvc-auth/auth-svc.png)

Pros:

- It's easy to implement and reason about, especially when transitioning from a monolith. The auth service is essentially a utility other services reach out to for their authentication needs.

Cons:

- It introduces a single point of failure. If the auth service is down, the whole application (or most of it) is down.

- Increased latency. The time taken to make a request to and get a response from the auth service can hurt the average response time of a microservices application negatively.

# JWT verification per service
This approach is an extension of the previous strategy and is intended to reduce dependence on the auth service. Authentication primarily involves issuing and verifying tokens. JWT ([JSON Web Tokens](https://jwt.io)) can be used to verify tokens without having to hit a database or other persistent storage. This means each service can verify requests on their own. Token issuing is done in the auth service, while verification is handled in every service where it's required. A client library is usually used to share this verification functionality with all the services that need to perform authentication.

![](/images/msvc-auth/jwt-verifier.png)

Pros:

- There's no single point of failure, auth-wise. The authentication service is only used for issuing tokens. All other services can handle token verification on their own.

- It's easy to create a client library for token verification which can be shared by all the services that require auth (assuming a single tech stack is used across board).

Cons:

- JWT can't be invalidated on-demand. While this is not a problem for some types of applications, it's a deal breaker for others e.g an enterprise app where an admin might want to disable or delete a user or a finance app where a user might want to sign out from one or more devices remotely.

- Making a change to the verification logic (e.g adding a new permission) requires updating all dependent services. This might be a Herculean task if a large number of services are involved.

# Token blacklist cache
To compensate for the shortcomings of JWT, a cache can be used to store tokens that need to be invalidated. This means that every service must contact a shared cache to check if a token has been blacklisted after successfully verifying it, before proceeding to execute any auth-protected code.

![](/images/msvc-auth/token-blacklist-cache.png)

Pros:

- JWTs can be invalidated on-demand through blacklisting.

Cons:

- This strategy is not feasible in a system where each service has its own datastore.

- If multiple services are allowed to write to the cache, they might erroneously modify token blacklist data, causing problems that might be difficult to detect and fix.

- The shared cache introduces a single point of failure to the system.

# API gateway auth
Most, if not all, microservices applications use an API gateway. An API gateway is the entry point where client requests go to before being sent to the appropriate API/edge services. The main function of a gateway is routing requests but they can be used for other purposes such as analytics, rate-limiting, data transformation, logging, health monitoring, caching and as you might have already guessed, authentication.

![](/images/msvc-auth/api-gateway-auth.png)

Pros:

- Separation of concerns. Services can communicate freely with each other and do what they need to do as authentication has already been handled downstream by the gateway.

Cons:

- Switching to an API gateway's auth system from an existing application's auth implementation can be difficult and time-consuming.
