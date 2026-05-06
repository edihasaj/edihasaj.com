---
share: true
layout: post
title: "Recall: The Memory My Agents Were Missing"
date: 2026-05-06
published: true
filename: essay/_posts/2026-05-06-recall-the-memory-my-agents-were-missing
tags:
  - AI
  - agents
  - open-source
  - memory
  - recall
excerpt: "Every project has unwritten rules that don't fit in a .md file, and agents keep forgetting them. So I built Recall, opensourced it, and wired it into the agents I already use without paying for a separate brain."
---

# Recall: The Memory My Agents Were Missing

I open sourced [Recall](https://github.com/edihasaj/recall) a while back, and I want to write down why, becuase it is the kind of tool I wish someone else had built so I would not have to.

The short version is, every project has unwritten rules. The long version is, those rules keep biting me when an agent ignores them for the fifth time in the same week.

## The Rules That Never Make It Into a .md

You can write a `CLAUDE.md`, `AGENTS.md`, or `README` and put the obvious things in there. Tech stack, commands, conventions, deployment notes. Fine. That covers maybe 20% of how a project actually works.

The other 80% lives in your head:

> never run migrations without a backup first  
> in this repo we always update the changelog before merging  
> in that other repo we never touch the auth middleware without pinging someone  
> when you commit, also run the docs gate, every single time  
> after a refactor, regenerate the types, do not skip it  
> this codebase uses pnpm, the other one uses npm, do not mix them up  

You cannot put all of that into a markdown file. Or you can, but nobody, including the agent, will read 4000 lines of "and also remember this." It becomes noise. Most of it is conditional, situational, or only matters after you have made the mistake once.

So you end up repeating yourself. "Don't do X." "Yes, run the tests first." "I told you to use trash, not rm." Every conversation, every new session, same corrections. The agent is smart but it has no memory of the last time you yelled at it.

That is the gap Recall fills.

## What It Actually Does

Recall is a local memory layer for coding agents. Repo-scoped, file-based, owned by you. Nothing leaves your machine unless you wire a provider.

It learns from corrections, from review feedback, from session outcomes, from explicit "remember this" calls. It compiles those into a small set of trusted instructions per repo. Then it injects them into the agent at the right moment, so the agent shows up to the next session already knowing the rules.

![Recall injecting repo rules into the agent at session start](/images/posts/recall-2026-05-06.png)

The flow is roughly:

> you correct the agent once  
> Recall captures that as a memory  
> next session in the same repo, the rule is already in context  
> if you contradict it later, Recall updates or retires it  

It also runs a small daily maintenance pass that merges duplicates, retires stale entries, and tightens fuzzy ones. Memories that are wrong now do not stay forever.

## Connects Without an Extra Bill

This part matters to me. I did not want yet another subscription with its own context window, its own tokens, its own dashboard.

Recall connects to the agents I already use, two ways:

**Hooks.** On `SessionStart` it injects a minimal block of relevant memories into the agent's own context. On `UserPromptSubmit` it does a per-prompt relevence check and adds anything that fits. The agent uses its own tokens to read it. There is no second model running, no proxy, no extra cost.

**MCP.** When the hook block missed something, the agent can call `recall.query`, `recall.list`, `recall.report_correction`, and friends as regular tools. Same model, same tokens, just a few more tool calls.

So the cost is whatever you were already paying your agent provider. Recall itself is local, free, and does not phone home.

## Why Opensource

Because this is exactly the kind of thing that should not be closed.

Memory for agents is going to be a default feature, not a moat. Everyone building serious agentic workflows is going to need something like this, and a closed SaaS version of it is a bad idea: your corrections, your repo conventions, your unwritten rules are some of the most sensitive things about how you work. You do not want them on someone else's server, indexed for "improvement."

Local first, file based, inspectable, forkable. If you do not like how it ranks memories, change it. If you want a different injection style, override it with an env var. If you want to plug it into a different agent runtime, the hooks and MCP are documented.

This also fits what I was [writing about last week](/2026/05/04/2026-is-going-to-be-the-year-of-open-source.html). The code alone is not the moat. The moat is the context, the workflow, the trust. Open sourcing the memory layer is not giving anything important away. It is making the layer better for everyone, including me.

## What I Want From It

Honestly, I want to stop repeating myself.

I want every repo I touch to remember the unwritten rules. I want new agents I try to inherit those rules without me having to brief them again. I want the corrections I make today to be in context tomorrow. I want to stop writing "do not run X without Y" for the hundreth time.

Recall is not done. It is the kind of project I will keep rethinking because the problem keeps changing. Agents get better, hooks get better, MCP gets better, and the way memories should be retrieved and ranked will keep moving with that.

But the core idea I am sure about. Every project has rules that do not fit in a markdown file. Agents need a place to keep them. That place should be local, opensource, and ride on top of the tools you already pay for.

That is Recall.
