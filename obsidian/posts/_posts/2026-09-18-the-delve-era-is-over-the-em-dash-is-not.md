---
share: true
layout: post
title: "The delve era is over. The em dash is not."
subtitle: "Models stopped using the words we mocked. They kept the habits nobody named."
date: 2026-09-18
published: true
permalink: /the-delve-era-is-over-the-em-dash-is-not/
tags: [AI, writing]
excerpt: "The big models are trained more and more on text that models wrote. I think that is why they all sound the same, and why the tell moved from vocabulary to punctuation. A small test with Claude and Codex."
---

Here is my idea. The newest models are trained on more and more text that other models wrote. Synthetic data, model-graded answers, model-written examples. When a model learns from a model, whatever quirks the teacher had get passed on and amplified. Nobody chose them. They just survive.

If that is true, two things should follow. The models from different labs should sound alike. And the quirks should be the ones nobody put on a list, because the ones on a list get trained away.

I tested it in an afternoon. Four models, Claude Sonnet, Claude Opus, and two Codex models, each answered the same 24 short writing tasks: cancel a dinner, email a landlord, describe a lamp, write a pull request, post an incident update. As a human comparison I used 72,000 words of commit messages written by engineers before ChatGPT existed.

## The words we mocked are gone

Across all 96 answers there is not a single "delve", "tapestry", "leverage" or "nuanced". The models also did not swap them for other fancy words. Their vocabulary is plainer than the human engineers'. If you are still looking for AI text by its word list, you are looking in the wrong place.

## The habits stayed, and every model has the same ones

| | Claude Opus | Claude Sonnet | Codex sol | Codex terra | Humans |
| --- | ---: | ---: | ---: | ---: | ---: |
| Answers with an em dash | 71% | 75% | 58% | 71% | 0 in 72k words |
| Opens with "Here's" | 1 in 4 | 1 in 4 | never | never | never |
| Ends with an offer to revise | sometimes | sometimes | rarely | rarely | never |

Two labs, one accent. The em dash is in most answers from every model. The humans, in 72,000 words of explaining things to each other, used it zero times. "Otherwise", a word you use when you are actually reasoning about a case, shows up 35 times in the human text and once in the model text.

## What I think this means

"Delve" was a public joke, so it was fixed. The em dash and the "Here's" were never a joke, so nothing pushed back, and each generation of models learned them from the last one a little more firmly. That is what training on your own output looks like from the outside: not exotic words, but a shared style that no human writes in and no one decided on.

I cannot see inside the labs, so this is a reading, not a proof. But the convergence is real and you can check it yourself. Prompts, answers and scripts are in the [experiments folder](https://github.com/edihasaj/edihasaj.com/tree/main/experiments/llm-vocab) of this site.

This post contains no em dashes. It took editing.
