---
share: true
layout: post
title: "Teaching a 9B model to route support requests"
subtitle: "A small Farka demo, with the before-and-after result and the evidence behind it."
date: 2026-09-13
published: true
permalink: /farka-qwen-support-routing/
tags: [AI, software]
excerpt: "A Qwen3.5 9B support-routing demo improved from 23 to 30 correct routes on the same 30 generated test messages. Here is the workflow, the evidence and what that result can tell us."
---

I’m building [Farka](https://farka.ai) to make it easier to teach a model a specific job: give it examples, train it, compare what changed, and export the result.

One small demo starts with a familiar problem. A support request arrives. Which team should handle it?

## Give the model a clear job

The task had three destinations: **billing, account help and technical support**. The model chose a team. It did not answer the customer, issue a refund or change an account.

We fine-tuned [Qwen3.5 9B](https://huggingface.co/Qwen/Qwen3.5-9B) using 270 generated training examples. The run completed on 21 August 2026. This post revisits that existing result; it isn’t announcing a new training run.

## Compare what changed

The saved evaluation contains before-and-after predictions for the same 30 test messages.

| Model | Requests routed correctly |
| --- | ---: |
| Before training | 23 / 30 |
| After training | 30 / 30 |

![Qwen3.5 9B routed 23 of 30 generated support messages correctly before training and 30 of 30 after training. No CPU comparison was run in this experiment.](/images/posts/farka-qwen-support-routing.png)

That is seven additional correct routes in this test. Both versions returned a valid team name for all 30 messages, so the change here is in choosing the recorded destination.

I checked those counts against the saved predictions. I did not rerun inference for this article.

## How to read this result

This is a **small synthetic workflow demonstration**, not a customer benchmark. Thirty generated messages cannot establish production accuracy or a saving on a customer’s bill.

The evaluation rows also participated in checkpoint evaluation. There was no separate blind test, and I have not independently re-audited overlap between the training and evaluation message patterns. The full training protocol matters when interpreting a result this small.

There was also no comparison with a simple classifier in this run. Improving a language model does not establish that it is the best tool for the task. Rules, a classifier or better prompting may be enough.

## Where Farka fits

The part I want Farka to make easier is that comparison loop. Start with a task you can describe and examples you have permission to use. Keep a meaningful test separate. See whether training helps before deciding to use the model.

For a real workflow, I would want a larger, independently held-out test, realistic mistakes and a simpler baseline before making a quality or cost claim.

You can explore the platform at [farka.ai](https://farka.ai).
