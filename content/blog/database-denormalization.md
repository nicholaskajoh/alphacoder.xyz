---
title: "Database denormalization"
slug: "database-denormalization"
date: 2020-06-05T13:46:02.154Z
draft: false
tags: ["Databases"]
---

Normalization is a vital part of database schema design. The goal is to structure a relational database so as to reduce redundancy and improve the integrity of data. Given this understanding, denormalization sounds rather counter-intuitive. Why would one want to make a database "less normalized"?

Well, it turns out that normalization comes at a performance cost for DB read operations. This is just fine for regular applications. However, read-heavy apps start to break at scale under this setup due to resource-intensive SQL queries involving joins, subqueries and the like. Denormalization helps improve read performance by adding redundant copies of data to make for faster access using simpler queries.

It's worth noting that _denormalized data_ is different from _unnormalized data_. While the latter refers to data before normalization, the former is a transformation of normalized data.

So how does one denormalize? The changes to be made in order to denormalize your data vary based on the type of application, existing database schema and optimization needs. However, the reasoning behind them are the same i.e you want to make data retrieval as fast as possible. Outlined below are a few tips to help you in this process:

# Duplicate fields that seldom if ever change
Say you operate a popular ecommerce website and your fulfilment staff are having a hard time viewing the orders because the API that retrieves this information is slow. You might take a look and realize that the bottleneck is your _orders_ table which has lots of relationships that need to be populated in order to retrieve a couple important fields. Some of these fields will seldom, if ever change (at least within the period in which an order must be fulfilled) so you proceed to denormalize them by creating new columns in the _orders_ table.

For example, you might determine that the list of ordered products rarely changes. However, in order to get this list, you've had to use a join to pull the data from the _products_ table. By adding an _ordered\_items_ column to the _orders_ table which will contain JSON arrays of product SKUs and order quantities, you may be able to reduce the latency of the API by a substantial amount. This, coupled with other such optimizations has the potential to deliver significant performance gains.

The cost of these changes is little. If the list of ordered products does change (a rarity), all it takes is updating the _ordered\_items_ column. While this will increase disk usage, it's not a concern for most.

# Duplicate fields with high read to write ratios
Taking our ecommerce website scenario forward, you might discover that your products display pages have become slower because they're one of the most trafficked part of the site. In seeking ways to optimize these pages, you realize you can simplify the query that fetches products by denormalizing some of the data in products-related tables including _product\_options_, _categories_, _product\_media_ and _tags_. By adding several new columns in the _products_ table so you don't have to query other tables, you might be able to increase the load times of these slow pages.

It turns out that you don't update products very often (maybe once a week on average). However, hundreds of people view these products every second. It makes sense to denormalize in this case because your products data has a high read-write ratio.

# Create columns or tables for frequently used aggregates
Frequently used aggregates (for example the total amount made from orders this week or the number of times a coupon has been used) don't have to be computed on the fly. You can pre-compute them and store the results in another table or a new column for faster retrieval. If these aggregates are likely to change in future, you can recompute them periodically or at the point when their inputs change.


It goes without saying that you should NOT denormalize until you encounter data retrieval issues. Like with most software engineering problems, there are tradeoffs! Also, denormalization is [not the only way to optimize/scale databases](/database-scaling-techniques).