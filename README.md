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

> Execute.

Coordinator delegates implementation and testing, then arranges independent review. Commits, pushes, and PRs require your authorization.

### Docker Compose

Use [`compose.yaml`](compose.yaml) to run the OpenCode server in Docker for sandboxing. From this repository, create `.env` from `.env.example` if it does not already exist, and set `HOME` to your home directory:

```sh
docker compose up -d --build
```

The server listens at `http://127.0.0.1:49374`. The container mounts `~/repositories`, your OpenCode configuration and data, and the development caches listed in `compose.yaml`. You may need to modify the volume mounts for your personal setup.

You can then connect your OpenCode to the sandboxed server with

```sh
~/.opencode/bin/opencode --server http://127.0.0.1:49374
```

You may want to alias the above command to `opencode` in your shell configurations.

## Maintenance

Requires `just` and CUE for configuration.

Edit `cue/`, not generated `opencode.json`.

```sh
just build
```

Skills live in `skills/`.
