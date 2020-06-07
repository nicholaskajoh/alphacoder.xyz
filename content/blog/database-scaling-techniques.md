---
title: "Database scaling techniques"
slug: "database-scaling-techniques"
date: 2020-06-07T11:46:24.610Z
draft: false
tags: ["Databases"]
---

Over the years, I've had an usual interest in techniques for scaling databases to meet high demands in terms of performance and reliability. I'm not exactly a fan of database administration but I've always had the anxiety that a design decision I'm making now will come back to haunt me in future. I quickly learned that trying to setup a system that can handle, say, a million users when one has only a thousand is a waste of time and resources. However, I wanted to know the progression that will lead me to such a point so that I can plan with foresight.

After lots of reading and a fair amount of practice on the job, I've learned some of the common techniques used to scale databases. I've organized them in a relatively increasing order of relevance as one's database load grows.

# Query optimization
This is the good old technique of finding poorly written queries or queries that could be improved upon and making them more efficient. To be able to write optimal queries, you need to have a good handle of the query language (e.g SQL), as well as the database engine (e.g MySQL or PostgreSQL). Simple tips like selecting specific fields as opposed to selecting all fields (`SELECT *`) when not required can go a long way in giving your application the performance boost it needs.

Visual inspection of queries might not be sufficient as some queries only break when confronted with large amounts of data or heavy traffic. Application Performance Monitoring (APM) tools can be instrumental in finding these bottlenecks as they allow you view the performance metrics of all your queries and figure out which ones are degrading your database.

# Indexing
Indexing in simple terms means organizing data in a way that makes it faster to retrieve. Relational databases allow you create indexes on one of more columns in your tables. This can result in huge performance gains with little or no effort and as such is highly recommended as a way to optimize your database. For the best results, [indexes should be based on the kind of queries being run against a given database](https://www.dbta.com/Columns/DBA-Corner/Top-10-Steps-to-Building-Useful-Database-Indexes-100498.aspx).

# Denormalization
I've discussed denormalization in reasonable detail [in a previous article](/database-denormalization/) so I won't say much more than the basic idea of what it entails. The goal of denormalization is to improve read performance by adding redundant copies of data to make for faster access using simpler queries. This is essentially indexing but done by a schema designer rather than a database engine, and it can be a great addition to indexes if carried out purposefully.

# Primary-replica architecture
This involves [scaling a database horizontally](https://stackoverflow.com/a/11715598/6293466) by running two or more instances. One is designated the primary database and handles writes while the others are replica databases which handle reads. The database engine uses a replication protocol to keep all the instances in sync by copying the data from the primary database to the replicas. This setup comprises a database cluster. The pros of the architecture include traffic load balancing and automatic data backups which result in improved performance and reliability of a database.

# Multi-cluster database
A multi-cluster database takes the primary-replica architecture to the next level. In this technique, the database tables that make up an application are grouped by function and each group is designated a cluster of its own. For instance, all the tables concerned with billing might be put in one cluster while those concerned with a feature, say private messaging, might be put in another. Care must be taken while grouping tables to avoid a situation where one or more related tables have been split across database clusters, and expensive operations are required to obtain a piece of data needed in your application as a result.

# Sharding
Sharding is the process of horizontally partitioning data into multiple databases. Instead of splitting a database by groups of tables as described earlier, a table's rows are split across multiple instances. In order to save or retrieve a piece of data, certain [models](https://www.citusdata.com/blog/2017/08/28/five-data-models-for-sharding/)/[algorithms](https://docs.microsoft.com/en-us/azure/architecture/patterns/sharding#sharding-strategies) are employed in determining the [shard](https://en.wikipedia.org/wiki/Shard_(database_architecture)) to use/where the data resides. This adds a fair amount of complexity to your database setup and your application as well. Operations that might otherwise be straightforward can become a challenge under this configuration. As such sharding is usually reserved for last and carried out by admins who have a solid grasp of the database engine they're dealing with.
