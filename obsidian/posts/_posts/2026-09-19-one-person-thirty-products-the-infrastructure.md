---
share: true
layout: post
title: "One person, thirty products: the infrastructure"
subtitle: "What actually runs underneath when you ship a lot of small things alone."
date: 2026-09-19
published: false
permalink: /one-person-thirty-products-the-infrastructure/
tags: [software, infrastructure]
excerpt: "I run around thirty deployed products and tools by myself. Here is the boring infrastructure that makes that possible, and the rules I ended up with."
---

People see the projects list and assume there is a team somewhere. There is not. There is one shared VM, a handful of dedicated ones, a CI box, a NAS at home, and a private repo full of runbooks that both I and my agents read. That is the whole company.

This is what it looks like and why it ended up this way.

## One big shared box, not thirty small ones

Most products live on a single Azure VM: 8 cores, 32 GB, a data disk, nginx in front, Let's Encrypt for TLS. Node apps run under PM2, Python apps under systemd, a few things under Docker Compose. Landing pages, APIs, dashboards, internal tools, all on the same host.

That sounds wrong to anyone who learned infrastructure from conference talks. It is the cheapest and calmest setup I have ever run. One machine to patch, one backup job, one place to look when something is slow. A product that gets no traffic costs nothing extra to keep alive, which matters when you ship a lot of things and only some of them take off.

Products get their own VM when they have a reason: a database that needs its own disk, a customer contract, a different trust boundary. Kubernetes only where it earns it. Two customer platforms run on managed clusters, a couple of others on single-node K3s. Everything else does not need a scheduler, so it does not have one.

## Private network first

Every machine is on Tailscale: the VMs, the Mac Studio that does builds, the NAS, a Raspberry Pi that coordinates backups. Public ports are 80 and 443 and nothing else. SSH is allowed from my workstation address and the CI runner, not from the internet. Internal tools are served on the tailnet only and never get a public DNS record.

This one decision removed a whole category of worry. I do not think about who can reach the admin panel because nobody outside the tailnet can.

## CI on my own machine

Every private repo builds on one self-hosted runner VM with 16 cores. GitHub-hosted runners are only for public repos, where forks need the isolation. Around ninety runner listeners sit on that box, a pair per repo, more for the products that need platform-specific builds. Mac builds go to the Mac Studio.

Self-hosting CI is not for everyone. For a lot of small repos with occasional builds it is the difference between a fixed monthly cost and a bill that grows with how productive you are.

## Errors, metrics, analytics: self-hosted, but not Sentry

I wanted error tracking, so I looked at self-hosting Sentry. It wants ClickHouse, Kafka, Postgres, Redis, workers, and a machine with 14 GB of RAM just to start. For what is basically exception grouping across small apps, that is absurd. GlitchTip speaks the Sentry SDK protocol and runs on Postgres alone, on a 2-core VM.

Same idea for the rest. One small Grafana stack with Loki, Tempo, and Prometheus, 14 days of retention, one node, no object storage until measured traffic says I need it. Umami for anonymous product analytics instead of Google Analytics. Uptime Kuma for probes. Each one is a single small VM or a container on the shared box, and each one is deliberately a single failure domain. Telemetry is evidence, not the system of record. If it goes down for an hour, nothing I sell goes down with it.

## Backups in three places

Databases get dumped nightly to local disk, pushed to Cloudflare R2, and pulled by Restic over Tailscale onto the NAS at home. Local for fast restore, cloud for the VM dying, home for the cloud account dying. Restic gives encryption, dedup, and retention for free, and it works over plain SFTP, so the NAS needs nothing installed.

I also back up my agent conversations. Every Codex and Claude session from both Macs gets pulled by the Pi, encrypted, and shipped to R2. That history turned out to be one of the most useful things I own.

## Payments and licensing are two systems

Stripe takes the money for anything with a web checkout. Paddle takes it for the macOS apps, because Paddle is the merchant of record and carries VAT registration across countries, which I have no interest in doing myself. Neither of them decides what a customer is allowed to use. A small internal license service does that: issue, validate, revoke, offline signed licenses, real limits like seats and expiry.

Every product that invented its own entitlement store became a second source of truth that drifted. So now there is one.

## The runbooks are the real infrastructure

All of the above is written down in one private repo. Every machine has a runbook. Every deployed product has a pointer to where it runs and how to deploy it. Each doc has a short front matter block saying when to read it, so an agent can find the right file before touching anything.

That is the part that scales. I cannot remember thirty deploy procedures. I do not need to. I open a coding agent in the repo, say "deploy X", and it reads the same doc I would have read. The infrastructure is small enough for one person because the documentation is good enough for a machine.

## The rules I ended up with

Share the box until a product earns its own. Keep everything on a private network and expose two ports. Self-host commodities, but pick the small version. Buy anything that carries legal weight. Write the runbook before you need it, and write it for an agent.

None of it is clever. That is the point.
