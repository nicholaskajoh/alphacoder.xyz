---
title: "How to build a payment service provider (PSP) — on paper"
slug: "payment-service-provider"
date: 2019-01-17T09:08:26+01:00
tag: ["Payments"]
draft: true
---

Payment Service Providers (Stripe, Visa, Paystack)
Payment Processors (Front-end, Back-end)
Switching
Merchant accounts
Acquiring banks
Card-issuing banks
Card associations (Visa, Mastercard)
Security (PCI-DSS)
ISO 8583

customer -> [ card details ] -> payment gateway -> [ transaction info ] -> payment processor (FE) -> [ transaction info ] -> card association -> [ auth request ] -> issuing bank -> [ auth response ] -> payment processor -> [] -> payment gateway -> [ authorization/auth ] -> merchant website (2 to 3 seconds)

issuing bank -> [ clear auth ] -> payment processor (BE) -> [ settlement ] -> merchant account in acquiring bank (3 days)

https://en.wikipedia.org/wiki/Payment_gateway

Security measures
Address verification system (AVS)
Card security code (CSC) / Card verification value (CVV)
Fraud screening service

Regulatory Requirementsfor NonBank Merchant Acquiring in Nigeria - https://www.cbn.gov.ng/Out/2018/BPSD/Exposure%20Draft%20of%20Regulatory%20Requirementsfor%20NonBank%20Merchant%20Acquiring%20in%20Nigeria.pdf

PCI-DSS
https://www.pcisecuritystandards.org/document_library?category=pcidss&document=pci_dss
http://pcidsscompliance.net/

Gateway: A payment gateway is a tool that securely transmits the online payment data to the processor to continue the lifecycle of the transaction. Think of it as an online point-of-sale terminal for your business.

Processor: A payment processor executes the transaction by transmitting data between the merchant, the issuing bank and the acquiring bank.

---



If you've ever integrated payments in a software application before, chances are that you've wondered how online payments actually work and if you can build an end-to-end payment system for yourself. Maybe not. In any case, it's interesting to explore the steps and processes involved in building a payment service provider (PSP) like [Stripe](https://stripe.com) or [Paystack](https://paystack.com). In this post, I'll show you how to build a PSP — on paper.

__NB:__ _online payments, as you may already know, is not exactly straightforward, and a lot of things depend on the country where you're providing payment services. As such, we'll be focusing on building a PSP in Nigeria (because I'm most familiar with the Nigerian online payments industry). But don't worry. I'll generalize where possible and present all the information in a way that would make it easy for you to find out what is obtainable in other countries._

It helps to understand how online payments work in order to build a PSP. Say we run an e-commerce website that sells branded merch. What happens when a buyer adds a hoodie to their cart and tries to pay for it? Outlined below is a rundown of what happens when they checkout.

- The customer enters their card details into a 

# Terminology
There are several terms associated with online payments — some more confusing than others. Let us define some of the more common ones so that we can be on the same page.

- Payment gateway
- Payment processor
- Card association
- Issuing bank
- Acquiring bank
- Merchant account

# Security
Security is probably the most important thing in online payments.

# Certifications, Licenses and Partnerships
While building PSP tech is not a trivial task, the major work is in getting certifications, acquiring licenses and establishing key partnerships.

# Full stack PSP

# Payment gateway

# Payment processing system

# Acquiring bank