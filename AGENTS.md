# Repository guide

## Style
- Keep changes small/focused; preserve unrelated work.
- Match CUE formatting; use `package opencode` at root and package names matching imported directories.
- Define agents in `cue/<package>/agent-<name>.cue` with matching kebab-case IDs; standalone agents may remain at root.
- Use concise prompts with explicit scope, permissions, output contracts.
- Reuse helpers; shared prompts: `cue/shared/lib-protocol.cue`; permission fragments: `cue/shared/lib-permissions.cue`.
- Put values in `lib-*.cue` only when reused at least twice; keep single-use prompts and permission compositions in their owning agent file.
- Preserve permission order/duplicate patterns: last match wins. Start shell compositions with `_denyAll`.
- Keep provider CLI recipes in skills, not agent prompts.
- Comment intent, not obvious mechanics; avoid speculative abstractions.

## Configuration workflow
- Edit `cue/`, not generated `opencode.json`.
- After CUE changes: `just validate`, then `just build`; include regenerated artifact. If `just` is unavailable, run the exact inspected CUE recipe commands directly. If CUE is unavailable or denied, ask the engineer rather than bypassing restrictions.
- Keep README consistent with agent behavior.
- Report verification commands/actual failures; never claim unrun tests passed.
