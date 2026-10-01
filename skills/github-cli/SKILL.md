---
name: github-cli
description: GitHub CLI (gh) scoped authentication, issue intake, related work, pull requests, reviewers, linking, and status reporting. Load when reading or writing GitHub issues or PRs.
---

# GitHub CLI Skill

## Context and Scope

Use repository instructions already supplied by OpenCode for host,
owner/repository, base branch, reviewers, and local policy. Ask for missing or
ambiguous values. Keep provider commands in this skill, not delivery prompts.
Use `git-workflow` for branch conventions.

Examples use task-local `HOST`, `OWNER`, `REPOSITORY`, `ISSUE_NUMBER`, and
`PR_NUMBER`. Set `REPO="$HOST/$OWNER/$REPOSITORY"` from confirmed context. Pass
`--repo "$REPO"` (`HOST/OWNER/REPO`) on repository commands. Auth uses
`--hostname "$HOST"`; raw API uses explicit hostname and repository path.
If needed, prefix a command with `GH_HOST="$HOST"` rather than changing persistent
defaults. Never rely on current directory, default host, or global `gh config`.

Intake is read-only. Authentication changes and external writes require approval.
Preserve stderr and exit status; no `2>/dev/null`, `|| true`, or failure-masking
filters. Prefer `--json` where supported; creation/comment commands may return
URLs instead. Missing CLI, permissions, or network is a verification limit, not
empty results or a reason for indefinite investigation.

## Scoped Authentication

Reuse approved existing credentials. Inspect selected host without revealing
tokens (`--show-token` and `gh auth token` are not inspection defaults):

```bash
gh auth status --hostname "$HOST"
```

Auth status checks may need network. It is read-only but permission fragments
may still require approval: ask manager when denied, do not bypass policy.
Login/refresh/logout/switch/config writes must remain ask-gated.

For headless sessions, prefer approved manager-provided environment credentials
restricted to required repositories and permissions: `GH_TOKEN` for github.com,
`GH_ENTERPRISE_TOKEN` for enterprise hosts. Use confirmed host scope; environment
credentials take precedence over stored credentials. Never print/echo tokens,
write them to files, or pass them as command arguments. A fine-grained token's
repository restrictions differ from CLI interactive login's OAuth scopes.

Interactive `gh auth login --web` is not repository-scoped. Baseline requested
OAuth scopes are `repo`, `read:org`, and `gist`; `--scopes` adds scopes rather than
narrowing that baseline. Installed login help also documents these as minimum
scopes for classic tokens supplied via `--with-token`; do not use that login path
to persist narrowly scoped environment credentials.

Login persists credentials in system credential store/keyring. If unavailable
or failing, CLI falls back to a plaintext credential file; `--insecure-storage`
explicitly forces plaintext. Before any login, explain host, requested scopes,
credential persistence, and plaintext fallback, then obtain explicit approval.
If storage risk is unacceptable, use approved environment credentials instead.
Never expand scopes or refresh permissions automatically; ask for separate
approval for additional rights. Only after login approval:

```bash
gh auth login --hostname "$HOST" --web
```

This is interactive device/browser authentication, not unattended verification;
user must complete it. Reuse resulting credentials; do not log in per command.
Do not assume repository auth grants organization/team access or Projects rights.

## Issue Intake, Comments, and Related Work

```bash
gh issue view "$ISSUE_NUMBER" --repo "$REPO" --comments
gh issue view "$ISSUE_NUMBER" --repo "$REPO" \
  --json number,title,body,state,url,labels,assignees,milestone,comments
gh issue list --repo "$REPO" --state all --search "$RELATED_TERMS" \
  --limit 100 --json number,title,state,url
gh pr list --repo "$REPO" --state all --search "$RELATED_TERMS" \
  --limit 100 --json number,title,state,url,headRefName,baseRefName
```

Read issue body, acceptance criteria, comments, labels, assignees, milestones,
and linked issues/PRs. Follow references with explicit repository scope,
including cross-repository work. Search before creating duplicates; search
results are candidates, not proof of a relationship. Report limits/truncation
and distinguish absent comments from unavailable/incomplete context.

For full API-only context or paginated comments, manager/API-authorized role can
read using explicit GET (adding fields otherwise defaults to POST):

```bash
gh api --hostname "$HOST" --method GET \
  "repos/$OWNER/$REPOSITORY/issues/$ISSUE_NUMBER/comments" --paginate
```

`gh api` has no `--repo`; do not infer scope from placeholders/current directory.
Read-only triage/researcher roles lack raw API permission even for GET. Require
manager to supply missing comments, timeline/relationships, and pagination
coverage. Report gap; never silently discard context or bypass denial.

## Issue Writes (Approval Required)

```bash
gh issue create --repo "$REPO" --title "$TITLE" --body "$ISSUE_BODY"
gh issue edit "$ISSUE_NUMBER" --repo "$REPO" --title "$TITLE" --body "$ISSUE_BODY"
gh issue comment "$ISSUE_NUMBER" --repo "$REPO" --body "$STATUS_BODY"
```

Bodies support Markdown. Use `--body-file` with an authorized prepared file for
long bodies; no implicit file-writing permission. Read before replacing body.
Confirm existing labels, assignees, and milestone before setting them. GitHub
issues do not share Azure custom fields/process states; do not invent equivalents.
No GitHub Projects assumption, project scope refresh, or board/status mutation.
Projects require explicit task intent, known project context, and approval.

## Pull Requests, Reviewers, and Linking (Writes Require Approval)

Confirm authorized pushed head, base, reviewers, and existing PR. Explicit head
avoids implicit fork/push prompts:

```bash
gh pr list --repo "$REPO" --head "$BRANCH" --state all \
  --json number,url,state,headRefName,baseRefName
gh pr create --repo "$REPO" --head "$BRANCH" --base "$BASE" \
  --title "$TITLE" --body "$PR_BODY" --reviewer "$REVIEWER"
gh pr edit "$PR_NUMBER" --repo "$REPO" --title "$TITLE" --body "$PR_BODY"
gh pr edit "$PR_NUMBER" --repo "$REPO" --add-reviewer "$REVIEWER"
```

Reviewers are GitHub logins or confirmed `organization/team` handles, not email
addresses. Reviewer assignment differs from assignee assignment. For forks,
confirm supported `owner:branch` head syntax and repository permissions first.

Use non-closing references such as `Related to #123` or a full issue URL in PR
body; post PR URL on issue only with approval. Cross-repository references must
include owner/repository or full URL. References are traceable links, not proof
of a formal blocking/parent/Projects relationship. Never insert `Fixes`,
`Closes`, or `Resolves` closing keywords unless issue closure was explicitly
requested. Do not automatically close/reopen issues, enable auto-merge, merge,
delete branches, or update global state.

## Status Reporting

```bash
gh issue view "$ISSUE_NUMBER" --repo "$REPO" --json number,url,state
gh pr view "$PR_NUMBER" --repo "$REPO" --comments
gh pr view "$PR_NUMBER" --repo "$REPO" \
  --json number,url,state,isDraft,reviewRequests,reviewDecision,statusCheckRollup
gh pr checks "$PR_NUMBER" --repo "$REPO"
```

Report host/repository, issue and related-work URLs, comments coverage/gaps,
PR URL and actual state, requested reviewers, linkage method, checks, and
verification limits. Preserve nonzero checks status; distinguish pending,
failed, and unavailable checks from success. Posting progress comments is an
approved write, not part of read-only reporting.

## Example Verification

Review installed `gh <command> --help` and supported JSON fields before use;
help requires no live mutations. References: https://cli.github.com/manual and
https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue
CLI/server versions may differ. If help/docs/network is unavailable or blocked,
report specific unverified details and continue bounded documentation review;
never install, authenticate, or mutate live resources just to validate examples.
