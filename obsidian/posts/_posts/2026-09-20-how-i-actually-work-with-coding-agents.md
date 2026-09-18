---
share: true
layout: post
title: "How I actually work with coding agents"
subtitle: "Not a prompt trick. A repo, a grid of panes, a pipeline, and a lot of rules."
date: 2026-09-20
published: false
permalink: /how-i-actually-work-with-coding-agents/
tags: [AI, software]
excerpt: "A year of running Claude Code and Codex across a hundred repos. What stuck: shared rules in one repo, tools built for agents instead of humans, a queue, and gates that do not trust the agent."
---

I have been running coding agents as my main way of writing software for about a year now, across more than a hundred repos. Not as an autocomplete. As the thing that does the work while I decide what the work is.

Most of what people write about this is prompt advice. Prompts matter less than the setup around them. This is my setup.

## One repo of rules that every agent reads

There is a public repo called `agent`. It holds the operating rules, the skills, the slash commands, and the machine setup script. Claude Code, Codex, and whatever else I try all get symlinked into it. The rules file starts with how to talk to me (short, no filler) and then goes through the boring stuff: where repos live, how to commit, what never to delete, how to find a machine, what to do when CI is red.

The important line is near the top: never keep a second copy of a skill anywhere. A duplicate drifts and then breaks silently. I learned that by having three slightly different versions of the same command in three runtimes.

A private repo next to it holds runbooks for every machine and every deployed product, each with a note saying when an agent should read it. So "deploy Farka" means the agent reads the Farka deployment doc first, not that it guesses.

## Tools built for agents, not for me

The default tools an agent gets are built for a person sitting at a keyboard. Screenshots are pixels. Browsers are GUIs. Desktop apps have no API. Each of those costs an agent a lot of tokens or is simply impossible.

So I built the missing ones. A headless browser with a CLI surface. A screenshot tool that returns accessibility text first and only spends pixels when asked. A way to click and type in native Mac apps. A CLI to run a command on any target, from a Docker container to a Windows VM, and get the evidence back. Small CLIs for X, LinkedIn, Reddit, GitHub, so an agent can post or read without a browser.

None of these are products I set out to build. Each one exists because an agent got stuck on something a human would have done in two seconds.

## A grid of panes and a queue

The day-to-day view is a tmux grid, 32 panes, each one an agent in a repo. A dashboard shows every repo's branch and whether it is dirty. A file-based queue holds tasks, and a loop in any pane drains it. One queue feeds many projects, so I can drop ten tasks across five repos and let whatever is free pick them up.

After a reboot, a script finds the recent sessions and resumes each one in its pane with the same model and permission mode it had. That sounds minor. It is the difference between losing an afternoon and losing nothing.

## The pipeline does not trust the agent

Point it at a repo and a task, and the pipeline runs the same way every time: resolve the task from Jira or GitHub or plain text, plan, branch in the repo's convention, implement, run lint and typecheck and tests, run a security review, run a second code review pass, write the PR body, and then stop. For client repos it stops PR-ready and I push. For my own it opens the PR.

The gates are not optional and the agent cannot skip them. That is the whole design. I do not review most of the code. I review the gates, and I read the PR description as if a colleague wrote it.

## Memory that is quality-gated

Agents forget. The first fix was a markdown file of rules that grew until nobody, human or machine, read it. The second fix was Recall: a hook captures corrections I make in conversation, gates them for quality, stores them locally, and injects the relevant ones at the start of a session. When I say "never use em dashes" once, every agent on every machine knows it the next day.

The gate matters more than the storage. Memory without a filter is a bigger rules file.

## Verify end to end or say what is missing

The rule I repeat most: prefer an end-to-end check, and if you cannot do one, say exactly what is blocking. An agent that runs the tests and reports green is fine. An agent that starts the app, drives the browser, screenshots the result, and attaches the evidence to the PR is what I want. An agent that says "should work" is the one I have to stop.

Most of the tooling above exists to make the second kind of agent possible.

## What I would tell someone starting

Put the rules in one place and version them. Build or find tools that have a CLI and return text. Never let the agent be the one who decides whether the gate passed. Keep the memory small and filtered. Spend on the harness, not on the prompt.

And keep the human in the loop where money, customers, or deletion are involved. Everywhere else, get out of the way.
