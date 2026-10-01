---
name: git-workflow
description: Git branching, commit, worktree, and PR conventions for OpenCode agents. Load when planning branches, making commits, or creating PRs.
---

# Git Workflow Skill

## Branch Naming

- Use repository instructions already supplied by OpenCode for base branch and
  local conventions. Ask for missing or ambiguous context.
- Feature: `feature/<ticket-id>-<short-description>`
- Bug fix: `fix/<ticket-id>-<short-description>`
- Without a ticket: `feature/<short-description>` or `fix/<short-description>`.
- Use actual ticket/issue ID; never invent one. Preserve assigned branch name.
- Always lowercase-hyphenated. No underscores, no camelCase.
- Branch prefix `feature/` differs from conventional commit type `feat`.

## Authorization and Forge Operations

- Inspection first; create branches/worktrees, commit, push, or open/update PRs
  only within explicit task authorization. Do not change global Git/CLI config.
- Load `ado-cli` or `github-cli` for provider-specific authentication, intake,
  comments, PRs, reviewers, linking, and status commands. Keep those commands in
  forge skills rather than delivery prompts.
- Confirm target repository, base branch, and existing related PR. Do not assume
  issue closure, auto-merge, board state changes, or branch deletion is requested.

## Verification

- Follow consuming project's documented tooling and narrowest meaningful scope.
  Default to non-mutating lint, format checks, type checks, and tests; inspect
  scripts for fix/write, snapshot-update, install, and global-state side effects.
- Preserve stderr and exit status. No `|| true`, discarded diagnostics, or
  filtering pipelines that convert failures into success.
- Formatting/lint fixes require scoped implementation intent and owned paths;
  never repair unrelated baseline failures automatically.
- Broader pre-delivery suites are appropriate when required by local policy or
  cross-cutting risk, not a universal repo-wide command. Report baseline errors,
  checks run, scope, and blocked/unverified checks honestly.

## Commit Messages

Conventional commits format: `type(scope): description`

- **Types:** `feat`, `fix`, `refactor`, `test`, `docs`, `chore`
- Subject line under 72 chars. No trailing period.
- Scope is optional but preferred (e.g., `feat(auth): add OAuth2 flow`).
- **Checkpoint commits** (coordinator-created during task work): `checkpoint: <Task title(s)>`
- Body (optional): blank line after subject, wrap at 72 chars.

## Worktree Patterns

Use `git worktree` for parallel isolation — never juggle stashes across tasks.

Use worktrees when: working on multiple tasks simultaneously, testing a fix against a clean branch, or running long builds without blocking your main tree.
