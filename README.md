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
opencode --agent interactive-reviewer       # Review a change
opencode --agent interactive-scrum-master   # Manage Azure DevOps or GitHub tickets
```

## Delivery: take an issue through implementation to a PR

```sh
opencode --agent delivery-program-manager
```

Provide a GitHub issue or Azure DevOps work-item URL and the target branch, for example:

> Implement https://github.com/OWNER/REPO/issues/123 against main.

> Implement https://dev.azure.com/ORG/PROJECT/_workitems/edit/123 in this repository against main.

The program manager coordinates triage, research, planning, implementation, QA, and independent review, then handles approved commits, push, and PR creation. It asks when repository context is ambiguous or an operation needs approval. Start with a clean working tree.

Azure DevOps and GitHub commands are handled through provider-specific skills. Supporting agents are dispatched automatically. Issues stay open and PRs are not merged automatically.

## Updating the configuration

Edit `cue/`, then regenerate `opencode.json` using CUE and `just`:

```sh
just validate
just build
```

Skills live in `skills/`; custom tools live in `tools/`.
