---
name: coding-standards
description: Language-agnostic coding quality principles. Load when writing code or reviewing code for quality.
---

# Coding Standards

## Simplicity First

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- If 200 lines could be 50, it should be 50.
- Prefer small, focused functions/methods that do one thing well.

## Surgical Changes

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If unrelated dead code or tech debt is noticed, **flag it** — don't silently delete it.

When changes create orphans:

- Remove imports/variables/functions that the changes made unused.
- Don't remove pre-existing dead code unless that is the assigned task.

## Naming & Readability

- Use clear, descriptive names for variables, functions, types, and files.
- Avoid abbreviations unless universally understood (e.g., `id`, `url`, `http`).
- Code should read as close to prose as possible.
- Comments should explain **why**, not **what**; avoid inline comments unless truly necessary.

## Type Safety & Error Handling

- Handle errors explicitly.
- Fail fast and fail loudly.
