---
layout: page
title: About
permalink: /about/
---

Software engineer and technical founder.

Over a decade of building the software businesses run on: ERPs, internal platforms, integrations, APIs, and the cloud and infrastructure underneath. Retail, legal, government, and SaaS. I have moved companies off legacy systems, kept production running, and shipped products of my own, some that worked and some that did not.

Now I apply that to AI. Agents, memory, and workflow patterns that connect to real business systems, plus the sharp little tools that replace bloated SaaS. Open-sourced where useful.

I bet on software that is practical, local, and open. Based in Prishtinë. Mostly online.

## Building & Shipping

Open source, products, and the odd legacy thing. New apps land here as I ship them.

### Open Source

{% for p in site.data.projects.open_source %}- {{ p.emoji }} **[{{ p.name }}]({{ p.url }})** — {{ p.desc }}{% if p.source %} ([source]({{ p.source }})){% endif %}
{% endfor %}

### Projects

{% for p in site.data.projects.projects %}- {{ p.emoji }} **[{{ p.name }}]({{ p.url }})** — {{ p.desc }}{% if p.source %} ([source]({{ p.source }})){% endif %}
{% endfor %}

### Legacy

{% for p in site.data.projects.legacy %}- {{ p.emoji }} **[{{ p.name }}]({{ p.url }})** — {{ p.desc }}{% if p.source %} ([source]({{ p.source }})){% endif %}
{% endfor %}

## GitHub Activity

<a href="https://github.com/edihasaj">
  <img src="https://ghchart.rshah.org/fd8f0f/edihasaj" alt="edihasaj GitHub contributions" style="max-width:100%;">
</a>

## What I'm Doing

- **Building and running products** — from business software to AI agents that plug into it.
- **Opening more code** — agent, memory, and workflow tooling that others can reuse.
- **Writing on [edihasaj.com](/)** — engineering, building companies, and AI.

## Connect

- GitHub: [edihasaj](https://github.com/edihasaj)
- X: [@hasajedi](https://x.com/hasajedi)
- LinkedIn: [edihasaj](https://www.linkedin.com/in/edihasaj/)

If you want to talk systems, products, agents, or shipping, reach out on any of these.
