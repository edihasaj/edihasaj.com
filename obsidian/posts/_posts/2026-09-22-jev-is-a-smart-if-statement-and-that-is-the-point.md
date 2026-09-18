---
share: true
layout: post
title: "Jev is a smart if statement, and that is the point"
subtitle: "For a year we used language models as decision functions. TypeSafe just shipped an actual decision model."
date: 2026-09-22
published: false
permalink: /jev-is-a-smart-if-statement/
tags: [AI, software]
excerpt: "Most of what my agents ask a model is not 'write this' but 'is this X or Y'. Those calls were slow, costly, and never quite deterministic. Jev is built for exactly that gap, and the category matters more than the vendor."
---

Look at what a real agent pipeline actually asks a model, call by call. Is this diff risky? Which team does this ticket belong to? Is this correction worth remembering? Should this tool call be allowed? Does this search result answer the question?

Almost none of those need a paragraph. They need a yes, a choice, or a score. For the last year we have been asking a frontier language model, waiting a second or two, paying for the tokens, parsing JSON out of prose, and retrying when it came back malformed. It worked. It was also the wrong tool, and everyone building agents knew it.

On 15 September TypeSafe AI came out of stealth with [Jev](https://www.typesafe.ai), and their own description is the best one: a smart if statement.

## What it is

Jev is not a language model. It cannot write text at all. You give it state, either text or JSON, and typed questions with a fixed answer space. Three kinds: yes or no, a choice from options, or a score on a scale. It returns the answer, a probability for every option, and a confidence value. That is the whole API.

Because the answer space is declared up front, it cannot return something outside it. No malformed JSON, no "As an AI" preamble, no hallucinated fourth option. TypeSafe calls this a System One model and trained it with a method they call RLCD, reinforcement learning for calibrated decisions, so the probabilities are supposed to match how often the answer is actually right.

Numbers from their launch: most calls land around 100 milliseconds, input costs $0.042 per million tokens and output is free. They claim around 200 times faster and 400 times cheaper than a frontier LLM on classification. Those are launch-week vendor claims, so treat them as such. Even if they are off by ten, the gap is still a different category.

## Why this matters more than the model

The thing I care about is not Jev. It is the split.

We have been using one kind of model for two different jobs. Generation, where you want a paragraph and some creativity is fine. And decision, where you want the same answer every time for the same input, fast, and with a number that tells you how sure it is. Frontier LLMs are great at the first and a wasteful, jittery fit for the second.

A decision model with typed outputs and calibrated confidence changes what you can build. You can set a threshold. Above 0.95, act. Below, escalate to a bigger model or a person. That is a normal engineering control, and until now it was hard to get from an LLM because the confidence was vibes.

Deterministic is the wrong word, strictly. It is still a model and it can still be wrong. But the shape of the output is deterministic, and that removes most of the failure modes I actually hit in production: parse errors, drift between runs, and a bill that scales with how chatty the model felt.

## Where I would use it tomorrow

Two weeks ago I wrote about [teaching a 9B model to route support requests](/farka-qwen-support-routing/) into billing, account, or technical. That is a choice question. It is exactly Jev's shape.

In my agent pipeline there is a security review and a code review gate. The first question each one answers is "does this diff touch anything risky." Yes or no, with a confidence I can threshold. Recall, my memory layer for agents, has a quality gate that decides whether a correction is a durable rule or a one-off. Same shape. Oktapod decides whether a tool call needs approval. Same shape.

Every one of those is a frontier model call today. Each one is a candidate for a 100 millisecond typed answer.

## Where it stops

It is a week old, and the "cannot hallucinate" line in the marketing is doing more work than it should. The output shape cannot be wrong. The answer still can. It cannot do arithmetic, compare dates, write code, or reason in more than one hop, and TypeSafe says so themselves. Text only, no images.

So it is not a replacement for the language model. It is the thing you put in front of it. The LLM still writes the fix, the reply, the summary. Jev decides whether to, which one, and how sure it is.

For the routing case I already have an alternative: a small fine-tuned model on my own hardware that got 30 of 30 on the test set. When the data cannot leave, that stays the right choice. For everything else, a lot of my if statements are going to move.

## The bigger point

For a year the community built agents on the assumption that every decision costs a language model call. Whole architectures grew around minimising those calls: caching, batching, prompt compression, cheaper models for cheaper questions. A decision model makes most of that unnecessary. The decision becomes as cheap as a database lookup, and you stop designing around its cost.

That is the part I think people will look back on. Not the model. The moment "ask the LLM" and "ask a decision model" became two different calls.
