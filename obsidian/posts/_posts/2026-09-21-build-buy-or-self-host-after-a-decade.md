---
share: true
layout: post
title: "Build, buy, or self-host, after a decade"
subtitle: "The rule I use now, with the actual list of what I chose and why."
date: 2026-09-21
published: false
permalink: /build-buy-or-self-host-after-a-decade/
tags: [software, business]
excerpt: "Build versus buy is the wrong question. There are three options, and after ten years of paying for all of them I have a rule for which one to pick."
---

Every founder gets asked build or buy. It is the wrong question because there are three options, and the third one is where most of my infrastructure lives.

Buy means someone else runs it and you pay per use. Self-host means it is open source, you run it, and you pay in time. Build means it did not exist in the shape you needed. After ten years of picking wrong in every direction, here is the rule I use now, and the actual list.

## Buy what carries legal weight

Payments, tax, domains, cloud. Stripe takes money for anything on the web. Paddle takes it for the macOS apps, because Paddle is the merchant of record and handles VAT across countries. I could wire up tax registration myself. I would rather never think about it. Cloudflare holds DNS and object storage, Azure runs the VMs, GitHub holds the code, Tailscale is the network.

The pattern: if getting it wrong means a lawyer or a lost weekend of recovery, pay someone whose whole job is that.

## Self-host commodities, but pick the small one

Error tracking, analytics, uptime, metrics, CI. All of these have a hosted SaaS with a pricing page that grows with you and an open-source version that does 90 percent of the job.

I self-host all of them, and the rule inside the rule is: pick the small implementation. Self-hosted Sentry wants ClickHouse, Kafka, Redis, workers, and 14 GB of RAM. GlitchTip speaks the same SDK protocol on Postgres alone and runs on a 2-core box. Umami instead of Google Analytics. Uptime Kuma instead of a monitoring plan. A single-node Grafana stack with 14 days retention instead of a Datadog bill. GitHub Actions runners on my own 16-core VM instead of paying per minute for a hundred small repos.

Self-hosting is not free. Every one of these has a runbook, a backup job, and a version I have to bump. That cost is fixed and predictable. The SaaS cost is proportional to how much I ship, and I ship a lot.

## Build only when the thing does not exist

I do not build because I can. I build when the shape I need is not for sale.

A license service that decides entitlements no matter who took the payment, because Stripe and Paddle both want to be the source of truth and neither should be. A memory layer for coding agents, because the alternative was a markdown file. A headless browser, a screenshot tool, a desktop automation tool, all with a CLI surface, because agents cannot use the tools built for humans. CLIs for social networks, because an agent should not need a browser to post.

Everything I built has one thing in common: the customer was an agent, and nobody was selling to agents yet. When that stops being true I will happily buy.

## Where I got it wrong

[EDI: one or two real regrets here. A thing you built that you should have bought, or a SaaS you paid for too long before self-hosting. Two sentences each is enough.]

## The rule in one line

Buy what carries legal weight. Self-host commodities, and pick the small one. Build only when nobody sells the shape you need, and expect that to change.

The mistake I see most often is treating this as a one-time decision. It is not. A thing I built two years ago is now sold by three companies. A SaaS I paid for is now a Docker container. Revisit the list once a year and move things between columns without pride.
