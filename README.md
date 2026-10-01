# Internal OpenCode configuration

**Confidential — internal use only.** Contains internal workflow instructions and
service routing. Do not publish publicly, enable automatic session sharing, or
distribute conversation data. This wording is not a license or a grant of
redistribution rights. Publication remains blocked by the checks below.

## Source of truth and toolchain

`cue/*.cue` is source of truth for agents, permissions, prompts, models, and
provider configuration. `opencode.json` is generated output: never edit it to
make a persistent change. `tools/` contains custom tool artifacts; `skills/`
contains skill directories, each with `SKILL.md`. Both are installation
inputs, not optional copies of documentation.

| Component | Version / support boundary |
| --- | --- |
| OpenCode | CLI 1.18.33 passed isolated agent/skill loading smoke; full runtime compatibility remains unverified. |
| Node.js | `^22.22.2 \|\| ^24.15.0 \|\| >=26.0.0`, matching locked `ini@7.0.0`; prefer Node 24.15+ LTS. |
| npm | 11+, lockfile v3. Use `npm ci`, not unlocked installation. |
| Plugin API | `@opencode-ai/plugin` **1.17.8**, with SDK 1.17.8; do not upgrade implicitly to match CLI version. |
| CUE | Tested baseline `v0.14.2`; validation, export, and regression tests passed. |
| just | `1.21` tested; validation, build, test, and isolated clean recipes passed. |
| Shell / platform | Linux with POSIX shell; other platforms not verified. |

Install CUE from an approved, versioned upstream binary, or use
`go install cuelang.org/go/cmd/cue@v0.14.2` with an upstream-supported Go version.
Put that binary on `PATH`, then check `cue version`. When multiple CUE binaries
exist, select the intended one via `PATH` or the `CUE` environment variable; do
not silently use an unrelated installation:

```sh
CUE=/absolute/path/to/cue just build
```

The same verified shell environment override applies to validation and tests:

```sh
CUE=/absolute/path/to/cue just validate
CUE=/absolute/path/to/cue just test
```

### Build interface

Run from checkout root after installing the prerequisites above:

```sh
npm ci --ignore-scripts --no-audit --no-fund
just validate
just build
just test
```

| Command | Purpose |
| --- | --- |
| `just validate` | Vet the CUE configuration. |
| `just build` | Export CUE to generated `opencode.json`. |
| `just test` | Check existing generated output against fresh CUE export and run static configuration/prompt-contract tests; does not rebuild or execute models. |
| `just clean` | Remove generated `opencode.json`; run `just build` to recreate it. |

```sh
just clean
```

Ignoring dependency install scripts avoids executing optional native build hooks;
keep this setting unless an approved runtime test demonstrates a need for them.
Build only in a separate checkout/staging directory, not over a live personal
configuration; `just clean` likewise removes generated output, not personal data.
Review generated changes, especially permission rule ordering.
CUE validation alone does not prove compatibility with OpenCode's config schema
or provider connectivity.

## Clean-checkout installation without replacing personal configuration

1. Obtain a clean checkout of the approved internal revision in a separate
   directory. Do not clone into an existing `~/.config/opencode` directory.
2. Check versions above, install locked dependencies, validate, and build using
   the commands above. No LiteLLM credential is needed for this build.
3. Choose a fresh, private configuration directory, e.g.
   `$HOME/.config/opencode-internal`. Stop if it already contains personal files.
   Copy generated `opencode.json`, **all seven `tools/*.ts` files**, **the entire
   `skills/` tree**, `package.json`, and `package-lock.json` into it. Do not copy
   `.git/`, `node_modules/`, `context-mode/`, credentials, caches, or databases.
   Run the same `npm ci --ignore-scripts --no-audit --no-fund` inside that fresh
   directory so tools can resolve their plugin import locally.
4. Launch OpenCode against that directory:

   ```sh
   OPENCODE_CONFIG_DIR="$HOME/.config/opencode-internal" opencode --agent interactive-architect
   ```

   `OPENCODE_CONFIG_DIR` supplies custom tools and skills as well as config.
   Pointing only `OPENCODE_CONFIG` at a JSON file does not install those assets.
   OpenCode can also merge existing global and project configuration: inspect
   effective behavior before granting permissions. Use a disposable home/XDG
   environment for strict isolation; this directory choice is not a sandbox.
5. Quit and restart OpenCode after changing configuration, tools, or skills.
   Roll back by removing the launch override, not by overwriting personal files.

For deliberate global installation, back up and manually merge existing config,
tools, skills, and manifests first. Never replace a user's configuration tree
blindly. Personal overrides belong outside this checkout.

## LiteLLM authentication and defaults

Keep the `litellm` provider, internal base URL, three model IDs, and agent model
assignments defined in `cue/config.cue`. Session sharing remains `disabled`.
Do not substitute public provider defaults during installation.

Obtain an authorized LiteLLM key from the internal service owner. In OpenCode,
use `/connect`, select the configured LiteLLM provider (custom provider ID
`litellm` if prompted), and enter the key through its credential prompt. Do not
place a key in CUE, generated JSON, shell arguments, or this repository. If the
CLI does not offer this provider, stop and confirm that CLI's custom-provider
authentication procedure; do not fall back to a different provider.

OpenCode credentials normally live under `$XDG_DATA_HOME/opencode/auth.json`
(default `~/.local/share/opencode/auth.json`), separately from configuration.
Protect that file and exclude it from every bundle. Authentication and live
model requests remain unverified.

## Agent entry points and migration

Interactive planning: `opencode --agent interactive-architect`. Approve its plan
before handing execution to `interactive-coordinator` (also selectable with
`--agent`). `interactive-reviewer` and `interactive-scrum-master` are interactive
alternatives.

Both families support GitHub and Azure DevOps delivery; the family describes
orchestration style, not forge selection:

- **Interactive:** user-approved planning through `interactive-architect`, then
  developer/scout delegation and reviewer verification through
  `interactive-coordinator`. Source edits stay with developers; Git/forge writes
  require explicit authorization in the approved workflow.
- **Delivery:** `opencode --agent delivery-program-manager`, then provide a GitHub
  issue or Azure DevOps work-item URL, or an ID with explicit repository context.
  The manager orchestrates triage/research, architecture, developer execution,
  QA, and review. It owns Git history and approved external mutations; ownership
  does not itself authorize branches, commits, pushes, PRs, or issue writes.
  Start only with a clean, known target worktree.

Resolve forge, host, repository, Azure organization/project where applicable,
and exact target branch from already supplied repository context, policy, and
confirmed remote identity. Use `skills/github-cli/` with GitHub CLI (`gh`) for GitHub;
use `skills/ado-cli/` with Azure CLI and its `azure-devops` extension for Azure.
Install Git for repository workflows. Reuse approved scoped credentials and ask
before authentication changes; pass explicit scope rather than changing global
CLI defaults. GitHub Enterprise hosts require confirmed provider context.

Bare IDs, conflicting URLs/remotes, multiple repositories, unsupported hosts,
or missing scope trigger clarification (`AWAITING_CLARIFICATION`), not guesses
or probing IDs across providers. Neither family assumes a default base branch.
Branch policy follows `skills/git-workflow/` and already supplied repository policy:
`feature/<ticket-id>-<short-description>` or `fix/<ticket-id>-<short-description>`;
without a ticket, omit the ID. Use real IDs, lowercase hyphenated names, and
preserve assigned branch names. Issue closure, state changes, auto-merge, and
branch deletion remain separate authorization decisions.

Migration gives each agent family a descriptive prefix. These mappings cover
all six interactive roles and eight delivery roles; they are invocation renames,
not compatibility aliases.

| Old invocation | New invocation | Family |
| --- | --- | --- |
| `rv-architect` | `interactive-architect` | Interactive |
| `rv-coordinator` | `interactive-coordinator` | Interactive |
| `rv-developer` | `interactive-developer` | Interactive |
| `rv-reviewer` | `interactive-reviewer` | Interactive |
| `rv-scout` | `interactive-scout` | Interactive |
| `rv-scrum-master` | `interactive-scrum-master` | Interactive |
| `rvi-program-manager` | `delivery-program-manager` | Delivery |
| `rvi-triage` | `delivery-triage` | Delivery |
| `rvi-researcher` | `delivery-researcher` | Delivery |
| `rvi-architect` | `delivery-architect` | Delivery |
| `rvi-developer` | `delivery-developer` | Delivery |
| `rvi-qa` | `delivery-qa` | Delivery |
| `rvi-reviewer` | `delivery-reviewer` | Delivery |
| `rvi-scout` | `delivery-scout` | Delivery |

Six interactive roles and eight delivery roles exist; not every role is a
primary agent. Update saved CLI invocations, task dispatch names, and personal
overrides. There are no compatibility aliases in current CUE.

## Optional language servers and other workflow tools

Custom LSP tools spawn their own hard-coded server commands; they do **not** use
OpenCode's `lsp` configuration. Install only servers needed for target projects:

| Language | Required executable / invocation | Additional prerequisites |
| --- | --- | --- |
| Go | `gopls` | Go toolchain and target project's module dependencies |
| TypeScript / JavaScript | `typescript-language-server --stdio` | Node.js, TypeScript (`tsserver`), target project dependencies |
| Python | `ty server` | `ty` and target project's Python environment |
| Rust | `rust-analyzer` | Rust toolchain and target project dependencies |

Executables must be on OpenCode's `PATH`; versions are project-dependent and
not pinned or tested by this distribution. Separately, native OpenCode LSP config
enables `ty server` and `ruff server` for Python; install both or deliberately
disable unavailable native servers in a personal override. Ruff is not a server
used by these custom tools. See [tools/README.md](tools/README.md) for inventory,
prerequisites, provenance evidence, and unresolved redistribution/notice gates.
Skills can require additional tools only for their workflows: `uv`/pytest/ruff
for Python, `gh` for GitHub, and `graphify` for knowledge graphs. These are not
downloaded by `npm ci`; do not infer permission to install or redistribute them.

## Runtime exclusions and publication gates

Commit distribution inputs including `.gitignore`, both npm manifests, `justfile`,
configuration tests, CUE, generated config, tools, and skills. Ignore rules
exclude installed dependencies, `context-mode/`, local caches/logs/storage/sessions,
SQLite/database files and
sidecars, environment files, credential files, private keys, and personal config
overrides. Runtime data outside checkout (OpenCode data/cache/state directories,
shell history, cloud credential stores) must never be copied into a bundle.
Ignoring a path does **not** remove an already tracked file or historical blob.

Before internal publication, an authorized maintainer must:

- Verify manifests/ignore rules are tracked; review every tracked path for
  credentials, session exports, databases, and other runtime data.
- Scan all reachable Git history with an approved secret scanner and database
  path/blob review. Report
  paths/rule IDs and counts, never matched credential values or conversations.
- Resolve findings through security-approved rotation/remediation. Do not claim
  a new ignore rule cleans history.
- Document and resolve tool ownership, upstream versions, redistribution rights,
  and required notices; no project license has been invented.
- Run clean-checkout install/build/startup smoke tests with supported versions,
  both entry points, tools/skills discovery, and `just test`.

Distribution is **not publication-cleared**. Authorized tracked-file and reachable
Git-history audits remain publication gates; no claim is made that secrets or
history have been cleared. Bundled-tool provenance, redistribution rights, and
notices remain unresolved. Reviewer audit is pending.

## Verification evidence and limits

Completed checks used CUE **0.14.2** (installed temporarily with Go **1.25.6**),
just **1.21**, Node **24.13**, npm **11.17**, and OpenCode CLI **1.18.33**.
Install the approved CUE baseline as described above; the temporary test binary
is not an installation prerequisite.

- With the `CUE` environment override, `just validate` and `just build` passed;
  `just test` passed **19/19** checks. `just clean` passed in isolation.
- Static checks cover generated-output freshness, agent/model assignments,
  permissions, delegation topology, and provider-routing prompt contracts.
  They do **not** demonstrate real model routing, model execution, live forge
  operations, or provider connectivity.
- Isolated CLI smoke with fresh configuration and home/XDG directories loaded
  **all 14 agents** and both forge skills, **`github-cli` and `ado-cli`**.
  Locked dependency installation and plugin `tool` API import also passed.
  No global dependencies were installed.
- Detailed `debug agent` inspection timed out after **60 seconds**. Detailed
  custom-tool initialization, language-server startup, and tool execution remain
  unverified; agent/skill loading is not full runtime verification.
- Published-schema validation reported **14 model-enum errors only**, for the
  custom `litellm/` model IDs accepted by this CLI. Do not describe this as a
  clean published-schema validation or proof of working model requests.
- Node **24.13** is below locked `ini@7.0.0`'s declared support range
  (`^22.22.2 || ^24.15.0 || >=26.0.0`) and emitted `EBADENGINE` during installation.
  A supported-Node install/build/CLI smoke still needs verification, as do
  authentication, live model execution, and full runtime behavior.
