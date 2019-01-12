+++
author = "Nicholas Kajoh"
draft = true
image = "null"
slug = "tracking-django-errors-with-sentry"
title = "Tracking Django errors with Sentry"

+++


My first Django site to be deployed in production was a comedy social network I’d spent months crafting to the best of my abilities. I was relatively proud of the project. Some of my friends liked the idea and started using the site. Unfortunately, it was riddled with bugs. So many of them.

My primary method of finding bugs was through a friend, Mike. He was really enthusiastic about the social network. A little more than I was. As such, he was prompt in reporting errors to me so I could fix them ASAP. He’d usually say something like “I got to page x and tried to do y which resulted in error z”. He’d sometimes send screenshots. This was really helpful to me. But sometimes it was difficult to reproduce the errors he was getting. More importantly, is was a very slow and inefficient way to track errors. I was actively publicizing the social network and getting more hits, which translated to more errors and I had a hard time discovering and fixing bugs promptly.