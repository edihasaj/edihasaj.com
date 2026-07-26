---
title: "How to Add an MCP Server to Codex"
short_title: "Add an MCP server"
description: "Connect Codex to an MCP server, keep credentials out of configuration, and verify the server before relying on it."
date: 2026-07-26
last_modified_at: 2026-07-26
intent: "Connect MCP"
category: "Extensions"
level: "Intermediate"
tested_on: "Codex CLI, IDE, and desktop"
time: "10 minutes"
field_note: "A connected server is not automatically useful. Verify its tools and authentication in a fresh task."
slug: mcp-servers
keywords: [Codex MCP, add MCP server, Codex tools, Model Context Protocol]
related: [config-toml, skills, agents-md]
---

## Add an HTTP MCP server

Use the Codex CLI for a remote HTTP endpoint:

```zsh
codex mcp add server-name --url https://example.com/mcp
```

Choose a short stable name. It becomes the identifier you use when inspecting or removing the connection.

## Add a local command server

For a server started through a local executable:

```zsh
codex mcp add server-name -- command --flag value
```

Keep authentication in environment variables or the provider's supported login flow. Do not place raw tokens in a committed project configuration.

## Inspect the result

```zsh
codex mcp list
```

Start a fresh Codex task and ask it to list the tools exposed by the named server. Then run the smallest read-only operation the server supports.

Check four layers when a connection fails:

1. The server is installed or reachable.
2. The server is enabled in the active Codex profile.
3. Authentication is valid.
4. Workspace or organization policy allows the connection.

## Decide whether MCP is the right surface

Use MCP for live external data or actions. Use `AGENTS.md` for repository instructions and a skill for a reusable workflow. Keeping those responsibilities separate makes failures easier to diagnose.

Source: [Codex MCP configuration](https://learn.chatgpt.com/docs/extend/mcp)
