+++
author = "Nicholas Kajoh"
date = 2018-12-10T20:46:00.000Z
draft = false
image = "/content/images/2018/12/katerina-radvanska-373287-unsplash-sm.jpg"
slug = "check-domain-availability-from-your-terminal"
title = "Check domain availability from your terminal"

+++


I have a theory — that domain registrars share your search queries with resellers. Countless times I’ve had the bad experience of searching for a domain to see its availability then finding out a day/a few days later that it has been bought or made premium. Sure, it’s very possible that it may have been _legitly_ purchased by someone else. But I’ve been in a couple forums where people have complained about the same thing. Also, sometimes the registrar you searched at tells you it has been bought or you have to pay a premium for it but another registrar which you haven’t searched with tells you it’s available and you’re actually able to buy it.

You can boycott registrars by doing a WHOIS lookup on the desired domain instead. If a match is found, info about the domain is displayed but if no match is found, you know the site is available. There are a couple of websites that provide this functionality, most notably [https://www.whois.com](https://www.whois.com/). Alternatively, you can use the WHOIS CLI tool.

To install, run…

    $ sudo apt install whois

_If you’re a Windows user, you can download the WHOIS CLI here:_ [_https://docs.microsoft.com/en-us/sysinternals/downloads/whois_](https://docs.microsoft.com/en-us/sysinternals/downloads/whois)_._

To check for availability of a site, run `whois sitename.tld`. E.g:

    $ whois example.com

If it's been registered, you’ll get a result like so…

![](https://cdn-images-1.medium.com/max/1000/1*_KfHQUBzwAQUiq0NaGFAeQ.png)

If not, you’ll get something like this…

![](https://cdn-images-1.medium.com/max/1000/1*b2-XSsJ-M2Z_5lbPiv0qCw.png)