---
share: true
layout: post
title: "Playing with one-pass decision models"
subtitle: "What I was trying with Surebranch, and where the experiment stopped."
date: 2026-10-09 09:00:00 +0200
published: true
permalink: /playing-with-one-pass-decision-models/
tags: [AI, software]
excerpt: "After writing about Jev, I tried making models choose from a fixed set of answers without generating text. Surebranch was that experiment. The weights are available, along with the parts that did not work well enough."
---

After [writing about Jev](/jev-is-a-smart-if-statement/), I started playing with the same question: what happens if a model only needs to choose an answer?

A lot of the calls in my agent workflows have that shape. Which team should handle this request? Does this change need a closer review? The answer is a choice from a small menu. I wanted to try something different from asking a language model to write JSON and then parsing it.

That experiment became Surebranch. The [4B weights are on Hugging Face](https://huggingface.co/edihasaj/surebranch-4b).

## Starting small

The first version used a frozen sentence encoder and a small trained scorer. The idea was to encode the context once, then score the possible answers against it. I compared that with similarity scoring and existing classifiers.

It worked well on the banking categories the scorer had seen during training. Categories it had never seen were a different story. With all 77 banking labels competing, the trained scorer got only 27.6% of the unseen-category cases right. The simple similarity baseline got 58.2%.

That was an early lesson: teaching the model a set of familiar choices did not make it good at arbitrary new choices.

## Trying a different base

Later I adapted [Decider 4B](https://huggingface.co/Mapika/decider-4b), a Qwen3.5-based model that scores typed answer options in one forward pass. This is the basis of the published Surebranch checkpoint. It is not an encoder-only model, even though the earlier experiment was built around an encoder.

I tried teaching it code decisions. Given a Python program and its tests, does a particular assertion pass? Does the whole suite pass? How many tests pass?

For the training labels, the programs were actually executed. At inference, the model only reads the code and scores the choices. It does not run the program. I mixed general decisions into training to try to improve the code answers without losing the base model's broader abilities.

## What came back

The published weights were checked on 250 Python programs, each executed twice to verify the labels. Asking the questions separately gave these development results:

| Question | Accuracy |
| --- | ---: |
| How many tests pass? | 46.8% |
| Does the whole suite pass? | 76.8% |
| Does one selected assertion pass? | 84.4% |

Those cases were used during model selection. They are not an independent final test.

Asking all twelve questions together gave 82% accuracy across 2,500 individual assertions. But it detected only 203 of the 555 failing assertions. The overall accuracy looked much better than its ability to catch failures, which is the part I would care about in a review tool.

Question order could also change the answers. Returning a valid probability for every option does not mean those probabilities are reliable enough to act on.

## Where I left it

I ended the experiment on 2 October. No candidate passed fresh production qualification, and I did not establish that this checkpoint matches Jev or meets a particular serving price.

The [model card](https://huggingface.co/edihasaj/surebranch-4b) has the loading example, measured results and limitations. The weights are there for people who want to play with the approach. The training code and datasets remain private.

What I wanted to explore was a different way to use a model: read the context, score the available answers, and stop there. Surebranch gave me something concrete to try, including a few results that looked good until I asked a more useful question about them.
