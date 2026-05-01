---
name: git-workflow
description: Git branching, commit, worktree, and PR conventions for OpenCode agents. Load when planning branches, making commits, or creating PRs.
---

# Git Workflow Skill

## Branch Naming

- Feature: `feat/<short-description>`
- Bug fix: `fix/<short-description>`
- Always lowercase-hyphenated. No underscores, no camelCase.

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
