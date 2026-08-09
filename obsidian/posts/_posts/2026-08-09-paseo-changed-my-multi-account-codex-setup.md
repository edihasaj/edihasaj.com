---
share: true
layout: post
title: "Paseo Changed Everything About My Multi-Account Codex Setup"
date: 2026-08-09
published: true
filename: essay/_posts/2026-08-09-paseo-changed-my-multi-account-codex-setup
tags:
  - AI
  - agents
  - Codex
  - macOS
  - tooling
  - open-source
excerpt: "I built a macOS account switcher to keep two Codex profiles alive. Paseo moved the solution down a layer: persistent daemons, named account profiles, remote control, and agent orchestration across my MacBook and Mac Studio."
faq:
  - question: "Can Paseo run multiple Codex accounts?"
    answer: "Yes. Paseo custom provider profiles can extend the native Codex provider and set a different CODEX_HOME for each account. Authentication and session state stay isolated."
  - question: "Does Paseo replace the Codex CLI?"
    answer: "No. Paseo launches and supervises the Codex CLI already installed and authenticated on your machine. Your Codex configuration, skills, tools, and subscription remain in place."
  - question: "Do agents keep running after I close the Paseo client?"
    answer: "The daemon, not the client window, owns the agent lifecycle. A persistent daemon on the execution host lets desktop, mobile, web, and CLI clients disconnect and reconnect without making the client the worker process."
  - question: "Is a second CODEX_HOME enough to isolate two accounts?"
    answer: "For CLI agents, CODEX_HOME separates Codex authentication, sessions, logs, history, and local databases. Shared configuration and skills can be linked deliberately, but auth files should remain separate."
  - question: "Do I still need a macOS Codex account switcher?"
    answer: "Not for my current workflow. I removed it from both machines after moving agent execution to Paseo. It remains useful only when both official Codex desktop profiles must be open at once."
---

I had just finished building a [Codex Account Switcher](https://github.com/edihasaj/codex-account-switcher).

It solved a real problem. I use two Codex accounts, one for work and one for personal projects. On macOS, running both official desktop profiles at the same time requires two isolated state directories, two Electron data directories, and a small controller to keep the Dock sane. I built the controller, documented the setup, released it, and thought the system was finished.

Then I found [Paseo](https://paseo.sh/).

The account switcher was still correct, but it was solving the problem one layer too high.

> The switcher manages app windows. Paseo manages the agents themselves.

That distinction changed my setup from two desktop applications I had to keep alive into a small, persistent agent infrastructure spread across my MacBook and Mac Studio.

## What Paseo actually is

Paseo is an open-source control plane for coding agents. It does not replace Codex, Claude Code, Copilot, OpenCode, or the other tools it supports. It launches the native agent CLIs already installed on your machine, using their existing credentials, configuration, skills, and tools.

A local daemon owns the agent processes. Desktop, mobile, web, and CLI interfaces connect to that daemon as clients.

That architecture sounds like an implementation detail. In practice, it is the entire point:

- closing a client does not redefine where the work lives;
- the execution machine keeps its own code, credentials, and toolchain;
- another client can reconnect and continue controlling the same agents;
- multiple providers and multiple profiles of one provider appear in one interface;
- workspaces, terminals, services, schedules, and agent lifecycles share one supervisor.

Paseo is closer to Docker's daemon-and-client model than to another chat window. The UI is useful, but the daemon is the product.

## The setup I ended up with

I now run Paseo in two places for two different jobs.

| Layer | MacBook | Mac Studio |
| --- | --- | --- |
| Role | Interactive local work | Always-on execution host |
| Daemon | Started by the Paseo desktop app | Headless CLI daemon managed by `launchd` |
| Network | Bound to loopback | Bound only to its Tailscale address |
| Remote relay | Disabled | Disabled |
| Codex profiles | Work and personal | Work and personal |
| Client access | Desktop and CLI | Desktop, CLI, or mobile over Tailscale |

The MacBook setup is deliberately simple. Opening Paseo starts its bundled daemon on `127.0.0.1:6767`. Local clients talk to it over loopback.

The Studio is the durable half. Its Paseo daemon starts at login under a user LaunchAgent with `RunAtLoad` and `KeepAlive`. The service listens on the Studio's private Tailscale address, not `0.0.0.0`, and the public relay is disabled. A health endpoint gives me a boring test that the daemon is reachable before I blame a client.

The practical result is that the MacBook can be the steering wheel without being the engine. Long-running work can live on the Studio, where the repositories, compilers, authenticated CLIs, and background services already exist.

## Two Codex accounts become two providers

This is the part that made my account-switching workaround feel suddenly small.

Paseo supports custom provider profiles. A profile can extend the built-in Codex adapter and add environment variables. I point each profile at a different `CODEX_HOME`:

```json
{
  "$schema": "https://paseo.sh/schemas/paseo.config.v1.json",
  "version": 1,
  "agents": {
    "providers": {
      "codex": {
        "enabled": false
      },
      "codex-work": {
        "extends": "codex",
        "label": "Codex Work",
        "env": {
          "CODEX_HOME": "/Users/you/.codex"
        },
        "order": 10
      },
      "codex-personal": {
        "extends": "codex",
        "label": "Codex Personal",
        "env": {
          "CODEX_HOME": "/Users/you/.codex-personal"
        },
        "order": 20
      }
    }
  }
}
```

Paseo now shows both accounts as first-class choices. Selecting one launches the same native Codex binary with the corresponding home directory. No logout, no token copying, no wrapper flag, and no second Electron process.

It also preserves the boundary I care about:

| Shared deliberately | Kept separate |
| --- | --- |
| `config.toml` | `auth.json` |
| `AGENTS.md` | sessions |
| hooks | history and logs |
| prompts and rules | local databases |
| skills | account usage and limits |

On both machines, the secondary Codex home links back to the primary profile's configuration, instructions, hooks, prompts, rules, and skills. Authentication and operational state remain real files inside each account directory.

That gives me one operating policy with two identities. A correction to an agent rule or a new skill reaches both profiles, while credentials and session history never cross the boundary.

Do not symlink `auth.json` between profiles. The point is shared behavior, not shared identity.

## Persistence is the larger unlock

My desktop switcher kept both Codex applications open, which was enough for local multitasking. It still depended on GUI processes, a logged-in desktop session, and the health of two Electron instances.

Paseo moves process ownership to the daemon and its supervisor. On the Studio, `launchd` keeps the daemon available. Paseo owns the agents, records their state, and exposes the same lifecycle through every client.

I can start an agent from the MacBook, check it from a phone, send a follow-up through the CLI, and return to the desktop timeline later. The agent still runs where the repository and tools live: on the Studio.

This is a much cleaner mental model:

```text
MacBook / phone / CLI
          |
       Tailscale
          |
   Paseo daemon on Studio
      /             \
Codex Work     Codex Personal
      \             /
 shared tools and project policy
 separate auth and session state
```

The clients are replaceable views. The daemon is the durable owner. The execution host is the source of truth.

## It is more than remote control

Remote control got my attention. Orchestration is what makes Paseo more ambitious.

An agent can use Paseo to discover configured providers, create an isolated worktree, launch another agent, send follow-up prompts, and keep the resulting work visible in the same application. A Codex parent can delegate to Claude, or the reverse. Paseo also exposes scheduled agents, heartbeats, supervised workspace scripts, terminals, and services.

Native subagents are still useful. They are fast and tightly integrated with one provider. Paseo subagents solve a different problem: lifecycle and workspace ownership across provider boundaries.

The worktree support matters here. Two agents editing the same checkout are still two processes racing over the same files. A control plane cannot repeal Git. Paseo-managed workspaces give parallel tasks separate branches and directories instead of asking everyone to behave carefully in one working tree.

## What happened to the account switcher?

I removed it from both machines.

The [two-profile macOS setup](/posts/two-codex-accounts-two-dock-icons-macos) remains useful for anyone who needs the official Codex desktop experience for both accounts. It handles Electron profile isolation, focus switching, and the Dock. Paseo does not turn the official app into a multi-account app.

But I no longer need two official desktop processes as my control plane. Paseo gives both identities named provider profiles and keeps their agents under one supervised lifecycle. The switcher did its job, but the daemon made it unnecessary in my setup.

My default model is now:

1. Codex identities live in separate `CODEX_HOME` directories.
2. Shared rules and skills are linked explicitly.
3. Paseo exposes each identity as a named provider.
4. A local daemon handles laptop work.
5. A persistent Studio daemon handles long-running work.
6. Tailscale provides the private path to the Studio.
7. Desktop, mobile, and CLI clients attach to the daemon that owns the task.

That model scales beyond two accounts and beyond Codex. The provider is a launch contract. The daemon is the lifecycle owner. The client is just where I happen to be looking.

## Security boundaries I kept

An always-on agent daemon can execute code with the permissions of its user. Treat it like infrastructure.

My setup follows a few rules:

- no daemon bound to every network interface;
- no public port forwarding;
- direct Studio access only across Tailscale;
- the hosted relay disabled because I do not need it;
- provider credentials left in the native provider homes;
- no auth files copied into Paseo configuration;
- a dedicated non-root user context;
- exact host allowlisting and a small health check;
- regular Paseo updates while the project is moving quickly.

Paseo's relay is end-to-end encrypted and open source, so disabling it is a topology choice, not a claim that it is unsafe. For a direct network binding, Paseo also supports password authentication. I would add that defense even on a private VPN when the daemon is shared by several devices.

## The honest limitations

Paseo does not merge accounts, chats, billing, or usage limits. It gives each profile a clean launch path.

It does not make unsafe agent permissions safe. If a Codex profile has broad filesystem and network access, launching it through Paseo preserves that power.

It does not make one checkout safe for parallel edits. Use worktrees.

It also does not remove the need to understand where state lives. `PASEO_HOME` owns Paseo state. Each provider still owns its own credentials and sessions. Repositories still live on the execution host.

Finally, Paseo is young and changing quickly. I am comfortable running it because the architecture is local-first, the code is public, the underlying CLIs remain usable without it, and my account isolation does not depend on a proprietary cloud database.

## The real change

I started with a UI problem: how do I keep two Codex accounts open on one Mac?

The better question was: who should own the lifecycle of my agents?

Once the answer became "a daemon on the machine doing the work," the rest simplified. Multiple accounts became provider profiles. The Studio became an execution host. The MacBook and phone became clients. Persistence stopped depending on a window staying open. Orchestration became possible without replacing the tools I already use.

The account switcher fixed my Dock. Paseo made me stop needing the switcher.

Paseo changed the system.

## Frequently asked questions

### Can Paseo run multiple Codex accounts?

Yes. Define multiple custom providers that extend Codex and give each one a different `CODEX_HOME`. Each profile uses its own Codex authentication and state.

### Does Paseo replace Codex?

No. It launches and supervises the native Codex CLI. Your installed binary, subscription, configuration, skills, MCP servers, and credentials remain yours.

### Will work continue if I close the desktop app?

The daemon owns the agent lifecycle, not the desktop window. Keep the daemon and execution host running. Another Paseo client can reconnect to it later.

### Why use a Mac Studio daemon instead of SSH alone?

SSH gives me a shell. Paseo adds durable agent lifecycle, reconnectable timelines, named providers, mobile and desktop clients, orchestration, workspaces, schedules, and supervised services.

### Is the Paseo relay required?

No. Paseo supports direct connections. I use a Tailscale-only address and disable the relay. The official relay is an alternative for simpler remote access and provides end-to-end encryption.

### Do I still need the Codex Account Switcher?

Not for my current workflow. I removed it from both machines. It is still useful for simultaneous use of two official Codex desktop profiles because Paseo handles native CLI agents and their lifecycle, not Electron profile isolation inside OpenAI's app.

More: [AI agent essays](/topics/ai-agents/) and [OpenAI Codex guides](/topics/codex/).

---

Sources:

- [Paseo documentation](https://paseo.sh/docs)
- [How Paseo providers work](https://paseo.sh/docs/providers)
- [Paseo custom provider profiles](https://paseo.sh/docs/custom-providers)
- [Paseo orchestration](https://paseo.sh/docs/orchestration)
- [Paseo worktrees](https://paseo.sh/docs/worktrees)
- [Paseo security model](https://paseo.sh/docs/security)
- [Paseo on GitHub](https://github.com/getpaseo/paseo)
