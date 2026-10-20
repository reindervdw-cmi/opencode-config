# OpenCode team workflows

Internal OpenCode configuration using our LiteLLM service.

## Setup

Place this repository in `~/.config/opencode/` (back up any existing configuration first). Connect to the configured LiteLLM provider through OpenCode's `/connect` command.

For GitHub work, install and authenticate `gh`. For Azure DevOps, use Azure CLI with the `azure-devops` extension.

Run OpenCode from the project you want to work on. Restart OpenCode after changing this configuration.

## Usage

```sh
opencode --agent interactive-architect
```

Describe your change, choose a branch or worktree, and approve the architect's plan. Then say:

> Execute this approved plan using interactive-coordinator.

Coordinator delegates implementation and testing, then arranges independent review. Commits, pushes, and PRs require your authorization.

```sh
opencode --agent review-orchestrator        # Review a change
opencode --agent interactive-scrum-master   # Manage Azure DevOps or GitHub tickets
opencode --agent agent-examiner             # Understand and quiz yourself on branch changes
```

For review, provide intent, baseline, paths, and Definition of Done; explicitly include any uncommitted changes. For PR review, supply the URL and authorize forge reads. Results stay in the terminal.

## Maintenance

Requires `just` and CUE for configuration; D2 with the TALA layout engine available (`d2 layout tala`) for diagrams. If your D2 distribution needs an external plugin, put `d2plugin-tala` on PATH.

Edit `cue/`, not generated `opencode.json`. Rebuild configuration or edit `agents.d2` and regenerate its SVG:

```sh
just validate
just build
just diagram
```

Skills live in `skills/`; custom tools live in `tools/`.
