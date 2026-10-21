# Repository guide

## Style
- Keep changes small/focused; preserve unrelated work.
- Match CUE formatting; use `package opencode`.
- Define `cue/agent-<name>.cue` agents with matching kebab-case IDs.
- Use concise prompts with explicit scope, permissions, output contracts.
- Reuse helpers; shared prompts: `cue/lib-protocol.cue`; permission fragments: `cue/lib-permissions.cue`.
- Preserve permission order/duplicate patterns: last match wins. Start shell compositions with `_denyAll`.
- Keep provider CLI recipes in skills, not agent prompts.
- Comment intent, not obvious mechanics; avoid speculative abstractions.

## Configuration workflow
- Edit `cue/`, not generated `opencode.json`.
- After CUE changes: `just validate`, then `just build`; include regenerated artifact.
- Keep README consistent with agent behavior.
- Report verification commands/actual failures; never claim unrun tests passed.
