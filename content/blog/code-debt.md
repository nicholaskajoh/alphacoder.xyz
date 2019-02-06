---
title: "Dealing with code debt"
code: "dealing-with-code-debt"
date: 2019-02-06T19:40:38.172Z
draft: false
---

Code debt (or technical debt) is the amount of extra work that needs to be done due to choosing the easy way now instead of a better way that would take more time to complete. It's ~~human~~ developer nature to always follow the path of least resistance e.g write spagetti code or fail to think things through before coding. As such dealing with code debt must be given priority by individuals and teams that want to build good software in a cost and time effective manner.

Code debt is not necessarily a bad thing though. As bestselling _Rich Dad, Poor Dad_ author Robert Kiyosaki says, "good debt makes you rich and bad debt makes you poor". It must however be kept at a minimum at all times. This can be achieved by avoiding debt as much as is within one's power and spending a good chunck of dev time paying off the debts already owed. A wise man once said "a good developer always pays their code debts".

When could we incur code debt i.e "good" debt? Writing elegant and future-proof code is not always possible as one may have limited time and/or experience in a given domain. For instance, it is not uncommon to find a lot of code debt in fast-paced environments like at startups trying to ship an MVP or find product-market fit. However, if the debts are not paid soon afterwards, a lot of damage can happen in future.

Outlined below are some steps to take in dealing with code debt.

- __Design first:__ Before writing the first line of code, make sure you have at least a conceptual idea about how the addition would fit in to what already exists to make it extensible or at least prevent it from being less flexible. Try to add as little as possible when making changes (less code generally means less debt). But also try to make things as generic as possible so that they can easily adapt to evolving requirements. To do this, an understanding of the system as a whole is vital. Make sure your team knows where the product is coming from, where it is in the present and where it's going to.

- __Enforce a coding style:__ A coding style makes your codebase more readable and consistent. It can prevent developers from writing spagetti code or introducing their own ideology of what "good" code should look like. The result is higher dev velocity, less arguments, and ultimately, less debt. Use a linter to enforce a coding style. You may choose to use a standard developed by others, customize it or develop your own. Add linting to your deployment pipeline so that only acceptable code gets checked in or goes to production.

- __Perform code review, always:__ Code reviews should be a core part of the software development process. Critiquing code helps catch bugs but more so, it provides a medium to question technical decisions that can lead to code debt. Devs are forced to think of the best way instead of the easy way because their work would be critiqued by their peers and my be rejected if not up to par.

- __Refactor regularly:__ The more code that is added on top of code that needs to be refactored, the more difficult it is to refactor the code. Eventually, after adding more and more code (most of which would likely be "bad" code), it becomes impossible or nearly impossible to refactor or maintain and a rewrite becomes inevitable (which is costly in time and money). After every release or sprint or dev cycle, make it a duty to refactor the codebase to make it more readable, extensible, scalable etc.

- __Make documentation a requirement:__ Documentation not only provides a reference for you and your team, it helps you establish a collective understanding of the system you're building (that is, how it is actually expected to work). It also provides an avenue to evaluate the current implementation against what the system is supposed to be, and it sparks up questions about assumptions and decisions made.

- __Automate testing:__ The most important thing for me in automated testing is regression. That is, re-running a suite of tests that set the requirements (both functional and non-functional) of the system to ensure nothing broke while a change was made. If done well, it ensures that no (or few) stones are left unturned. It also makes debugging easier and boosts developers' confidence in the system which is super important.

Any reasonably complex codebase has some debt. Even simple ones do. The goal is to reduce this debt as much as possible and keep it that way as more code is added. This must be done proactively or else debt would compound to the point where continued development isn't feasible any longer. At this point, a rewrite may be the only logical solution. This can hurt a business and its development team badly.