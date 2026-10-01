---
name: ado-cli
description: Azure DevOps CLI (az boards / az repos / az devops) conventions and known pitfalls. Load when reading or writing ADO work items, querying PRs, or linking work items to pull requests.
---

# Azure DevOps CLI Skill

## Context and Scope

Use repository instructions already supplied by OpenCode for organization,
project, repository, tenant, process, base branch, and reviewer context. Ask for
missing or ambiguous values; never copy fixed organization/project/storage
settings. Supplied context does not authorize changing persistent CLI defaults.
Keep provider commands here, not in delivery prompts. Use `git-workflow` for
branch conventions.

Examples use task-local shell variables: `ORG` (organization URL), `PROJECT`,
`REPOSITORY` (name or ID), `TENANT`, `ITEM_ID`, and `PR_ID`. Supply explicit
`--organization`, `--project`, and `--repository` wherever supported, with
`--detect false` to avoid implicit Git/default context. ID-based commands often
accept only organization: validate returned project/repository before writes.
Do not run `az devops configure`, `az account set`, or global config changes as
setup. Auth and externally visible writes require approval; intake is read-only.

Preserve stderr and exit status. Prefer JSON output; no `2>/dev/null`, `|| true`,
or output-filtering pipelines that hide failures. If piping is necessary, use
`set -o pipefail` and retain diagnostics. Report permission/network/CLI failures
as verification limits, not empty results; do not investigate indefinitely.

## Scoped, Reusable Authentication

Reuse existing credentials first. Cached account metadata is an inspection,
not proof of Azure DevOps access; a scoped intake read verifies access.

```bash
az account show --output json
```

If login is needed, ask manager/user for approval and tenant, then use device
code in headless sessions. Never trigger bare browser-based `az login` or log
tokens. Reuse resulting cache across calls; do not log in per command.

```bash
az login --tenant "$TENANT" --use-device-code --allow-no-subscriptions --output none
```

Existing approved PAT/environment auth may be reused; do not request broader
permissions or change credential storage without approval. Device-code login
does not grant missing organization/project rights. Read-only agents must ask
manager to handle login rather than bypass auth permissions.

## Issue Intake, Comments, and Related Work

```bash
az boards work-item show --id "$ITEM_ID" --organization "$ORG" \
  --detect false --expand all --output json
az boards work-item relation show --id "$ITEM_ID" --organization "$ORG" \
  --detect false --output json
az boards query --organization "$ORG" --project "$PROJECT" --detect false \
  --wiql "$WIQL" --output json
```

Read description, acceptance criteria, Bug repro steps when present, assignment,
state, parent/children, dependencies, duplicates, and linked PRs. Fetch relevant
linked items with `work-item show`. Construct scoped WIQL from confirmed context
(including `System.TeamProject`); CLI supports flat queries only. Search related
work before creating duplicates and report query scope/limits.

Comments are separate from `work-item show` and history fields. Manager or an
API-authorized role retrieves them with explicit GET:

```bash
az devops invoke --organization "$ORG" --detect false \
  --area wit --resource comments --http-method GET \
  --route-parameters "project=$PROJECT" "workItemId=$ITEM_ID" \
  --api-version 7.1-preview.4 --output json
```

Follow returned `continuationToken` using
`--query-parameters "continuationToken=$CONTINUATION_TOKEN"` until exhausted.
Read-only triage/researcher roles lack raw API permission even for GET: require
manager to supply comments, pagination completeness, and other missing API-only
context (such as process metadata). Report gaps explicitly; never silently
discard comments, infer absence, or route around permission denial.

## Supported Flags and Work Item Writes (Approval Required)

- `work-item show` has no `--project`. `boards query` supports `--project`;
  both support global `--query` for JMESPath output filtering, not WIQL input.
- Relation inspection is `relation show`, not `relation list`; `list-type`
  lists supported relation types, not an item's links.
- `work-item create` has no `--parent` or `--priority`. Add parent separately;
  set confirmed priority field via `--fields "Microsoft.VSTS.Common.Priority=2"`.
- `--fields` takes quoted `field=value` pairs, not inline JSON.
- Work item descriptions render HTML, not Markdown. Use `<p>`, `<br>`, lists,
  and HTML-escaped user text. Do not URL-encode line breaks as `%0D%0A`.
  PR descriptions, unlike work item descriptions, accept Markdown.
- `Custom.WorkType` is process-specific, not universally required for User
  Stories. Supply only if confirmed required, using allowed values.
- Bugs may require `Microsoft.VSTS.TCM.ReproSteps` (HTML). Confirm process/type
  rules before setting this or other custom/required fields. `TF401320` signals
  validation failure; inspect diagnostics rather than guessing field values.
- State names depend on process/type. Confirm allowed states via local context
  or manager-supplied metadata; never assume `In Review`/`Resolved`/`Closed`.

```bash
az boards work-item create --organization "$ORG" --project "$PROJECT" \
  --detect false --type "$ITEM_TYPE" --title "$TITLE" \
  --description "$DESCRIPTION_HTML" --output json
az boards work-item relation add --id "$CHILD_ID" --relation-type parent \
  --target-id "$PARENT_ID" --organization "$ORG" --detect false --output json
az boards work-item update --id "$ITEM_ID" --state "$CONFIRMED_STATE" \
  --organization "$ORG" --detect false --output json
```

Other confirmed relation types can link related/duplicate work. Re-read results
after writes. Do not automatically change state, close work, or create fields.

## Pull Requests (Writes Require Approval)

Source branch must already be pushed with authorization. Confirm base branch,
repository, reviewers, and existing PR before creating another:

```bash
az repos pr list --organization "$ORG" --project "$PROJECT" \
  --repository "$REPOSITORY" --detect false --source-branch "$BRANCH" \
  --status all --output json
az repos pr create --organization "$ORG" --project "$PROJECT" \
  --repository "$REPOSITORY" --detect false --source-branch "$BRANCH" \
  --target-branch "$BASE" --title "$TITLE" --description "$PR_BODY" \
  --work-items "$ITEM_ID" --transition-work-items false \
  --auto-complete false --output json
az repos pr update --id "$PR_ID" --organization "$ORG" --detect false \
  --title "$TITLE" --description "$PR_BODY" --output json
az repos pr reviewer add --id "$PR_ID" --reviewers "$REVIEWER" \
  --organization "$ORG" --detect false --output json
az repos pr work-item add --id "$PR_ID" --work-items "$ITEM_ID" \
  --organization "$ORG" --detect false --output json
```

Use dedicated `az repos pr update` for existing PR metadata, not generic API or
`work-item update`. Add reviewers explicitly; use `--required true` only when
requested. Prefer `--work-items` / `pr work-item add` for durable linking;
`AB#<ID>` is a reference, not proof of successful association. If raw artifact
linking is necessary, PR artifact URI differs from web URL; ask manager for
context rather than constructing an unverified URI.

Squash, branch deletion, auto-completion, policy bypass, completion, and work
item transitions are separate policy decisions, never automatic defaults.

## Status Reporting

```bash
az repos pr show --id "$PR_ID" --organization "$ORG" --detect false --output json
az repos pr policy list --id "$PR_ID" --organization "$ORG" --detect false --output json
```

Report organization/project/repository, item IDs/URLs, related work, comments
coverage/gaps, PR ID/URL and actual state, reviewers, verified links, checks,
and verification limits. Do not claim checks passed or writes succeeded without
evidence. Approved progress comments can use `work-item update --discussion`
with explicit organization/detection scope; API comments require manager/API
permission. Posting status is a write, not part of read-only reporting.

## Example Verification

Review installed `--help` before execution; help requires no live mutations.
Azure CLI help confirms command flags, not server process rules or API routing.
Comments list reference: https://learn.microsoft.com/en-us/rest/api/azure/devops/wit/comments/get-comments?view=azure-devops-rest-7.1
uses `7.1-preview.4`; confirm deployed API/resource compatibility where possible.
Unavailable CLI/docs/network or denied permissions are bounded verification
limits: label unverified details and ask manager for missing context.
