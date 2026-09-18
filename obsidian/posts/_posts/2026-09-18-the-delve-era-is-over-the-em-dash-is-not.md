---
share: true
layout: post
title: "The delve era is over. The em dash is not."
subtitle: "96 answers from four current models, measured against 72,000 words of human engineering prose."
date: 2026-09-18
published: true
permalink: /the-delve-era-is-over-the-em-dash-is-not/
tags: [AI, writing]
excerpt: "I asked Claude and Codex models to write 96 short texts and counted words and punctuation against pre-ChatGPT commit messages. The famous LLM words are gone. The habits that replaced them are shared by both labs."
---

There is a claim I keep hearing and kept believing: models write in a register real people rarely use, and they do so because more and more of what they learn from was written by other models. I wanted a number instead of a feeling, so I ran a small test.

## Setup

Four models: Claude Sonnet, Claude Opus, and Codex with gpt-5.6-sol and gpt-5.6-terra. Each got the same 24 prompts, all asking for about 150 words. Twelve are everyday writing: a message cancelling dinner, an email to a landlord, a product description. Twelve are engineering writing: a pull request description, an incident update, a code review comment. Default settings, run through the `claude` and `codex` command lines from an empty directory.

For a human baseline I took commit message bodies from Apache James, tmux and DAVx5 written before June 2022, so before ChatGPT existed. After stripping trailers, URLs and code, that is about 72,000 words of engineers explaining things to other engineers. Everyday word frequencies come from the wordfreq English list.

## The words are gone

I counted the 2023 vocabulary everyone learned to spot. Across all 96 answers, 14,800 words in total:

| Word | Model answers | Human commits |
| --- | ---: | ---: |
| delve | 0 | 0 |
| tapestry | 0 | 0 |
| robust | 1 | 3 |
| leverage | 0 | 9 |
| nuanced | 0 | 0 |

That list has been trained out. The models did not move to rarer words either. On the engineering prompts every model used more common vocabulary than the human engineers did.

| Corpus | Share of rare content words |
| --- | ---: |
| Human commit bodies | 24.5% |
| Claude Opus | 20.2% |
| Claude Sonnet | 15.2% |
| Codex gpt-5.6-sol | 12.3% |
| Codex gpt-5.6-terra | 13.1% |

Rare here means a word that appears fewer than about three times per million words of English. Part of the human number is project jargon, so treat the gap as direction, not size. But the direction is the opposite of what I expected.

## The tell moved to punctuation and scaffolding

What separates the model answers from the human ones is not which words they pick. It is how they lay the text out.

| Model | Answers with an em dash | Bullet list | Bold text | Ends with an offer |
| --- | ---: | ---: | ---: | ---: |
| Claude Opus | 71% | 29% | 54% | 12% |
| Claude Sonnet | 75% | 46% | 62% | 25% |
| Codex gpt-5.6-sol | 58% | 8% | 4% | 0% |
| Codex gpt-5.6-terra | 71% | 4% | 0% | 4% |

The 72,000 words of human commit bodies contain zero em dashes. Commit messages are typed in a terminal, so that comparison is unfair to the models, but the gap is not small. The models put an em dash in roughly every hundred words.

A few phrases follow the same pattern, shown as occurrences per thousand words:

| Phrase | Model answers | Human commits |
| --- | ---: | ---: |
| "Here's" | 1.08 | 0.00 |
| "let me know" | 0.88 | 0.03 |
| "otherwise" | 0.07 | 0.49 |

Eleven answers open with "Here's". Human engineers never did. Humans wrote "otherwise" 35 times, a word you use when you are reasoning about a branch. The models used it once.

## Two labs, one accent

The em dash shows up in every model from both labs. Claude adds bold and bullet lists and likes to close with an offer to revise. Codex adds headings instead. Nobody at either company decided to write like this. The register is emergent, and it is shared.

That is the part that supports the original claim, just not at the level I expected. Word lists are easy to fix. People mocked "delve" and it disappeared. Punctuation and layout were never on anyone's list, and if the text models learn from is increasingly model-written and model-rated, those habits reinforce themselves quietly. I cannot prove that from outside the labs. The convergence fits it.

## Limits

Ninety-six short answers is a small sample. Prompts pick the topics, so the raw over-used word lists are mostly topic words like "retry" and "cache". Both command lines know my name from their own memory, which shows up in a few greetings. One Opus run, before I moved to an empty directory, read the folder it was in, found my scripts, and declined to write the README I asked for because it would have been inaccurate. Fair enough. I reran it.

The prompts, raw answers and scripts are in the [experiments folder](https://github.com/edihasaj/edihasaj.com/tree/main/experiments/llm-vocab) of this site's repository.

This post contains no em dashes. It took editing.
