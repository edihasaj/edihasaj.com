---
layout: page
title: About
permalink: /about/
og_image: /images/header-edi.jpg
og_image_alt: Edi Hasaj
---

Software engineer. Building the next layer of software.

Over a decade of shipping code. Deep in AI Engineering, with a backbone of backend, systems, and infra. Agents, local-first tools, and the sharp little things that replace bloated SaaS.

The future is autonomous, local, and open. Closed bloat loses. I am betting on the other side, and shipping the proof every week.

Based in Prishtinë. Mostly online.

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

- **Opening more code** — especially useful agent, memory, and workflow patterns.
- **Building AI products** — tools that connect to real business and government systems.
- **Writing on [edihasaj.com](/)** — software, AI, and thinking.

## Connect

- GitHub: [edihasaj](https://github.com/edihasaj)
- X: [@hasajedi](https://x.com/hasajedi)
- LinkedIn: [edihasaj](https://www.linkedin.com/in/edihasaj/)

If you want to talk shop, agents, infra, cloud tech, shipping, reach out on any of these.
