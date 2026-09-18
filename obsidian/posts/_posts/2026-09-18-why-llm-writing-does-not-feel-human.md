---
share: true
layout: post
title: "Why LLM writing does not feel human"
subtitle: "The words got fixed. The feeling did not, and I think the training data is the reason."
date: 2026-09-18
published: true
permalink: /why-llm-writing-does-not-feel-human/
tags: [AI, writing]
excerpt: "The big models stopped using the words we mocked, yet you still know within a sentence that a model wrote it. My view: the data behind them is drifting away from how people actually write, and more synthetic data will make it worse."
---

You can tell. Someone pastes a paragraph into a chat, a pull request, a support reply, and within a sentence you know a model wrote it. Not because of a wrong fact or a bad argument. It just does not feel like a person.

Two years ago people blamed the words. "Delve", "tapestry", "leverage". I checked that with the current models and the words are gone. I asked Claude Sonnet, Claude Opus and two Codex models to write 96 short everyday and engineering texts, then compared them with 72,000 words of commit messages written by engineers before ChatGPT. Not one "delve". The models' vocabulary is even plainer than the engineers'.

And still every answer reads like a model. So it was never the words.

## What actually feels off

Read the human commit messages and the model answers side by side and the difference is not in any single line. It is in the shape.

The humans are uneven. They start mid-thought, they say "otherwise" when they are weighing a case, they leave a sentence hanging, they skip the introduction because the reader already has context. They write for one specific person on one specific day.

The models are even. Every answer has the same rhythm: a framing line, a body with the same punctuation, a soft close. All four models, from two different companies, share that rhythm. In my sample the em dash appears in most answers from every model and zero times in the human text. Eleven answers open with "Here's". The humans never did. Those are just the parts I could count. The rest of the feeling is the same thing at a level I cannot count: the same shape, every time, for everyone.

## Why I think this happens

A model learns what writing is from its data. For the first generation that data was mostly people. Since then a growing share of what goes into training is written by models: synthetic examples, model-rewritten documents, answers rated by other models. It is cheap, clean and endless, so labs use more of it every year.

Model-written data has no specific person and no specific day behind it. It is the average of every text, and the average has one shape. When a model learns from that, it learns the shape more firmly than the last one did. The words got fixed because "delve" was a public joke and easy to filter. The shape did not get fixed because nobody named it, and because the data itself keeps teaching it.

That is my point. The reason LLM writing does not feel human is not a style setting. It is where the writing came from.

## What would change it

More real data from real contexts, and less of the synthetic kind. Companies sit on decades of text written by actual people to actual people: tickets, reviews, internal docs, support threads, engineering discussions. That is messy and specific and it belongs to someone, so it is harder to use than a generated dataset. It is also the only kind of text that carries the thing the models are missing. Quality here means provenance: written by a person, for a reason, in a place. A model trained on more of that and less of its own output would sound less like every other model.

I cannot see inside the labs, so this is a reading, not a proof. The small test that started it is in the [experiments folder](https://github.com/edihasaj/edihasaj.com/tree/main/experiments/llm-vocab) of this site, if you want to check the numbers or run it against a newer model.

This post contains no em dashes. It took editing.
