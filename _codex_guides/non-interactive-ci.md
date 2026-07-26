---
title: "Run Codex Non-Interactively in CI with codex exec"
short_title: "Codex in CI"
description: "Use codex exec in an automated job with an isolated state directory, an explicit sandbox, and observable verification."
date: 2026-07-26
last_modified_at: 2026-07-26
intent: "Automate Codex in CI"
category: "Automation"
level: "Advanced"
tested_on: "Codex CLI"
time: "15 minutes"
field_note: "Automation needs an explicit checkout, isolated state, narrow permissions, and captured output."
slug: non-interactive-ci
keywords: [codex exec, Codex CI, Codex automation, non-interactive Codex]
related: [sandbox-approvals, agents-md, codex-home]
---

## Start with a bounded local command

`codex exec` runs a prompt non-interactively:

```zsh
codex exec "Review the current diff and report correctness risks. Do not edit files."
```

Make the prompt state the scope, expected output, edit permission, and verification requirement.

## Isolate CI state

Give every job a dedicated `CODEX_HOME`:

```zsh
export CODEX_HOME="${RUNNER_TEMP}/codex-home"
mkdir -p "$CODEX_HOME"

codex exec \
  --sandbox workspace-write \
  "Run the documented test suite, fix only failures caused by the current change, and report every command and result."
```

Do not reuse a developer's local Codex directory in CI.

## Make the repository self-describing

Commit an `AGENTS.md` with supported setup and verification commands. The automated prompt can then refer to the repository's documented gate instead of duplicating a fragile command list.

## CI safety checklist

- Pin the checkout to the intended commit.
- Grant only the sandbox access the job requires.
- Provide secrets through the CI secret store.
- Never print authentication files or tokens.
- Capture exit status, stdout, stderr, diffs, and test output.
- Fail the job when required verification fails.
- Review generated changes before merging.

## Verify the workflow

Run the job against a disposable branch with one known failing test. Confirm that the logs show the failure, any scoped edit, the rerun, and the final diff. A green exit without that evidence is not enough.

Source: [Codex non-interactive mode](https://learn.chatgpt.com/docs/non-interactive-mode)
