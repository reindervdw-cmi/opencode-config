# OpenCode team workflows

Internal OpenCode configuration using our LiteLLM service.

## Setup

Place this repository in `~/.config/opencode/` (back up any existing configuration first). Connect to the configured LiteLLM provider through OpenCode's `/connect` command.

For GitHub work, install and authenticate `gh`. For Azure DevOps, use Azure CLI with the `azure-devops` extension.

Run OpenCode from the project you want to work on. Restart OpenCode after changing this configuration.

## Interactive: discuss, plan, then implement

```sh
opencode --agent interactive-architect
```

Describe the change you want. The architect explores the codebase, asks questions, and proposes a plan. You choose the branch or worktree and approve the plan before implementation.

When ready, say:

> Execute this approved plan using interactive-coordinator.

The coordinator delegates implementation and testing to developers, arranges an independent review, and reports the results. Commits, pushes, and PRs follow your instructions.

You can also run these agents directly:

```sh
opencode --agent review-orchestrator        # Review a change
opencode --agent interactive-scrum-master   # Manage Azure DevOps or GitHub tickets
```

## Review agents

`review-orchestrator` coordinates one rule scanner and two independent bug scans. Per-issue validation runs only for candidate findings before they enter the final report. This first version is local-first and terminal-only; it does not write PR comments.

For local review, provide the intended change, plan/Definitions of Done, baseline, and assigned paths. Include staged, unstaged, and untracked implementation changes explicitly; exclude unrelated user edits. Missing or ambiguous context is reported as `AWAITING_CLARIFICATION` or `UNVERIFIABLE`, not approval.

For PR review, provide the PR URL and authorize reads through the appropriate `github-cli` or `ado-cli` skill. Remote access is not assumed, branches are not fetched automatically, and missing local refs or inaccessible context are escalated rather than silently omitted. Results stay in the terminal; no comment writes.

## Updating the configuration

Edit `cue/`, then regenerate `opencode.json` using CUE and `just`:

```sh
just validate
just build
```

Skills live in `skills/`; custom tools live in `tools/`.
