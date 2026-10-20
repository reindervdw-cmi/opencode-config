# Repository guide

## Style
- Keep changes small and focused; preserve unrelated work.
- Match surrounding CUE formatting and use `package opencode`.
- Define agents in `cue/agent-<name>.cue` with matching kebab-case agent IDs.
- Keep prompts direct and concise, with explicit scope, permissions, and output contracts.
- Put shared prompt text in `cue/lib-protocol.cue` and permission fragments in `cue/lib-permissions.cue`; reuse existing helpers.
- Preserve permission rule order and duplicate patterns: last matching rule wins. Start shell compositions with `_denyAll`.
- Keep provider CLI recipes in their skills, not duplicated in agent prompts.
- Explain intent in comments, not obvious mechanics. Avoid speculative abstractions.

## Configuration workflow
- Treat `cue/` as the configuration source; do not hand-edit generated `opencode.json`.
- After CUE changes, run `just validate`, then `just build`; include the regenerated artifact.
- Keep README instructions consistent with changed agent behavior.
- Report verification commands and actual failures; never claim unrun tests passed.
