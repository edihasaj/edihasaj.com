---
layout: page
title: About
permalink: /about/
---

Software engineer and technical founder. Cloud and infrastructure at the core, applied to AI and agentic systems.

For over a decade I have built and run the software businesses depend on: ERPs, internal platforms, integrations, and APIs, across retail, legal, government, and SaaS. That includes moving companies off legacy systems, keeping production stable, and shipping products of my own, some that worked and some that did not.

Today I connect that experience to AI: agents, memory, and workflow patterns that plug into real business systems, plus small focused tools that replace bloated SaaS. Open-sourced where useful.

I bet on software that is practical, local, and open. Based in Prishtinë. Mostly online.

## Building & Shipping

Open source, products, and the odd legacy thing. New apps land here as I ship them.

### Open Source

{% for p in site.data.projects.open_source %}- {{ p.emoji }} **[{{ p.name }}]({{ p.url }})** - {{ p.desc }}{% if p.source %} ([source]({{ p.source }})){% endif %}
{% endfor %}

### Projects

{% for p in site.data.projects.projects %}- {{ p.emoji }} **[{{ p.name }}]({{ p.url }})** - {{ p.desc }}{% if p.source %} ([source]({{ p.source }})){% endif %}
{% endfor %}

### Legacy

{% for p in site.data.projects.legacy %}- {{ p.emoji }} **[{{ p.name }}]({{ p.url }})** - {{ p.desc }}{% if p.source %} ([source]({{ p.source }})){% endif %}
{% endfor %}

## What I'm Doing

- **Building and running products** - from business software to AI agents that plug into it.
- **Opening more code** - agent, memory, and workflow tooling that others can reuse.
- **Writing on [edihasaj.com](/)** - engineering, building companies, and AI.

## Connect

- GitHub: [edihasaj](https://github.com/edihasaj)
- X: [@hasajedi](https://x.com/hasajedi)
- LinkedIn: [edihasaj](https://www.linkedin.com/in/edihasaj/)

If you want to talk systems, products, agents, or shipping, reach out on any of these.
