---
share: true
layout: post
title: "Building Neni: legal search that actually has to know the law"
date: 2026-05-04 22:01:00 +0000
display_date: 2026-05-05
published: true
filename: essay/_posts/2026-05-05-building-neni-statute-atlas
tags:
  - AI
  - legal-tech
  - RAG
  - neni
excerpt: "Some notes from building Neni, a legal research app for Kosovo law, and why the hard part was not the chat box but indexing, retrieval, citations, and performance."
image: /images/posts/neni-statute-atlas-2026-05-05.png
---

# Building Neni: legal search that actually has to know the law

I have been working on [neni.me](https://neni.me), a legal research app built on top of Statute Atlas.

The idea sounds simple if you say it too fast: put Kosovo laws into a database, add embeddings, let people ask questions, return answers with citations.

But that is the demo version of the problem. The real version is much more annoying and much more interesting.

Legal text is not a normal document collection. A constitution, a statute, a regulation, a court decision, and a small amendment are all text, but they should not be treated the same. They have structure. They have dates. They have article numbers. They have official sources. Sometimes they change. Sometimes they reference each other. And if the answer is wrong, "the model sounded confident" is not a good excuse.

So the main work was not building a chat UI. The main work was turning a messy legal corpus into something that can be searched, cited, and trusted.

## A Lot Of The Work Is Ingestion

Before the RAG part can be good, the documents have to be clean enough.

Neni has to fetch legal sources, parse the pages or PDFs, extract the actual law text, split it into articles and sections, and keep the metadata around. Things like country, source, document type, publication date, effective date, title, article number, and source URL matter a lot.

If you loose that structure, retrieval becomes mush.

This is why I care about chunking by article or section instead of just cutting every document into random token windows. If someone asks about a legal rule, the answer usually lives inside a specific article, not in some arbitrary slice of 800 tokens. The chunk should know where it came from.

The constitution is a good example. You do not want it only as one big PDF blob. You want each article to exist as a searchable unit, while still keeping its connection to the whole document. Same for statutes. Same for future versions.

## Vector Space Is Useful, But Not Magic

The way most people explain this is: embed every chunk, put it in vector space, then find the closest chunks to the user question.

That is basically true, but it hides the hard part.

Legal search needs both semantic similarity and boring filters. If someone asks about a Kosovo company registration rule, the system should not return something that only matched because the wording was kind of similar. It needs country filters, document-kind filters, source trust, article metadata, and sometimes date filters.

So the retrieval layer is more like:

> understand the query  
> normalize it into legal language  
> search textually  
> search semantically  
> merge the results  
> rerank the best candidates  
> only then ask the model to answer from those citations

That last part matters. The model should not answer from memory. It should answer from evidence.

## Language Makes It Harder

Another problem is how people actually ask questions.

Nobody writes like an official gazette. People ask in Albanian, English, mixed language, Gheg, with missing diacritics, with abbreviations, sometimes with half a sentence. The indexed law text is formal. The query is usually not.

So the system needs a small query-understanding step before retrieval. Not to answer the user, but to translate the question into better search hints: legal domain, possible law titles, and a few formal Albanian rewrites.

This helps a lot because the user might say "qka duhet per shpk", while the law might talk about "shoqëri me përgjegjësi të kufizuar" or "Ligji për Shoqëritë Tregtare".

That is the kind of detail that makes the difference between a nice demo and a tool people can actually use.

## Performance Is Its Own Product Feature

RAG systems can get slow very fast, idk this part is where the nice demos usually start to break.

Every question can trigger query routing, embeddings, lexical search, vector search, reranking, and final answer generation. If you do that naively, the product feels broken even when the answer is correct.

So a lot of the engineering becomes unglamorous things:

> cache query embeddings  
> cache query rewrites  
> keep retrieval candidate pools small  
> cap how many chunks one document can dominate  
> avoid sending too much text to the model  
> use metadata filters before expensive ranking  
> make repeated common questions cheap

This is maybe the least flashy part of AI apps, but probably one of the most important. A legal assistant that takes forever is not good software. It is just a slow demo.

## Citations Change The Whole Design

The answer is not the product by itself. The citation is part of the product.

When Neni answers, it needs to show where the answer came from. Which law. Which article. Which source. Ideally with the exact passage that supports the answer.

That requirement changes the architecture. You cannot just throw documents into a vector DB and hope. You need stable document records, version records, section records, chunk records, and enough metadata to trace every answer back to source.

This is also why I like building this as a legal platform, not only one Kosovo chatbot. The pattern should work for more countries later:

> official sources first  
> version the law  
> index article-level chunks  
> retrieve with filters  
> answer only from cited evidence  
> say "I do not have enough source text" when retrieval is weak

Simple principle, but a lot of engineering underneath.

## What I Learned

The funny thing about building AI products now is that the model is not always the hard part.

The hard part is often everything around it: ingestion, data shape, retrieval quality, latency, trust, citations, evals, and all the boring infrastructure that makes the model useful.

Neni is still early, but this project made that very clear for me.

You can build a legal RAG demo in a day.

Building one that respects the structure of law, keeps sources traceable, handles messy language, stays fast, and knows when not to answer is a very different thing.

That is the part I find interesting.
