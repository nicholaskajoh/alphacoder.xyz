---
title: "The case for microservices architecture"
slug: "microservices-use-case"
date: 2023-03-24
draft: false
tags: ["System Design"]
---

The buzz seems to have died down now, but a few years ago, microservices architecture seemed to be all the rage. Everyone and their mom seemed to be transitioning from monolith to microservices or building their software from the get go using this architecture. At some point, it appeared to be a contest on the number of microservices you were running in production, judging by the blog posts and conference talks at least.

Like the hangover after a crazy night out, we seem to have realized [it's not all fun and games](https://www.youtube.com/watch?v=kb-m2fasdDY). As with most software engineering solutions, there are tradeoffs. And knowing those tradeoffs puts you in a better position to choose the right tool for the job—rather than using something because some big/successful company is using it or because it's "cool".

# Why microservices?

It bothered me a little bit that I didn.t really get the use case for microservices. Why would someone complicate their system by making it distributed? What do you get in return for this complexity? Scalability? Higher availability? But you can already achieve these with a monolith, no? It didn't make much sense to me.

It would take several years to get it. The revelation that made it all make sense was finding out that microservices architecture is not a technology solution. It's a people one!

This might seem very obvious, but software is built by people. To be able to build software (especially a large and complicated one) quickly and efficiently, you need to organize people in a way that makes communication fast (or unnecessary), and empower them to own the piece of the software pie they are responsible for and its lifecycle. This is why we have team topologies built around self-organization and cross-functionality.

Microservices architecture exist so that teams can fully own the products and features they're responsible for. This means being able to change and release code whenever they want. The idea is that decentralized decision-making is the better way to organize a large group of people towards achieving a common goal.

This might sound counter-intuitive, but when you think about it, it makes a lot of sense. Communication becomes a bottleneck the larger an organization grows. So if you centralize decision-making, your speed of execution would be as fast (or rather, as slow) as it takes information to permeate the organization, not to talk of the various ways things can be misunderstood and misinterpreted.

Beyond that, local decision-making is usually better because executors are typically subject-matter experts. A chef should be the one deciding what ingredients to buy and when to buy them, not a restaurant CEO or manager. He probably knows more about foodstuff than they do. In the same vein, you should be able to decide how to change your code, and when/how often to deploy it, not the head of engineering or operations team. You know more about the code than they do, because you probably wrote it and/or work on it everyday.

# The faux benefits

When people justify their use of microservices, they tend to mention its supposed pros. It turns out that most of them are faux benefits. Yes, you get these benefits by using microservices, but they are not worth the complexity you get in return in my opinion. More importantly, they can be achieved without the use of this architecture.

- **Scalability:** Microservices architecture can make your system scalable (a result of distributing load across multiple services), but [there are easier ways to achieve scalability](/web-app-scaling-techniques/), such as load balancing.

- **Encapsulation:** Each microservice is a container exposing an interface (such as a REST API) through which it may be consumed. This hides its implementation details, making it easier to understand, reuse and modify. The microservice "container" also lends itself well to network-level isolation e.g external vs internal services, which improves security. But like with scalability, there are several other cheaper ways to encapsulate the various components of your system e.g modules/packages, OOP, functions/subroutines, firewall rules etc. You don't need microservices for this!

- **Flexibility:** Microservices architecture lets you use the best tool for the job. For example, you could use a language with high runtime performance for parts of your system where you want very low latencies. Or use the best database or queuing system for the specific problem you want to solve. In practice, this kind of flexibility causes more problems than it solves. It requires lots of time and money to support some of these technologies, so you want as much standardization as possible. Standardization also makes it easier for developers to move around and collaborate with/learn from each other.

# From monolith to distributed monolith

In a bid to adopt microservices, many an organization end up building distributed monoliths, which give you all the disadvantages of microservices architecture without any of the benefits. If teams can't deploy their code independently, or have to coordinate with other teams to do so, you have a distributed monolith on your hands. If your team topology doesn't allow autonomy, you have a bottleneck upstream. Microservices won't give you better pace. In fact, you'd literally be adding latency to your system.

# How to get microservices right

To make microservices architecture work, you need to figure out a couple things on the technology and people side.

- **Trust:** If you're going to be letting people push to production at will, you want to be able to trust them to do the right thing. So you want competent and experienced engineers. This means your hiring/onboarding pipelines and engineering culture must be on point.

- **Autonomous teams:** You need teams that are small, independent and mission-driven to get the best out of the microservices architecture. These are usually teams tasked with delivering a certain product or set of features to the customer. Microservices won't make a difference if you have large teams, do top-down decision-making or organize around business functions rather than business goals.

- **Self-service platforms:** For teams to be autonomous, they need to depend as little as possible on other teams. This means providing a comprehensive self-service platform for developing and operating their software. If you are practicing "request-driven development" (i.e teams always need help from other teams to get stuff done), you are not ready.

- **One service per team:** The term "microservices" is a bit of a misnomer. It doesn't mean your services need to be micro i.e as small as possible. The goal is not to have as many services as possible. A rule of thumb is one service per team. If you have chosen the right team topology, this would usually mean one service per product/feature. One service housing multiple products/features is also fine, unless you have a team working on two or more unrelated features—in which case you have the wrong team setup. Going with multiple services per team is not worth the increase in development and operational complexity, in my opinion. If a team gets split up, their service should be split as well so that the resulting teams maintain their autonomy. If two teams get merged, it's probably not worth merging their services into one. But if the development resources are available to do so and you don't envision a split in future, go for it!

- **Observability tooling:** Monitoring the state of your system is important. It becomes even more important when adopting microservices because of the higher reliance on inter-process communication. You need to provide a standardized observability stack that allows you collect and analyze metrics, logs and traces across all the services you're running, in real time. It also helps to provide discovery tools for developers so they can know what services are running where, and how their service is interacting with the rest of the system.

- **Development tooling:** You need solid development tools and processes to tame the complexity of microservices. Without this, it's going to be a mess! Here are some tools/processes you might want to consider:
    - **Monorepo:** To [eliminate versioning](/monorepo-use-case/) and simplify cross-cutting changes.
    - **Build automation:** To build/test as much or little of your system as you need.
    - **Containerization:** To simplify development and deployment by packaging your code and all its dependencies together.
    - **Remote development environment:** Because your developers might not be able to run the entire system on their computer.

# Is it for me?

Here's some questions that can help you out:

- [ ] Has shipping code become the bottleneck preventing you from delivering value to your customers as quickly as you'd like?
- [ ] Have you explored all other avenues to increase your velocity and it's still not enough?
- [ ] Do you have all the ingredients needed to get microservices right? (see previous section)

If you check all the boxes, microservices architecture could be the right choice for your organization. If not, maybe you should pass/wait a little bit more.
