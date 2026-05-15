---
share: true
layout: post
title: "Everything Will Be Agent Use"
date: 2026-05-14
published: true
filename: essay/_posts/2026-05-14-everything-will-be-agent-use
image: /images/posts/everything-will-be-agent-use-2026-05-14.jpg
tags:
  - AI
  - agents
  - computer-use
  - protocols
  - A2A
  - MCP
excerpt: "Computer use is the new browser war. Google, OpenAI, Anthropic, Perplexity and Manus are all racing to put an agent in front of the screen. The hard part is not moving the mouse, it is that the world on the other side of the cursor was never built for them."
---

I have been watching the new wave of computer-use agents and honestly, most of what they do is incredible. The mouse moves like a real user. Forms get filled. Sites get navigated. Tabs get juggled. Tasks that needed a person sitting in front of a screen are now running on their own, end to end, with surprisingly little hand-holding. Five years ago this was science fiction. Today it is a demo you can run on your own laptop, and the future of how we use software clearly runs through here.

Then you watch long enough and the same shape keeps showing up. The agent looks great for the first half of the task, sometimes the first ninety percent, and then the workflow hits a login wall, a captcha, a 3-D Secure popup, a card form that wants a human phone tap, and everything stalls. The agent was good enough to make the stall feel absurd. That is new. A year or two ago the impressive part was that it could move through the task at all.

That is the actual story of computer use right now. Agents got useful faster than the systems around them got ready to trust, verify, and bill them.

## the cursor is the new interface

For a few years we assumed AI would live in a chat box. Type, answer, repeat. The interface was words.

That assumption is dead. The interface is your operating system now. The agent gets the mouse, the keyboard, the browser tabs, sometimes your card. It does not describe how to do the thing. It does the thing.

Every serious lab is on this. Anthropic shipped computer use in late 2024, and Claude has been driving desktops since. OpenAI followed with Operator. Google has Gemini computer use plus Project Mariner inside Chrome. Perplexity built Comet, an entire browser shaped around an agent. Manus came out of China with a general-purpose agent that books trips, files paperwork, and scrapes whatever you point it at. Microsoft and Apple are wiring this into the OS itself, quieter, slower, much closer to where the real leverage is.

Pick any of them. The message is the same. The agent is the new user.

## how far we actually got

Two years ago, asking a model to complete a real multi-step task on a real desktop was a coin flip at best. OSWorld, the most honest early benchmark for desktop agents, was sitting at around 14% when it launched in 2024. The progress since has been fast enough that any single number starts going stale almost immediately.

<figure class="post-figure" markdown="0">
<svg viewBox="0 0 720 320" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="OSWorld benchmark progress chart" style="width:100%;height:auto;color:currentColor">
  <style>
    .axis { stroke: currentColor; stroke-width: 1; opacity: 0.4 }
    .grid { stroke: currentColor; stroke-width: 1; opacity: 0.1; stroke-dasharray: 2 4 }
    .lbl  { font: 12px ui-sans-serif, system-ui, -apple-system, sans-serif; fill: currentColor; opacity: 0.7 }
    .ttl  { font: 600 13px ui-sans-serif, system-ui, sans-serif; fill: currentColor }
    .val  { font: 600 12px ui-sans-serif, system-ui, sans-serif; fill: currentColor }
    .ln   { fill: none; stroke: #14b8a6; stroke-width: 2.5; stroke-linejoin: round }
    .hum  { stroke: #f59e0b; stroke-width: 1.5; stroke-dasharray: 4 4; fill: none }
    .pt   { fill: #14b8a6 }
  </style>
  <text x="20" y="22" class="ttl">OSWorld benchmark progress, desktop agents</text>
  <text x="20" y="40" class="lbl">success rate on desktop-task benchmark suites</text>

  <!-- grid + y axis -->
  <line class="axis" x1="60" y1="60" x2="60" y2="270" />
  <line class="axis" x1="60" y1="270" x2="700" y2="270" />
  <g>
    <line class="grid" x1="60" y1="90"  x2="700" y2="90"  /><text x="50" y="94"  text-anchor="end" class="lbl">80%</text>
    <line class="grid" x1="60" y1="135" x2="700" y2="135" /><text x="50" y="139" text-anchor="end" class="lbl">60%</text>
    <line class="grid" x1="60" y1="180" x2="700" y2="180" /><text x="50" y="184" text-anchor="end" class="lbl">40%</text>
    <line class="grid" x1="60" y1="225" x2="700" y2="225" /><text x="50" y="229" text-anchor="end" class="lbl">20%</text>
    <text x="50" y="274" text-anchor="end" class="lbl">0%</text>
  </g>

  <!-- human baseline ~72% => y = 270 - (72/100)*180 = 140.4 -->
  <line class="hum" x1="60" y1="140" x2="700" y2="140" />
  <text x="694" y="134" text-anchor="end" class="lbl">human baseline ~72%</text>

  <!-- points: x positions for Apr24, Oct24, Apr25, Oct25, Apr26
       values: 14, 22, 38, 53, 75 -->
  <polyline class="ln" points="
    100,238
    250,220
    400,184
    550,151
    680,135
  " />
  <g>
    <circle class="pt" cx="100" cy="238" r="5"/><text x="100" y="258" text-anchor="middle" class="val">14%</text>
    <circle class="pt" cx="250" cy="220" r="5"/><text x="250" y="240" text-anchor="middle" class="val">22%</text>
    <circle class="pt" cx="400" cy="184" r="5"/><text x="400" y="204" text-anchor="middle" class="val">38%</text>
    <circle class="pt" cx="550" cy="151" r="5"/><text x="550" y="171" text-anchor="middle" class="val">53%</text>
    <circle class="pt" cx="680" cy="135" r="5"/><text x="680" y="125" text-anchor="middle" class="val">75%</text>
  </g>

  <g class="lbl">
    <text x="100" y="290" text-anchor="middle">Apr 2024</text>
    <text x="250" y="290" text-anchor="middle">Oct 2024</text>
    <text x="400" y="290" text-anchor="middle">Apr 2025</text>
    <text x="550" y="290" text-anchor="middle">Oct 2025</text>
    <text x="680" y="290" text-anchor="middle">Apr 2026</text>
  </g>
  <text x="380" y="314" text-anchor="middle" class="lbl">Approximate top reported scores. Human baseline ~72% from Xie et al., OSWorld 2024.</text>
</svg>
</figure>

On "can the agent see and click the right thing", the field is getting very good. Pixel-grounding benchmarks like ScreenSpot are above 90% for the top models. The eyes work. The hands mostly work. The old joke that agents cannot use computers is aging badly.

On "can the agent finish a real workflow", the answer is messier. The best systems are now brushing against human baselines on OSWorld-style tasks, which is a ridiculous improvement from 2024. But benchmark parity is not the same thing as operational trust. Newer cross-application evals still show ugly failure rates once the task requires several apps, conditional judgment, cleanup, and persistence. Even a 75% task success rate means one in four things still falls over somewhere.

And that "somewhere" is almost never "I could not read the button". It is the page reloaded, the login screen came back, a captcha appeared, a popup blocked the click, the cart wants your card, or the agent did the right local action inside the wrong global state.

The cursor is not the bottleneck. The world around the cursor is.

## the five shapes people are shipping

There is a tendency to talk about "computer use" like it is one product. It is at least five, and the shapes have very different trade-offs.

The desktop agent runs on your machine and can touch anything you can touch. Anthropic's computer use sits here. Max power, max blast radius. If it gets confused, it can delete things you cared about. Trust bar is high. Best for power users and developers who can sandbox it.

The browser agent lives inside a tab. Perplexity Comet, Arc's agent, the various Chromium-based experiments. Safer becuase the world it can break is small, but it hits a wall every time a workflow leaves the browser. Try to download a PDF, sign it, attach it back somewhere, and the seams show up immediately.

The managed agent runs in the cloud. OpenAI Operator is the cleanest example. Convenient because you do not give it your laptop, but the moment the site you care about decides cloud IP's look like bots, you are stuck in captcha purgatory.

The OS-level agent is the long game. Apple, Microsoft, and Google's mobile push are all trying to wire agents into the system itself: real accessibility trees, real intents, real content types. When the OS exposes structure, the agent stops guessing. This is also the lane with the most patience, which is why Apple in particular looks slow untill they suddenly are not.

The generalist agent is the demo champion. Manus, Mariner-style long-horizon planners. They will plan your trip, file your form, scrape your competitor. They will also confidently do the wrong thing for ninety steps before failing in a way you cannot easily unwind.

Each shape is real. None of them is finished.

## where the workflow actually breaks

If you sit and watch a serious computer-use demo end to end, the failure mode is almost always the same. The agent looks brilliant for the first half of the task and then loses to something boring.

<figure class="post-figure" markdown="0">
<svg viewBox="0 0 720 340" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Agent workflow drop-off funnel" style="width:100%;height:auto;color:currentColor">
  <style>
    .lbl { font: 12px ui-sans-serif, system-ui, sans-serif; fill: currentColor; opacity: 0.8 }
    .ttl { font: 600 13px ui-sans-serif, system-ui, sans-serif; fill: currentColor }
    .val { font: 600 13px ui-sans-serif, system-ui, sans-serif; fill: currentColor }
    .step { fill: currentColor; opacity: 0.85 }
    .bar1 { fill: #14b8a6 }
    .bar2 { fill: #2dd4bf }
    .bar3 { fill: #fbbf24 }
    .bar4 { fill: #f97316 }
    .bar5 { fill: #ef4444 }
  </style>
  <text x="20" y="22" class="ttl">Where a real agent workflow drops off</text>
  <text x="20" y="40" class="lbl">success rate at each stage of "buy a thing online", roughly</text>

  <!-- bars: x=240 start, max width = 420 -->
  <g>
    <rect class="bar1" x="240" y="70"  width="420" height="32" rx="4"/>
    <text x="232" y="90"  text-anchor="end" class="step">find the right product</text>
    <text x="668" y="90"  class="val">95%</text>

    <rect class="bar2" x="240" y="116" width="394" height="32" rx="4"/>
    <text x="232" y="136" text-anchor="end" class="step">add to cart</text>
    <text x="640" y="136" class="val">88%</text>

    <rect class="bar3" x="240" y="162" width="294" height="32" rx="4"/>
    <text x="232" y="182" text-anchor="end" class="step">log in / handle popups</text>
    <text x="540" y="182" class="val">66%</text>

    <rect class="bar4" x="240" y="208" width="231" height="32" rx="4"/>
    <text x="232" y="228" text-anchor="end" class="step">pass captcha / fraud check</text>
    <text x="477" y="228" class="val">52%</text>

    <rect class="bar5" x="240" y="254" width="180" height="32" rx="4"/>
    <text x="232" y="274" text-anchor="end" class="step">complete payment + 3-D Secure</text>
    <text x="426" y="274" class="val">~40%</text>
  </g>

  <text x="380" y="320" text-anchor="middle" class="lbl">Illustrative composite from public agent evals, mid 2026. Indicative shape, not a measured benchmark.</text>
</svg>
</figure>

It is not glamorous. Finding the product is easy. Adding it to the cart is easy. Then auth shows up, fraud signals trip, a phone-based 3-D Secure challenge fires off, and the agent stalls because the verification was designed to assume there is a human holding a phone, not a long-running automation.

Most demos quietly stop right before this cliff. The honest ones hand control back to the user at checkout, which kind of defeats the point of an agent.

![An AI cursor frozen in front of a glowing 3-D Secure popup over a blurred checkout form](/images/posts/everything-will-be-agent-use-checkout-2026-05-14.jpg)

## the protocols are the actual story

The reason buying is so painful is structural. The stack assumes a human in a browser, with cookies, a card on file, a phone for 3-D Secure, and a fraud score built from device fingerprints and behavior. An agent breaks almost every one of those assumptions, and the merchant has no clean way to know "this purchase was authorized by Edi, with these limits, through this agent, for this purpose". So they either block it, or they let it through and hope.

This is what protocols are quietly fixing. Three layers matter.

<figure class="post-figure" markdown="0">
<svg viewBox="0 0 720 290" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Agent protocol stack diagram" style="width:100%;height:auto;color:currentColor">
  <style>
    .ttl { font: 600 13px ui-sans-serif, system-ui, sans-serif; fill: currentColor }
    .lbl { font: 12px ui-sans-serif, system-ui, sans-serif; fill: currentColor; opacity: 0.8 }
    .tag { font: 600 12px ui-sans-serif, system-ui, sans-serif; fill: currentColor }
    .box { stroke: currentColor; stroke-width: 1.2; fill: none; rx: 6 }
    .l1  { fill: #14b8a6; opacity: 0.18 }
    .l2  { fill: #6366f1; opacity: 0.18 }
    .l3  { fill: #f59e0b; opacity: 0.20 }
    .arr { stroke: currentColor; stroke-width: 1.2; opacity: 0.5; fill: none; marker-end: url(#a) }
  </style>
  <defs>
    <marker id="a" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto">
      <path d="M0,0 L10,5 L0,10 z" fill="currentColor" opacity="0.5"/>
    </marker>
  </defs>

  <text x="20" y="22" class="ttl">The agent protocol stack, mid 2026</text>
  <text x="20" y="40" class="lbl">three layers, three different adoption curves</text>

  <!-- AP2 -->
  <rect x="40" y="60"  width="640" height="60" rx="8" class="l3"/>
  <rect x="40" y="60"  width="640" height="60" rx="8" class="box"/>
  <text x="60"  y="86"  class="tag">AP2 — Agent Payments Protocol</text>
  <text x="60"  y="106" class="lbl">verifiable mandates: this agent may spend up to X, for user Y, at merchant Z, signed and revocable</text>
  <text x="660" y="86"  text-anchor="end" class="lbl">agent ↔ merchant</text>

  <!-- A2A -->
  <rect x="40" y="135" width="640" height="60" rx="8" class="l2"/>
  <rect x="40" y="135" width="640" height="60" rx="8" class="box"/>
  <text x="60"  y="161" class="tag">A2A — Agent2Agent</text>
  <text x="60"  y="181" class="lbl">two agents from different vendors negotiate, hand off tasks, exchange context, return results</text>
  <text x="660" y="161" text-anchor="end" class="lbl">agent ↔ agent</text>

  <!-- MCP -->
  <rect x="40" y="210" width="640" height="60" rx="8" class="l1"/>
  <rect x="40" y="210" width="640" height="60" rx="8" class="box"/>
  <text x="60"  y="236" class="tag">MCP — Model Context Protocol</text>
  <text x="60"  y="256" class="lbl">the plumbing: agent talks to tools, files, APIs, databases in a single standard way</text>
  <text x="660" y="236" text-anchor="end" class="lbl">agent ↔ tool</text>
</svg>
</figure>

MCP is the floor. It is the boring, beautiful plumbing that lets an agent talk to a tool, a database, a file system, an API in one standard way. It is already widely adopted across Anthropic, OpenAI, Cursor, and most serious IDEs. If you are building anything agentic, MCP is the layer you build on, not around.

A2A is the layer above. Google and a coalition of partners pushed it out in 2025 as an open protocol for agents from different vendors to talk to each other. My booking agent calls your inventory agent, they negotiate, work happens, result comes back. If A2A actually catches on, the web stops being a pile of HTML that an agent has to squint at, and starts being a network of cooperating services with structured handshakes.

AP2 is the one I find most concrete. The Agent Payments Protocol, announced by Google with Mastercard, American Express, Coinbase, PayPal and a long list of issuers in late 2025, is an attempt to do for agent commerce what 3-D Secure tried to do for online cards. The agent presents a verifiable mandate signed by the human. The merchant verifies it. The issuer verifies it. Payment flows, with cryptographic evidence at every step. "This agent bought this item for this user with this budget" finally has a real signature behind it instead of a session cookie and a prayer.

If you are a merchant, this is the upgrade path you cannot ignore for long. Either you wire up agent-friendly payments with verifiable mandates, or you start quietly blocking a non-trivial slice of your traffic, because that slice is no longer human.

## the messy middle is where we live

The bad news is that none of these protocols are live across the long tail. MCP is the closest. A2A is real but mostly between cooperative parties. AP2 has the right names on the press release and nowhere near enough merchant support to run your week through it yet.

So agents in 2026 are stuck doing two jobs at once.

That is why the moment feels so strange. Agents are good enough to use every day, and not good enough to forget about while they hold your card, your calendar, your inbox, or your company account.

One job is helping the long tail of legacy sites and apps that will never speak A2A by pretending to be a human. This is a perception and resilience problem. Better screen understanding, better recovery when a popup appears, better memory of "I already tried this and it failed". The flashy demo lives here, and so does most of the brittleness. Every UI redesign quietly breaks an agent somewhere.

The other job is helping the leading edge of services adopt MCP, A2A, AP2, so the next round can be cleaner. This is mostly a trust and identity problem. Who signed the mandate, who is liable, how do we revoke, what audit trail do we keep. Less glamorous. Much more durable.

The winners over the next few years will not be the labs with the flashiest demo. They will be the ones that solve the perception problem and the trust problem at the same time, so the agent is both capable of running a task on a legacy site and credible enough to do it on a modern one. Most of the current crop is good at one and pretending about the other.

## what to actually do

If you build software, four things are worth doing this year. Design your UI so an agent can also use it: real accessibility trees, structured labels, predictable flows, not just whatever the design system spat out. Ship an MCP server if you have any tool surface worth exposing. Start thinking about an A2A integration even before you build it, because the shape of your data and identity model matters more than the wire format. If you take payments, track AP2 and similar mandates, even if you do not implement yet, because the fraud and identity decisions you make in 2026 will determine whether you can adopt cleanly in 2027.

If you do not build software, the practical version is shorter. The next few apps you install, ask whether an agent could run it for you. If yes, thats your new productivity ceiling. If no, that is a future migration waiting to happen.

The cursor is moving. Whether it is moved by you or by something acting on your behalf is going to become a question you ask several times a day. I am not nostalgic about clicking through forms. I am, however, nervous about the gap between what these agents can already do and what the systems on the other side are ready to verify, trust and bill. That gap is the work of the next two years, and the companies that close it first are going to look very different from the ones currently winning the demo cycle.

The demo is the easy part. The plumbing under it is the rest of the decade.
