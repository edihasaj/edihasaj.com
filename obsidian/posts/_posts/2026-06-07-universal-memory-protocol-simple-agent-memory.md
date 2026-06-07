---
share: true
layout: post
title: "Universal Memory Protocol: Simple Agent Memory That Moves"
date: 2026-06-07
published: true
filename: essay/_posts/2026-06-07-universal-memory-protocol-simple-agent-memory
tags:
  - AI
  - agents
  - memory
  - protocols
  - MCP
  - open-source
excerpt: "Agent memory is fragmented across tools, files, and products. Universal Memory Protocol is my attempt to make memory portable: one record, six operations, and bindings that work with MCP, HTTP, and files."
---

I built [Recall](https://github.com/edihasaj/recall) because I was tired of correcting coding agents about the same repo rules every week. That solved a local problem. The agent would remember "use pnpm here", "run this gate before handoff", "do not touch this folder", and the next session would start with that context already loaded.

Then I hit the next problem.

The memory was useful, but it was trapped in one shape. Claude Code had one way to hold project rules. Codex had another. ChatGPT had another. Local agents had files. Some frameworks had vector stores. Some had graph stores. Some had nothing. Every tool was learning the same things about me and my projects, but none of them could share those memories in a clean way.

That is why I started [Universal Memory Protocol](https://github.com/edihasaj/universal-memory-protocol), or UMP.

The simple version:

> MCP lets agents use tools. A2A lets agents talk to agents. UMP lets agents carry memory.

It is not meant to be a new database. It is not meant to replace Recall, Mem0, Letta, Zep, Obsidian, Postgres, SQLite, Redis, or a vector index. It is the small contract between them.

<figure class="post-figure" markdown="0">
<svg viewBox="0 0 760 350" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Universal Memory Protocol structure" style="width:100%;height:auto;color:currentColor">
  <style>
    .ttl { font: 700 16px ui-sans-serif, system-ui, sans-serif; fill: currentColor }
    .sub { font: 12px ui-sans-serif, system-ui, sans-serif; fill: currentColor; opacity: 0.74 }
    .lbl { font: 700 13px ui-sans-serif, system-ui, sans-serif; fill: currentColor }
    .txt { font: 12px ui-sans-serif, system-ui, sans-serif; fill: currentColor; opacity: 0.78 }
    .box { fill: none; stroke: currentColor; stroke-width: 1.2; opacity: 0.58 }
    .a { fill: #14b8a6; opacity: 0.16 }
    .b { fill: #f59e0b; opacity: 0.18 }
    .c { fill: #6366f1; opacity: 0.15 }
    .d { fill: #ef4444; opacity: 0.12 }
    .line { stroke: currentColor; stroke-width: 1.4; opacity: 0.42; fill: none }
  </style>

  <text x="28" y="34" class="ttl">UMP is three boring pieces</text>
  <text x="28" y="54" class="sub">one record shape, one tiny operation set, three ways to connect</text>

  <rect x="40" y="82" width="200" height="210" rx="8" class="a"/>
  <rect x="40" y="82" width="200" height="210" rx="8" class="box"/>
  <text x="66" y="116" class="lbl">1. Portable record</text>
  <text x="66" y="146" class="txt">kind</text>
  <text x="66" y="166" class="txt">body</text>
  <text x="66" y="186" class="txt">scope</text>
  <text x="66" y="206" class="txt">time</text>
  <text x="66" y="226" class="txt">provenance</text>
  <text x="66" y="246" class="txt">consent</text>
  <text x="66" y="266" class="txt">integrity</text>

  <rect x="280" y="82" width="200" height="210" rx="8" class="b"/>
  <rect x="280" y="82" width="200" height="210" rx="8" class="box"/>
  <text x="306" y="116" class="lbl">2. Six operations</text>
  <text x="306" y="146" class="txt">capabilities</text>
  <text x="306" y="166" class="txt">recall</text>
  <text x="306" y="186" class="txt">remember</text>
  <text x="306" y="206" class="txt">get</text>
  <text x="306" y="226" class="txt">revise</text>
  <text x="306" y="246" class="txt">forget</text>
  <text x="306" y="266" class="txt">feedback at L3</text>

  <rect x="520" y="82" width="200" height="210" rx="8" class="c"/>
  <rect x="520" y="82" width="200" height="210" rx="8" class="box"/>
  <text x="546" y="116" class="lbl">3. Bindings</text>
  <text x="546" y="146" class="txt">MCP tools</text>
  <text x="546" y="166" class="txt">HTTP endpoints</text>
  <text x="546" y="186" class="txt">JSON files</text>
  <text x="546" y="206" class="txt">Markdown files</text>
  <text x="546" y="226" class="txt">.well-known discovery</text>

  <path d="M240 187 H280" class="line"/>
  <path d="M480 187 H520" class="line"/>

  <rect x="120" y="312" width="520" height="30" rx="6" class="d"/>
  <text x="380" y="332" text-anchor="middle" class="txt">The storage engine still competes on retrieval, ranking, decay, and compression.</text>
</svg>
</figure>

## The Shape

UMP is deliberately small:

1. A portable memory record.
2. Six core operations.
3. MCP, HTTP, and file bindings.
4. Conformance levels from simple export to full signed runtime.

The record is the main thing. A memory needs a type, a body, a scope, time fields, lifecycle hints, relations, provenance, consent, and integrity.

In normal words:

> what is this memory, who owns it, where is it valid, when was it true, where did it come from, who may see it, and can I verify it?

That sounds obvious, but most agent memory today does not carry all of that. It might have text and an embedding. It might have a user id. It might have a timestamp. But the moment you try to move it from one agent or store to another, the missing fields matter.

If a memory says "use pnpm", is that global, repo-specific, team-specific, or only true for one branch? If it says "the deployment target is staging", was that true yesterday or is it true now? If an agent wrote it, did the user approve it? If it contains a secret or personal detail, should it be exported at all?

UMP puts those questions into the record instead of leaving them as product-specific behavior.

## How I Came To It

The first version of the idea came from pain, not architecture.

I use multiple agents. I switch between tools. I also work across enough repos that the same mistake keeps coming back in different clothes. One agent learns a rule, another agent does not know it, and I become the bridge.

Recall proved the useful part: corrections can become repo memory, memory can be ranked, stale memories can be retired, and the agent gets better without a giant instruction file.

But Recall also made the protocol gap obvious. The useful abstraction was not "Recall". It was:

> an agent needs to ask for relevant memory, write new memory, revise old memory, forget unsafe memory, and prove where memory came from.

That maps cleanly to operations:

| Operation | Meaning |
| --- | --- |
| `capabilities` | What does this memory server support? |
| `recall` | Find relevant memories for this scope and query. |
| `remember` | Store a new memory. |
| `get` | Fetch a memory by id. |
| `revise` | Replace a memory without destroying its history. |
| `forget` | Tombstone or remove a memory with a reason. |

That is enough for a small client. It is also enough for adapters. A fancy graph memory system and a simple JSON file can speak the same verbs, while still behaving differently underneath.

## What It Fixes

UMP fixes four practical problems.

First, memory lock-in. If Claude learns a project rule and Codex cannot read it, that is not memory. That is product state. UMP makes the memory record portable so it can move between hosts and stores.

Second, stale memory. A lot of memory systems overwrite facts. That is dangerous because old context disappears and the agent cannot reason about when something was true. UMP uses bi-temporal records and supersession. A memory can be replaced without pretending the old one never existed.

Third, trust. Recalled memory is not sacred. It can be wrong, stale, malicious, or out of scope. UMP treats memory as untrusted input and requires safe rehydration before it enters the model context. The context block says, in effect, "these are references, not instructions."

Fourth, ownership. A useful memory record should carry provenance, consent, and eventually signatures. UMP uses existing standards where they fit, like [W3C PROV](https://www.w3.org/TR/prov-o/) for provenance, [DID](https://www.w3.org/TR/did-core/) for owner identity, and [RFC 8785 JSON canonicalization](https://www.rfc-editor.org/rfc/rfc8785.html) for deterministic signing.

The important point is what UMP does not try to fix. It does not decide which embedding model is best. It does not mandate graph search. It does not freeze a decay curve. It does not tell Recall, Zep, Letta, Mem0, SQLite, or Postgres how to rank memory.

It standardizes the parts that must match for memory to travel. The intelligence stays inside the engine.

## How It Runs

The fastest way to use it is through [MCP](https://modelcontextprotocol.io/docs/getting-started/intro), because most agent hosts already know how to talk to MCP servers.

```jsonc
{
  "mcpServers": {
    "ump": {
      "command": "npx",
      "args": ["-y", "@universalmemoryprotocol/core", "ump-memory"]
    }
  }
}
```

That gives the host `ump.recall`, `ump.remember`, `ump.get`, `ump.revise`, `ump.forget`, and `ump.capabilities`.

By default, the reference server writes a portable file at:

```text
~/.ump/memory.ump.json
```

Point another MCP host at the same store and it can use the same memories. That is the money shot: write in one agent, recall in another.

There is also an HTTP binding for apps that do not speak MCP, and a file binding for plain exports. That matters because adoption should not require the full runtime. A project can start at L0 with a `*.ump.json` or `*.ump.md` file, then move to an L1 or L2 server later.

<figure class="post-figure" markdown="0">
<svg viewBox="0 0 760 300" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="UMP memory flow from one agent to another" style="width:100%;height:auto;color:currentColor">
  <style>
    .ttl { font: 700 15px ui-sans-serif, system-ui, sans-serif; fill: currentColor }
    .lbl { font: 700 13px ui-sans-serif, system-ui, sans-serif; fill: currentColor }
    .txt { font: 12px ui-sans-serif, system-ui, sans-serif; fill: currentColor; opacity: 0.78 }
    .box { fill: none; stroke: currentColor; stroke-width: 1.2; opacity: 0.58 }
    .agent { fill: #14b8a6; opacity: 0.16 }
    .store { fill: #f59e0b; opacity: 0.18 }
    .agent2 { fill: #6366f1; opacity: 0.15 }
    .line { stroke: currentColor; stroke-width: 1.5; opacity: 0.44; fill: none; marker-end: url(#arrow) }
  </style>
  <defs>
    <marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto">
      <path d="M0,0 L10,5 L0,10 z" fill="currentColor" opacity="0.55"/>
    </marker>
  </defs>

  <text x="28" y="34" class="ttl">One memory, two agents</text>

  <rect x="46" y="86" width="180" height="92" rx="8" class="agent"/>
  <rect x="46" y="86" width="180" height="92" rx="8" class="box"/>
  <text x="76" y="122" class="lbl">Agent A</text>
  <text x="76" y="146" class="txt">calls ump.remember</text>

  <rect x="300" y="66" width="160" height="132" rx="8" class="store"/>
  <rect x="300" y="66" width="160" height="132" rx="8" class="box"/>
  <text x="338" y="112" class="lbl">UMP store</text>
  <text x="330" y="138" class="txt">signed record</text>
  <text x="330" y="158" class="txt">scope checked</text>
  <text x="330" y="178" class="txt">history kept</text>

  <rect x="534" y="86" width="180" height="92" rx="8" class="agent2"/>
  <rect x="534" y="86" width="180" height="92" rx="8" class="box"/>
  <text x="564" y="122" class="lbl">Agent B</text>
  <text x="564" y="146" class="txt">calls ump.recall</text>

  <path d="M226 132 H300" class="line"/>
  <path d="M460 132 H534" class="line"/>

  <text x="380" y="242" text-anchor="middle" class="txt">The host changes. The memory record does not.</text>
</svg>
</figure>

## How Fast It Is

For the default local file store, the answer is boring and good: around 5ms recall at 3,000 records in the current benchmarks. That is the right default for most project memory. It is local, portable, and fast enough that the agent does not feel like it is waiting on a separate brain.

The richer Recall-backed path costs more because it does actual semantic retrieval. In my current benchmark notes, it is roughly 100ms to write and roughly 200ms to recall after warming the local embedding model. The tradeoff is quality: paraphrase top-1 recall improves from 1 out of 8 with lexical matching to 5 out of 8 with Recall's vector plus BM25 search.

So the rule is simple:

| Store | Best for | Rough speed |
| --- | --- | --- |
| JSON file | portable local memory, repo rules, simple preferences | about 5ms recall at 3k records |
| Markdown files | human-editable memory | depends on folder size |
| Recall adapter | semantic search and stronger retrieval quality | about 100ms write, about 200ms recall |
| Vector store | scale and semantic recall | depends on embeddings and backend |

Fast memory is useful because agents ask for memory often. But retrieval quality matters too. UMP keeps that choice open. You can start with the file store, then swap the backend when the shape of the work needs it.

## The Part I Care About

The part I care about is not that UMP exists as a spec. Specs are cheap.

The part I care about is the round trip:

> an agent writes a memory, another agent recalls it, the record is still owned by the user, and the receiving agent treats it as scoped reference data instead of hidden instruction text.

That is the missing piece for serious agent work. Agents are getting better at tools through MCP. They are getting better at coordination through [A2A](https://a2a-protocol.org/latest/specification/). But they still forget, fork, and trap memory inside product-specific state.

I do not want every new agent to start from zero. I also do not want all my working memory locked inside one vendor.

UMP is my attempt to make the layer small enough to adopt and structured enough to trust.

One record. Six operations. Memory that moves.
