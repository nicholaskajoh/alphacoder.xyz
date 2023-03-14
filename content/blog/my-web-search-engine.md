+++
author = "Nicholas Kajoh"
date = 2018-07-26T14:16:00.000Z
draft = false
slug = "my-web-search-engine"
title = "I built my own web search engine — here’s how"
tags = ["Search", "Side Projects"]

+++


I recently finished building a web search engine. Detailed in this article is how I made it. Enjoy!

About my search engine, devsearch
---------------------------------

It was a toy project. The goal was to learn how search engines work by building one, so I wanted it as minimal as possible.

The first step was to narrow my search engine to focus on content in a particular area and a specific format. The web is a very big place. It would take tons of servers to crawl a meaningful portion of the web in good time. I didn’t have the time or the servers. I decided to focus on tech/software development content (hence the name _devsearch_) and to deal only with textual data.

The next step was to decide on the features to implement. The core functionalities of a search engine are crawling, indexing and searching. But there are a ton of other features that make the search engines we use today so good. Features like autocomplete, auto-correct, [stemming](https://en.wikipedia.org/wiki/Stemming), semantic analysis, contextual search (search history, location, season etc), featured snippets, spam detection, knowledge graph etc.

The features I chose to build were:

*   Crawling
*   Indexing
*   Searching (sorting results using TFIDF and PageRank)
*   Autocomplete

Stack
-----

Python was my language of choice. I also used some HTML, CSS and JavaScript. My stack:

*   Flask (micro framework for Python)
*   Scrapy (crawling framework for Python)
*   LXML (for processing XML and HTML in Python)
*   MongoEngine (object document mapper for MongoDB)
*   Bootstrap 4 (CSS library for UI components)

Crawling web pages with Scrapy
------------------------------

[Scrapy](https://scrapy.org/) is a free and open source web crawling framework. With Scrapy, you can create [a _spider_](https://en.wikipedia.org/wiki/Web_crawler), give it a bunch of urls to crawl and tell it what to do with the pages it fetches. You can even tell the spider to crawl the links it finds on the pages it crawls, allowing it to discover new pages.

I took a very lazy approach to parsing the scrapped pages. I used LXML to extract only the text from the HTML response. Say there’s a HTML page like so:

```html
<html>
    <head>
        <title>How Google Search Works</title>
    </head>
    <body>
        <h1>Crawling and indexing</h1>
        <p>As we speak, Google is using web crawlers to organize information from webpages and other publicly available content in the Search index.</p>
        
        <h1>Search algorithms</h1>
        <p>Google ranking systems sort through hundreds of billions of webpages in the Search index to give you useful and relevant results in a fraction of a second.</p>
        
        <h1>Useful responses</h1>
        <p>With more content and in a wider variety on the Internet than ever before, Google makes sure to offer you search results in a range of rich formats to help you find the information you’re looking for quickly.</p>
    </body>
</html>
```    

The output would be:

```
How Google Search Works Crawling and indexing As we speak, Google is using web crawlers to organize information from webpages and other publicly available content in the Search index. Search algorithms Google ranking systems sort through hundreds of billions of webpages in the Search index to give you useful and relevant results in a fraction of a second. Useful responses With more content and in a wider variety on the Internet than ever before, Google makes sure to offer you search results in a range of rich formats to help you find the information you’re looking for quickly.
```

_NB: You lose a lot of important data by doing this but it simplifies things a lot_ 😊

I also extract all the links in each page (necessary for PageRank).

```
Page (How Google Search Works):
    url: https://example.com/google-search
    content: How Google Search Works
        links:
            - Link (Google Search)
            - Link (Search Engines Wiki)
```

There’s a list of allowed domains in the configs (`SPIDER_ALLOWED_DOMAINS`) which helps to fence the spider. It only crawls pages from the websites in that list.

The spider crawls periodically via a cronjob which runs the custom flask command `flask crawl`. A `--recrawl` option can be added to the command to tell the spider whether to crawl new pages or crawl pages it has crawled before in order to update them.

```sh
$ flask crawl --recrawl True
```    

A list of urls to crawl (called Crawl List) is maintained in the DB. There needs to be at least one url in the list for the spider to start crawling. As it crawls, it updates the list with new urls and marks the ones it has crawled.

Indexing
--------

Indexes help us find things quicker e.g the Table of Contents or Glossary in a book. If we wanted to index a website’s SQL DB, we could create an index table similar to this:

```
id title   description    keywords       page
------------------------------------------------
1  G.O.A.T Greatest of... messi, ronaldo /p/goat
```

This is a [_forward index_](https://en.wikipedia.org/wiki/Search_engine_indexing#The_forward_index). It’s very similar to a Table of Contents (which usually has chapter titles, descriptions and page numbers). Instead of writing expensive and complex queries, you can simply lookup the index table and return matching records. However, as the records in the index increase, lookup becomes slower and slower.

There is another type of index which makes searching much faster. It’s the [_inverted index_](https://en.wikipedia.org/wiki/Inverted_index). This is the opposite of the forward index. Instead of having a list of pages and the keywords they contain, we have a list of keywords and the pages they are contained in. This is quite similar to a glossary.

```
id word     pages
--------------------------------------------------------
1  greatest /p/goat /u/messi /u/ronaldo /t/football
2  of       /p/goat
3  all      /p/goat /home
4  time     /p/goat /fixtures
```

The trade-off with the inverted index is _higher disk comsumption for faster lookup speed_. I used an inverted index for _devsearch_.

TFIDF and PageRank
------------------

Modern search engines consider many factors when ranking search results. Common factors include TFIDF, PageRank, words position, freshness, page loading speed, CTR and mobile-friendliness.

Google says they consider [over 200 factors](https://backlinko.com/google-ranking-factors). Each factor has a weight that signifies its importance in the ranking process. Google keeps all this information secret to prevent people (AKA black hat SEOs) from gaming the system. They also [change things pretty frequently](https://moz.com/google-algorithm-change) in order to improve search results.

I chose TFIDF and PageRank for my search engine. TFIDF stands for _term frequency–inverse document frequency_. It is a numerical statistic that is intended to reflect how important a word is to a document in a collection. The idea is that if a word appears frequently in a document, then the document is probably about that word. In this article for instance, the words ‘search’ and ‘engine’ appear frequently. So we can assume it at least has something to do with search engines, and that if someone were to search for ‘search engine’ this article would be more relevant to them than another article that mentions it once or twice. There are words that usually appear frequently in documents though e.g [stop words](https://en.wikipedia.org/wiki/Stop_words) like ‘a’, ‘and’, ‘the’ etc. We can offset these words and give more weight to words that occur less frequently in the whole collection but more frequently in a given document. The formula for TFIDF can be found in [this article on Wikipedia](https://en.wikipedia.org/wiki/Tf%E2%80%93idf).

Developed by Larry Page and Sergey Brin, [PageRank](https://en.wikipedia.org/wiki/PageRank) is the most notable algorithm used in Google Search. PageRank works by counting the number \[and quality\] of links to a page to determine a rough estimate of how important the website is. The underlying assumption is that more important websites are likely to receive more links from other websites. I used [the simplified version of the algorithm](https://en.wikipedia.org/wiki/PageRank#Simplified_algorithm) for _devsearch_. All pages start with an initial PageRank of 1 / N (where N = total number of pages in DB) and then “[link juice](https://www.woorank.com/en/edu/seo-guides/link-juice)” begins to flow until all pages are ranked.

I combined the TFIDF and PageRank values to produce a score which is used to rank results.

Searching and autocomplete
--------------------------

When a user types in a query into _devsearch_, the query is divided into a list of words. The index collection (MongoDB) is filtered for records that have any of those words. Each index record has a score which is precomputed using the formula:

```py
score = (tfidf / max(tfidf) * 0.7) + (pagerank / max(pagerank) * 0.3)
```

TFIDF represents 70% of the score and PageRank represents the remaining 30.

An aggregate score is computed for each distinct page. So if the search query is _‘rick and morty’_, a page that contains all the words would have an aggregate score of: `total_score = score('rick') + score('and') + score('morty')`.

The records are sorted in descending order of `total_score` and then paginated.

Autocomplete for the search box is very very basic. I didn’t want to get AJAX involved, so I just queried the DB for a list of the top 200 searches on the search view and passed them to a JavaScript function which uses sub-string matching to determine whether a query should be shown or not when a user is typing their query. 😉

Deploying the search engine
---------------------------

I used Docker (and Docker Compose) to containerize _devsearch_ and run it on a DigitalOcean Debian machine. The MongoDB server is also containerized. The production Docker Compose file uses Nginx as a reverse proxy for the Gunicorn server running the Flask app. Nginx also serves the static files.

* * *

The search results from _devsearch_ are abysmal (good thing I wasn’t hoping to build the next Google Search). However, I learnt a ton about search engines and search algorithms, and have already started exploring the areas most interesting to me. Most important, I understand a little better how search engines work! 🙌

You can find the source code for _devsearch_ on my GitHub: [**nicholaskajoh/devsearch**](https://github.com/nicholaskajoh/devsearch).