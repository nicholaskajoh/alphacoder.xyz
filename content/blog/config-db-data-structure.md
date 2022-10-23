---
title: "A scalable data structure for your configuration database"
date: 2022-10-09
draft: false
slug: "config-db-data-structure"
tags: ["Scalability"]
---

Most software of reasonable complexity are configurable—that is, they allow you change their functionality through the use of flags/settings. While you could store configuration information in code or text files, for web apps, it’s more common to store them in databases. This allows you make changes to the configs at runtime i.e without having to restart or redeploy your app.

In this article, I’ll be exploring the ways I thought about improving the config storage mechanism in a large enterprise system I worked on, which made use of thousands of configs. The issues I identified were:

- **Configs scattered across multiple tables/databases and in different formats, making it difficult to provide a centralized view of the system’s configuration state:** Want to know if feature X is enabled? Easy-peasy! You only need to check that these 5 rows in these 3 different tables have these specific values. And there’s a different mechanism for determining feature Y’s state. This was made worse by the fact that not everyone had access to all the databases where configurations were stored. The solution here is creating a standard format for storing your configs and storing them in a single location to make access, query and analysis easier.
- **Lack of schemas for configs, leading to type errors:** One time, someone updated a config with invalid data which brought a business-critical part of the system to its knees. I also had my fair share of breaking production because of silly mistakes like typos. Having a schema to validate changes goes a long way in preventing human error like this.
- **Lack of documentation on what each config does:** You had to read and understand the code to know how the configs worked. This takes time and is not feasible for non-coders (such as a non-technical product owner), who should be able to change the configs without the aid of a developer. While detailed documentation on how to use certain configs would be invaluable to your team, a simple description would do a lot of good.
- **Lack of audit logging:** Not all config modifications were logged so it was sometimes hard to figure out issues resulting from problematic configurations by correlating the changes with incidents. An audit logging system with view of what changed, how it changed and why goes a long way in helping an incident response team troubleshoot and resolve production issues. They could for example, query for all the changes that were made leading to an incident, and pull in the config owners/changers to help out.
- **Lack of access for developers/product owners:** As a developer, I should be able to make changes to a config I created—or at lease someone on my team should. Having to open a change request ticket kind of defeats the purpose because it might even be faster to make the change in code and get it deployed. Also, a decision maker (such as a product owner or operations staff) should not have to pull in a developer when they want to change something. If they are allowed to make a decision about whether or not something should be changed, they should also be able to click a button or invoke an API endpoint to do so. Because only admin users could make changes to the config databases, it was unnecessarily stressful and time-consuming to get things done.
- **Lack of automation for config state changes:** While we had circuit breakers for temporarily switching off or diverting traffic from failing services, we lacked the ability to temporarily toggle the switches ourselves. It was very common for someone to forget to switch something back on that they switched off a while ago. For instance, an on-call engineer would forget to switch a service that experienced a down time back on when the issue had been resolved. Having a functionality that allows the engineer to say “turn off service X for Y hours”, for example, could solve this.

# Functional configs

The big takeaway from all these issues is that one should centralize their system’s configurations and organize them by function rather than product, service or feature. Of course, there are downsides to centralization such as introducing a bottleneck and a single point of failure, but for a system such as this, it’s a good trade-off in my opinion. Instead of having a config row, table or database for each product, service or feature, you could break down your configs by the following functions:

## Feature flags

A feature flag is a config used for releasing new changes. There’s always some risk involved in deploying new code. You can manage that risk by putting new changes behind a feature. If something goes wrong, you can turn off your feature to mitigate the incident and then look into it later, instead of scrambling to deploy a fix or revert the change. Also, instead of releasing a feature to all your users, you could limit it to a small subset as a way to pilot the feature, and then gradually increase the traffic as you gain confidence that things are working as expected.

It's important to factor in granularity when designing feature flags i.e

- **Binary flags:** feature is enabled if flag is true and disabled when false.
- **Key-based flags:** feature is only enabled for entities (such a users or merchants) whose keys (like user ID and merchant name) have been specified.
- **Percentage-based flags:** feature is only enabled for a specified percentage of invocations e.g 10% of traffic.

You could create a `features` table for your feature flags like so:

| id | feature_name | <div style="width:350px">description</div> | enabled | percentage | enabled_for_entities | entity_key | cache_for_secs | expires_at | created_at | updated_at | <div style="width:250px">public (available to clients?)</div> | deleted_at |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | GOD_CLASS_REFACTOR_SHADOW_MODE | The class that does everything and single-handedly runs this business has been broken down into 100+ smaller classes for readability and extensibility. We are running the new changes in shadow mode to ensure the outputs are correct. Enabling this flag will result in increased latency because we'll be running both old and new code. | true | 20 | NULL | NULL | 60 | 2023-01-01 17:06:09 | 2022-12-01 09:41:09 | 2022-12-01 09:42:09 | false | NULL |
| 2 | SHOW_NEW_PRODUCT_PAGE | We’ve redesigned the product page using our fancy new design system. We want to pilot it with a few users to get feedback before rolling it out to everyone. | true | 100 | [1, 2, 69, 419, 420] | users.id | 180 | 2023-01-01 17:06:09 | 2022-12-01 09:41:09 | 2022-12-01 09:42:09 | true | NULL |

## Kill switches

A kill switch is just like a feature flag but it is permanent and meant for turning off components of your system when things go wrong or when you're doing some maintenance. Say you’re an e-commerce store on Black Friday experiencing much more traffic than anticipated. You can use a kill switch to turn off non-business-critical parts of your system (like product recommendations) so that the more important components (like checkout and payments) can breathe.

You could create a `switchboard` table for your kill switches:

| id | switch_name | <div style="width:350px">description</div> | enabled | percentage | enabled_for_entities | entity_key | cache_for_secs | created_at | updated_at | deleted_at | public |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | PRODUCT_RECOMMENDATION_SERVICE | Recommendation system that suggests new products to users based on their purchase and browsing history. | false | 69 | NULL | NULL | 420 | 2022-12-01 09:41:09 | 2022-12-01 09:42:09 | NULL | true |

## Application configs

These are configurations for variables in your application that you might want or need to change at runtime e.g the default rate limit for an endpoint or the API URL for your payment service provider.

Say you need to send your users notifications via SMS, so you decide to build an SMS notification service for your product. Perhaps, there’s no one SMS provider that can send SMSes in all the countries you operate. More so, local providers offer better delivery rates and pricing. And you want to have backups should a provider experience a downtime. You have decided that the best solution would be to integrate multiple SMS providers. You could structure the configs for this application/service like this:

Table: `data_types`

| id | name | <div style="width:200px">description</div> | <div style="width:400px">validator (JSON schema)</div> | default_value | <div style="width:350px">cardinality (max number of configs of a given type per table/account; -1 => infinite)</div> | <div style="width:300px">account_configurable (can an account holder modify this config?)</div> | created_at | updated_at | deleted_at |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | SMS_PROVIDER | An SMS service provider. | `{"$schema":"https://json-schema.org/draft/2020-12/schema","$id":"https://schemas.alphacoder.xyz/sms-provider.json","title":"SMS Provider","description":"An SMS provider.","type":"object","properties":{"name":{"description":"The name of the SMS provider.","type":"string"},"priority":{"description":"Priority of the SMS provider. We will prefer providers with higher priority. A lower value means a higher priority.","type":"integer","minimum":1},"available_countries":{"description":"Countries supported by SMS provider.","type":"array","items":{"type":"string","minLength":2,"maxLength":2},"minItems":1,"uniqueItems":true},"api_url":{"description":"SMS provider API URL.","type":"string"},"api_secret_alias":{"description":"SMS provider API secret alias.","type":"string"}},"required":["name","priority","api_url","api_secret_alias"]}` | NULL | -1 | false | 2022-12-01 09:41:09 | 2022-12-01 09:42:09 | NULL |

Table: `app_configs`

| id | name | data_type_id | <div style="width:400px">value</div> | created_at | updated_at | deleted_at |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | sms_bros | 1 | `{"name":"SMS Bros","priority":1,"available_countries":["NL","NG","US"],"api_url":"https://sms.bros.io/send","api_secret_alias":"SMS_BROS_SMS_API_SECRET"}` | 2022-12-01 09:41:09 | 2022-12-01 09:42:09 | NULL |
| 2 | fatsms | 1 | `{"name":"Fat SMS","priority":3,"available_countries":["NG","GH"],"api_url":"https://fatsms.co/api/smses","api_secret_alias":"FAT_SMS_API_SECRET"}` | 2022-12-01 09:41:09 | 2022-12-01 09:42:09 | NULL |

## Account configs

These are just like app configs, but for accounts. Say your product has multiple pricing plans, each with its set of features. You could use account config tables to store data on what features each user has access to based on the plan they paid for.

Table: `data_types`

| id | name | <div style="width:200px">description</div> | <div style="width:400px">validator (JSON schema)</div> | default_value | <div style="width:350px">cardinality (max number of configs of a given type per table/account; -1 => infinite)</div> | <div style="width:300px">account_configurable (can an account holder modify this config?)</div> | created_at | updated_at | deleted_at |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2 | FEATURE_UNLIMITED_UPLOADS | Feature allowing users upload as many files as they want. | `{"$schema":"https://json-schema.org/draft/2020-12/schema","$id":"https://schemas.alphacoder.xyz/boolean.json","title":"Boolean","type":"boolean"}` | true | 1 | false | 2022-12-01 09:41:09 | 2022-12-01 09:42:09 | NULL |
| 3 | FEATURE_UNLIMITED_COLLABORATORS | Feature allowing users permit as many other users as they want to view and edit their files. | `{"$schema":"https://json-schema.org/draft/2020-12/schema","$id":"https://schemas.alphacoder.xyz/boolean.json","title":"Boolean","type":"boolean"}` | false | 1 | false | 2022-12-01 09:41:09 | 2022-12-01 09:42:09 | NULL |
| 4 | FEATURE_PLUGINS | Feature allowing users install plugins to customize their setup. | `{"$schema":"https://json-schema.org/draft/2020-12/schema","$id":"https://schemas.alphacoder.xyz/boolean.json","title":"Boolean","type":"boolean"}` | false | 1 | false | 2022-12-01 09:41:09 | 2022-12-01 09:42:09 | NULL |

Table: `account_configs`

| id | data_type_id | account_type | account_id | value | created_at | updated_at | deleted_at |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 2 | user | 69 | true | 2022-12-01 09:41:09 | 2022-12-01 09:42:09 | NULL |
| 2 | 3 | user | 69 | true | 2022-12-01 09:41:09 | 2022-12-01 09:42:09 | NULL |

# Config system features

Creating a scalable data structure for your configuration system is just one side of the coin. You also need to provide a feature set that makes the system operationally efficient.

## Access control

Like I mentioned earlier, the people deciding what state your system should be in should also be able to make the changes necessary to achieve the desired state. Of course, at the same time, you need to have proper controls in place. Your config database is the control panel for your app, so you don’t want people who have no business interacting with it be able to gain access to it.

## Audit logging

Since potentially lots of people would be making lots of changes to your config database, you want proper audit logging. The logs would be useful during incidents as described earlier, but also for security and documentation. 

## Change queue

A change queue is basically a way to queue changes to the config database. Its purpose is automation. For example, if you wanted to turn off a service temporarily or release a new feature at a specific time, you could push that to the change queue and a job that consumes the queue would execute it so you don’t have do it manually.

## Tagging

Another important feature is tagging. Since configs would be organized by function, you need a way to group your configs by product, service, feature or any other category you fancy. This is purely for the benefit of the people interacting with the configuration database. You could create a tag for your SMS notification system, for example, which would let one pull up all the configs related to this service.
