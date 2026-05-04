---
share: true
layout: post
title: "2026 is going to be the year of open source"
date: 2026-05-04
published: true
filename: essay/_posts/2026-05-04-2026-is-going-to-be-the-year-of-open-source
tags:
  - AI
  - open-source
  - software
  - agents
excerpt: "Software is getting cheaper to build, agents are getting better, and the things that are easy to create will be harder and harder to sell as closed source."
image: /images/pages/edi-og.png
---

# 2026 is going to be the year of open source

2026 is going to be the year of open source, at least for software builders. Not because everyone suddenly became more kind, but because the market is changing fast and a lot of the easy software is not worth hiding anymore.

Coding is becoming a commodity. I don't mean good engineering is a commodity, that is still hard and you can see it every time some generated app looks fine but breaks as soon as you try to use it for something real. But a lot of software that people were selling before is now much easier to create. A small app, an internal tool, an admin dashboard, a simple RAG system, a browser extension, a wrapper around an API, some automation between two systems, a small agent that does one thing good enough.

Most of those things can be built with one good prompt if it is simple enough, or maybe with one week of agentic engineering if it has some moving pieces. That changes everything.

## easy software is getting hard to sell

for the last years a lot of software was sold just because it was annoying to build. You had to setup auth, billing, database, email, deployment, some UI, docs, maybe permissions, maybe a few integrations, and suddenly even a simple app became a project. Now you can describe most of that to an agent and it will get you very far. Not perfect, but far enough.

And that is the important part. The market does not need perfect for every category. It needs useful, cheap, fast, and good enough to solve the problem. So if your whole product is basically "LLM + prompt + UI", good luck keeping that closed and pretending it is some big moat. Someone will recreate it. Maybe worse, maybe better, but close enough for many users.

This is why small apps can be done within a day or two nowadays, and bigger things that used to take months can be pushed in weeks if you know what you are doing. It is still very easy to create slop. Actually it is easier than ever. But that also means the value is moving away from just writing code.

## the value is not only the code anymore

The code is becoming cheaper. The context is not.

Knowing what to build is not cheap. Knowing the domain is not cheap. Knowing why a workflow is broken is not cheap. Knowing how users actually talk, what they expect, what data matters, what should be automated and what should stay manual, that is still the real work.

I see this all the time. When I built a small RAG system over Kosovo's laws, the important part was not only embeddings and citations. Everyone can make a demo with that now. The important part was that people ask in everyday language, in Albanian, Gheg, English, no diacritics, slang, abbreviations, and they still expect the right article back. That is the product.

Same with AI over business data. "Chat with your database" is not enough anymore, everyone can do that badly. The hard part is schema-aware prompts, glossary builder, business vocabulary, permissions, joins, aggregations, and making the AI understand the way the company actually thinks about its own data. That is where the value is. The code helps, but the code alone is not the moat.

## open source makes more sense now

If the code alone is not the moat, why keep everything closed? This is where I am shifting more and more. I want to open source more things, especially the tools, agents, libraries, scripts, workflows, and small platforms where more people can benefit from seeing how it works.

Not everything should be open source. Customer data should not. Some business logic should not. Security sensitive things should not. Some enterprise features or hosted operations can stay closed. There are still businesses that should sell closed software, no doubt about that.

But a lot of things we build are not in that category. They are useful because they show a pattern. They help someone move faster. They give someone a starting point. They connect two things that were annoying to connect. They make agents work better with real systems.

For those things, open source is probably the better default. People can inspect it, run it, fork it, fix it, and learn from it. It also forces the work to be more honest, because if the code is bad people will see it. In a world full of generated demos, that matters a lot.

## open models are putting pressure everywhere

Open source models for coding are already making it harder for Anthropic, OpenAI and everyone else to keep coding as a huge profit center. Closed models are still very good. I still use them. Infrastructure matters. Reliability matters. Tool calls matter. Speed matters. Trust matters.

This is where people get too excited with benchmarks sometimes. Yes, a model can be cheap and score well, but have you actually used it for everyday complex work? If the API is unstable, slow, looping, bad with tools, or hosted somewhere you don't trust with sensitive data, then the benchmark does not help much.

But the direction is clear. Open-weight models are getting better. Local and hosted options are getting better. Agent scaffolds are getting better. The gap is not what it was before. This means more builders will try open models first for the everyday work, and only use the expensive closed frontier models where they actually need them. That is healthy. It pushes everyone to get better.

## agents change the shape of apps

I also think people still underestimate how much agents will change apps. You don't need a new OS anymore, you need a good agent.

The whole idea is to create apps and platforms that require no or minimal UI to do the things they do. Before you bloat 100 other pages, think one more time if that action should just be available to an agent. Your app is going to need AI integration eventually. Not a chatbot pasted on top.

Real access. Check billing, update users, pull reports, create invoices, search documents, route expenses, talk to your ERP, ask legal questions, whatever the system actually does. That is why I think the apps that survive are the ones that bridge this agentic way of communicating.

And a lot of that bridge should be open, because we all need better patterns for how agents talk to systems. MCPs are token hungry and not perfect, but they are a solid foundation for the future of communication between agents and systems. Same thing with open agents, memory systems, tool protocols, testing loops, browser control, CLI workflows. These things should be shared more.

## what you can still sell

Some people hear open source and think it means no business. That is not true.

You can still sell hosting. You can sell support. You can sell setup. You can sell enterprise controls. You can sell integrations. You can sell better reliability. You can sell managed infrastructure. You can sell the boring operational stuff that nobody wants to run themselves. You can sell the part where it actually works.

That is very different from selling a small hidden codebase and hoping nobody can rebuild it. In 2026, if something can be recreated by a one shot prompt or a short agentic coding session, maybe the code should not be the thing you protect. Maybe the code is the thing you give away, and the value is everything around it.

## this is the shift

everything is different now. Small apps are cheaper to build. Agents are improving fast. Open models are getting good enough for more real work. Users do not want 100 apps and 100 subscriptions for every small thing. Companies will need bridges between their systems and agents. Developers will want to inspect and trust what they run.

So for me, 2026 is the year to shift more towards open source. Not as charity, and not as some ideology. Just because it makes sense.

If the project is useful as a pattern, open it. If people can benefit from it, open it. If the real value is context, reliability, hosting, data, or domain knowledge, then open source will probably make the project stronger, not weaker.

The code is no longer always the thing to protect. Sometimes it is the thing that gets people to trust you.
