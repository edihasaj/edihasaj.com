---
writing_section: essays
share: true
layout: post
title: "My AI playbook"
subtitle: "How I actually use agents every day. Rules, tools, and who checks the work."
date: 2026-09-20
published: false
permalink: /my-ai-playbook/
tags: [AI, software]
excerpt: "No prompt tricks. One file of rules, a few tools built for agents, a pipeline that ships, and two systems that check the work before I do."
---

People ask me how I use AI. They expect a prompt. It is not a prompt, it is a setup. Here it is, the short version.

## One file of rules

Every agent I run reads the same file first. Claude Code, Codex, whatever comes next. The file is public, it is called AGENTS.md, and it lives in one repo with the skills and the commands. Everything else links to it. I learned the hard way that if you keep two copies of a rule, one of them drifts and then breaks quietly.

The file is boring on purpose. Talk short. Use the repo's package manager, dont swap it. Commit with the helper that only stages the files you name. Never delete, move to trash. Read the docs before you touch code. If CI is red, fix it until it is green. Verify end to end, and if you cant, say exactly what is missing.

That last one is the most important rule I have. An agent that says "should work" is the one that costs me the afternoon.

## Tools built for agents

Most tools are built for a person with a mouse. Agents dont have a mouse. So a lot of what I built the last year is just giving them hands.

guiport lets an agent see and click a real desktop app. It reads the accesibility tree, finds the button, clicks it, types, and can save that flow as a test. Playwright but for Mac apps, basically.

abx is a browser with a command line. Open a page, read it, click, fill a form, no screenshots needed most of the time.

shotport is for when pixels are actually needed. It grabs the text first, and only spends tokens on the image if you ask. Screenshots are expensive for an agent and most of the time the text is enough.

vmlab is one command to run something on any machine. Docker box, Linux VM, Windows VM, a phone, a simulator. It spins the machine up, runs the thing, collects the evidence, and shuts it down so nothing keeps billing.

None of these started as products. Each one exists because an agent got stuck on something I would do in two seconds.

## The pipeline that ships

When I want a change, I dont open a chat. I point shipyard at a repo and a task. A Jira key, a GitHub issue, or just a sentence.

It plans, makes a branch in the repos convention, does the work, runs lint and types and tests, runs a security review, then a second code review, writes the PR description, and stops. For client work it stops PR ready and I push. For my own stuff it opens the PR.

The agent cannot skip a gate. That is the whole design. I dont read most of the code anymore. I read the gates and I read the PR text like a colleague wrote it.

Sometimes I run many of these at once. A tmux grid with 32 panes, a queue of tasks, and each pane picks the next one. After a reboot a script finds the sessions and puts them back. It sounds like a lot, it is actually calmer than one chat window.

## Who checks the work

This is the part people skip. The agent finishing is not the same as the thing working.

Two systems check. Probeport takes a change and tries to prove it. It reads the diff, runs the native gates, then actually uses the feature through the closest real surface: the browser with abx, the desktop with guiport, another OS with vmlab. Small models do the poking, a bigger model argues with their evidence and decides if the exact revision works. The verdict comes back with screenshots and logs attached, not with "looks fine".

Autoreview watches the other direction. It reads feedback, bug boards and GitHub issues, maps each one to a repo, and writes a dry run report of what it would do. Nothing happens until I enable a project and say execute. Then it can hand the work to shipyard, and the loop closes: feedback in, verified PR out.

## Memory

Agents forget. The first fix was a markdown file of rules, which grew until nobody read it, me included. The fix now is Recall. When I correct an agent in a conversation, a hook catches it, checks if it is a real rule or a one off, and stores it. Next session, on any machine, the relevant ones get injected. I said "no em dashes" once. Every agent knows it now.

## What I would tell you

Put the rules in one place. Give the agent tools that return text. Never let the agent decide if the gate passed. Have something else check the work before you do. Keep memory small and filtered.

And keep yourself in the loop where money, customers, or deleting things are involved. Everywhere else, get out of the way. The agents are better at the work than at knowing when it is done, so build for the second part.
