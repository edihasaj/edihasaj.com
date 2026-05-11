---
share: false
layout: post
title: "Security in the age of AI coders"
date: 2026-05-11
published: true
filename: essay/_posts/2026-05-11-security-in-the-age-of-ai-coders
tags:
  - AI
  - security
  - agents
  - software
excerpt: "Exploits are cheaper than ever, patching is still manual, and most developers will never read the CVE about the package they shipped last week. The next layer of security has to be an agent that constantly listens, checks, and tells you before someone else finds it."
---

Security has been quietly broken for a long time. AI did not break it. AI just made the gap between attackers and defenders much more visible, and much more uncomfortable.

This is not only a developer problem. If you run a business, use a banking app, store files in the cloud, or rely on any software at all, you are sitting on top of the same gap. The people building the software are stretched, the libraries underneath are someone else's code, and the patches arrive long after the holes are already known.

I keep coming back to this when I look at the code I ship, the dependencies I pull in, the agents I let touch my repos, and the speed at which everything around it is moving. The honest answer is that most of us, including me, are not running the kind of security checks the current world deserves. We rely on a mix of "it builds", "the tests pass", "I trust the maintainer", and "I will patch later". Later usually never comes.

That worked, sort of, when finding a real exploit took a person, weeks of reading, and some luck. It does not work the same way now.

## Exploits got cheaper

A few years ago, finding a vulnerability in a serious codebase was a craft. You needed to read the source, understand the protocol, build a mental model of memory, sessions, parsing, auth, and then find the one place nobody thought about. That is still real work, but the floor has dropped.

Now you can hand a model a codebase, a compiled app, a recent change, or a CVE description (CVE is just the public ID for a known security bug), and it will tell you where similar patterns probably live. It will write the proof of concept. It will write the fuzzing harness, the small program that throws garbage at the code until something breaks. It will draft the exploit. Not always correct, not always exploitable, but very often "good enough to be dangerous".

> read code at scale  
> spot pattern reuse across files  
> generate payloads in seconds  
> rewrite the same exploit for ten variants  
> turn a CVE description into working code  
> chain small bugs into something useful  

That is the new baseline. It does not require a nation state, it requires an API key and patience.

The defensive side has the same tools, in theory. In practice, defenders are slower, because defense is harder than offense. You only need to find one bug. The defender needs to find all of them, in code they often did not write, against an attacker who keeps trying.

## Developers don't get told, or don't patch

The other half of the problem is human.

Most developers do not read security advisories. They do not run advisory dashboards. They do not check release notes of the libraries they use. They do not know which third-party piece of code, three layers down inside another library, just shipped a critical fix. They install it once, lock it, and move on.

If you are not a developer, picture it like this. Every app you use is a stack of building blocks. Most of those blocks were made by other people. When one block at the bottom turns out to have a hole, every app on top of it has the same hole until someone swaps the block. Most teams are slow to swap.

Some teams have automation. Dependabot opens PRs. GitHub flags advisories. Sometimes a security team forwards a Slack message. But the merge rate is the real metric. Lots of those PRs sit there. Lots of those advisories get closed without action. Lots of teams wait until something breaks in prod to look at it.

Then add the new layer:

> agents committing code  
> agents running migrations  
> agents installing packages  
> agents reading secrets  
> agents calling external APIs  
> agents creating PRs nobody fully reviews  

Every one of those is also a security surface. Not because the agent is malicious, but because the agent moves faster than your review pipeline. If a new dependency is added by an agent and merged by another agent, no human ever looked at the transitive tree. That is fine until it isn't.

## The patch gap is the real bug

When a serious bug becomes public, the world splits in two. There is a small group that patches within hours, and there is everyone else.

The everyone else group is not lazy. They are busy. They have a roadmap. They have features. They have customers. They have an oncall. They have a backlog. The patch goes on the list and the list is long.

Attackers do not wait for the list. The window between disclosure and exploitation in the wild keeps getting shorter. Public PoCs land within days. Mass scanners pick up signatures within hours. By the time a team gets around to upgrading, the weaponized version is already touring the internet.

This is the gap that AI on the defensive side has to close, because no human team is going to close it manually for every project they own.

## What better AI security should actually do

Most current "AI security" pitches are still the old security stack with a chatbot bolted on. That is not enough. The shape of the work is different now.

What I actually want is something like a constant listener.

> watch the repos I own  
> watch the dependencies they pull in  
> watch the advisories the moment they publish  
> watch the agents that touch the code  
> watch the diffs the agents create  
> watch the secrets that show up in logs  
> watch the configs that change in production  

And when something changes, tell me. Not "here is a 40 page report once a month". More like "this thing you shipped last Tuesday now has a public exploit, here is the upgrade, here is the diff, and by the way the staging deploy already pulls the patched version, want me to roll prod".

That is a very different product than a scanner that runs once a day and emails a PDF.

It needs to know:

> which projects are mine  
> which versions are deployed where  
> what the blast radius of an issue is  
> what fix is safe and what fix needs review  
> which agent or human last touched the affected code  
> what to do when nobody answers  

That last one matters. A lot of the security gap right now is that there is nobody on the other side of the alert. The alert fires into an empty channel. A good agent should keep nudging until something happens, and escalate if it doesn't.

## The new threat model is also AI

There is another piece nobody likes to talk about much. The threat model now includes other agents.

If your code or product is being read, indexed, or poked at by automated systems, those systems are going to find weak spots a human attacker would not have bothered with. Prompt injection is one of the new ones: hiding instructions inside a piece of text (a customer message, a webpage, a document) that the AI then reads and obeys, as if you typed them yourself. Other categories include leaking secrets through chat, tricking an agent into calling internal services, or abusing the tools you gave it. The reward is too good. Many systems are now reachable through "make the agent do X" instead of "make the server do X". That is a different category and most of our existing defenses do not cover it.

So security AI also has to think about agentic abuse:

> what tools is my agent exposing  
> what data goes into prompts  
> what comes back from the model  
> what side effects can a tool call cause  
> what would a hostile prompt try to do with my agent  
> what is the smallest reasonable scope for each tool  

If you do not design for this, the first time your agent gets prompt injected through a customer ticket or a scraped page, you will learn quickly.

## what i'm doing about it

I do not have a clean answer yet, and I am suspicious of anyone who says they do. But I am very sure of the direction.

The next layer of security tooling has to be:

> always on, not weekly  
> repo and runtime aware, not just static  
> fast at turning advisories into patches  
> aware that agents are part of the surface now  
> opinionated enough to act, not only report  
> open enough that you can trust what it does  

Some of this can be glued together from existing tools. Some of it does not exist yet. Some of it is going to look like a small agent that lives next to your repos and never sleeps.

I think 2026 is when this stops being a "nice to have" for serious teams. The cost of ignoring it is going up every week, because the attackers already upgraded their tooling. The defenders should too.

The boring summary, for builders and users alike: AI did not invent insecurity, but it removed every excuse we used to have for not paying attention. The patch is still our job. The work is just faster on both sides now, and the side that automates better is going to win the next few years.
