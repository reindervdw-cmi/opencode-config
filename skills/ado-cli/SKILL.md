---
name: ado-cli
description: Azure DevOps CLI (az boards / az repos / az devops) conventions and known pitfalls. Load when reading or writing ADO work items, querying PRs, or linking work items to pull requests.
---

# Azure DevOps CLI Skill

Operational knowledge for `az boards`, `az repos`, and `az devops`. These are
pitfalls that cost a failed command to discover; they are not in `--help`.

## Before Anything

Check the repo root for an `AGENTS.md`. When present it is the authority on
org/project defaults and documented CLI corrections — read it first, and if you
hit a new pitfall, add a numbered entry to its "Common Mistakes & Corrections"
section so the next run does not rediscover it.

Set defaults once per session instead of passing `--organization` and
`--project` on every call:

```bash
az devops configure --defaults organization=https://dev.azure.com/<org> project=<project>
```

## Authentication

Agent sessions are headless. Always:

```bash
az login --use-device-code
```

Never bare `az login` — it opens a browser and hangs the session. Verify an
existing session cheaply with `az account show`.

## Reading Work Items

```bash
az boards work-item show --id <ID>
az boards work-item relation list --id <ID>    # linked items and PRs
```

Comments are not exposed by `work-item show`. They require the REST API:

```bash
az devops invoke \
  --area wit --resource comments \
  --route-parameters project=<project> workItemId=<ID> \
  --api-version 7.0-preview.3
```

## Creating Work Items

```bash
az boards work-item create --title "<title>" --type <Bug|Task|User Story|Feature>
```

Pitfalls:

1. **`User Story` requires a work-type field.** Without it creation fails with
   `TF401320`. Pass `--fields "Custom.WorkType=feature development"` (or the
   correct value for maintenance work).
2. **No `--parent` flag on `create`.** Parenting is always two steps: create the
   item, then add the relation.
3. **Line breaks in `--description`** must be URL-encoded as `%0D%0A` when
   passed as a single CLI string. For long or structured descriptions prefer
   inline JSON via `--fields` to avoid quoting problems.
4. **Descriptions render as HTML.** Markdown will not format. Use `<br>`, `<b>`,
   and `<ul><li>` if you need structure.

## Linking

```bash
az boards work-item relation add --id <child> --relation-type parent --target-id <parent>
```

Common `--relation-type` values: `parent`, `child`, `related`, `duplicate`.

Attach a pull request to a work item using the `artifact-link` relation; the
target is the PR's artifact URI, not its web URL.

## Updating State

```bash
az boards work-item update --id <ID> --state "In Review"
```

State names are process-specific and validated server-side. An invalid value
fails the command, so confirm the board's actual states rather than assuming
`Active` / `Resolved` / `Closed` exist.

## Pull Requests

```bash
az repos pr create --source-branch <branch> --target-branch <base> \
  --title "<title>" --description "<desc>"
az repos pr list --status active
az repos pr reviewer add --id <PR-ID> --reviewers <email>
```

- `--source-branch` must already be pushed. Creating a PR from a local-only
  branch fails.
- Reference the work item ID in the PR title or description (`AB#1234`) so ADO
  links them automatically.
- `--squash` and `--delete-source-branch` are set at creation or via
  `az repos pr update`.

## Work Item URLs

```
https://dev.azure.com/<org>/<project>/_workitems/edit/<ID>
```

## General

- Add `--output json` and parse, rather than scraping table output.
- Never invent a work item ID, field name, or state. If a value is unknown,
  query for it or ask.
