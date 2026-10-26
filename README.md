# OpenCode team workflows

Internal OpenCode configuration using our LiteLLM service.

## Setup

Place this repository in `~/.config/opencode/` (back up any existing configuration first). Connect to the configured LiteLLM provider through OpenCode's `/connect` command.

For GitHub work, install and authenticate `gh`. For Azure DevOps, use Azure CLI with the `azure-devops` extension.

## Usage

Open OpenCode from your project's directory:

```sh
opencode
```

### Make a change

Select **architect**. Describe the feature or bug, answer clarifying questions, and choose a branch or worktree when asked. Review and approve the proposed plan, then say **Execute**.

### Design first

Select **egm-elephant**. Describe your idea or provide the path to an existing design. Ask to brainstorm, draft a design, or review it. Answer questions and approve document changes as you go.

When ready, approve the reviewed implementation plan and ask to hand it off for execution.

In either workflow, commits, pushes, and pull requests require your explicit authorization.

### Run in Docker

With Docker Compose installed, open this configuration repository:

1. Create `.env` from [`.env.example`](.env.example) if it does not already exist. Set `HOME` to your home directory and choose a server password instead of the example value.
2. Keep your projects in `~/repositories`, or update the project mount in [`compose.yaml`](compose.yaml).
3. Start the server:

```sh
docker compose up -d --build
```

From your project's directory, connect using the password from `.env`:

```sh
OPENCODE_PASSWORD='<your server password>' opencode --server http://127.0.0.1:49374
```

Select **architect** or **egm-elephant** in OpenCode as described above. To stop the server, run `docker compose down` from this configuration repository.

## Maintenance

For configuration maintainers: install `just` and CUE, edit `cue/` rather than generated `opencode.json`, then run:

```sh
just validate
just build
```

Include the regenerated `opencode.json` with configuration changes.
