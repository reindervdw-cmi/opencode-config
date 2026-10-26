---
name: egm-brainstorm
description: Upstream EGM multi-lens concept exploration, human-gated shootdown and Concepts Brief. Use in the persistent Elephant session before drafting.
license: Apache-2.0
disable-model-invocation: true
---

# EGM Brainstorm

OpenCode adaptation of upstream `skills/egm_brainstorm/SKILL.md`; shared
resources and provenance are in `../egm-review/references/`.
Read `../egm-review/references/execution_instructions.md` first.

## Clarify the concept

1. Ask open-ended questions in plain chat, one at a time across turns, until
   problem, users, constraints, desired behavior, scope, edge cases, current
   approach and success measures are clear. Do not supply candidate answers
   or use multiple choice during exploration. Do not rush into delegation.
2. Anchor the hypothesis in 2–3 sentences. Ask whether to **Review with
   Goldfishes** or **Clarify additional constraints**. Wait for explicit
   readiness before spawning any reviewers.

## Parallel shootdown

Use the OpenCode `subagent` tool to dispatch a fresh `egm-synthesizer-brainstorm`
without sessionID, passing FeatureConcept, constraints,
any supplied baseline context, and the approved OutputFile for
`concepts_brief.md`. Honor `EGM artifact directory: <path>`; a relative
directory is relative to the working directory, not this skill.

The synthesizer launches six fresh Goldfish in parallel:

| Reviewer | Brainstorm lens |
| --- | --- |
| egm-goldfish-zoom-out-brainstorm | Contrarian/YAGNI and code minimization; search for reuse |
| egm-goldfish-design-brainstorm | Cost, quota, token economics, scale and bottlenecks |
| egm-goldfish-comprehension-brainstorm | UX, developer ergonomics and cognitive overhead |
| egm-goldfish-implementation-readiness-brainstorm | Migration, compatibility, rollout and rollback |
| egm-goldfish-codebase-details-brainstorm | Observability, telemetry, tracing and oncall debugging |
| egm-goldfish-structural-brainstorm | Long-term tech debt, coupling and maintainability |

For direct dispatch pass FeatureConcept, constraints and baseline context to
the same brainstorm-only IDs. Agent IDs
select the task; no role-selection argument is required. Do not dispatch the
`-review` agents for brainstorming.
`egm-goldfish-style-brainstorm` is an optional seventh lens for
objective framing and scope precision; dispatch it only when explicitly requested.

Wait for every reviewer before synthesis; incomplete reviews are reported,
not silently dropped. If nesting is unavailable, directly dispatch the six
fresh reviewers and write the brief yourself. If fresh-context delegation
is unavailable, stop: same-context review is not a Goldfish review.

The brief contains author/date, Overview, Analysis, Goals vs. Non-Goals,
and Key Decisions & Staging for Next Steps. Preserve objections and unresolved
decisions rather than deciding them for the human. Write it to the workspace
or approved artifact directory, never dump it in chat.

## Refine and hand off

Link the brief and highlight 2–3 objections or open risks. Ask how to address
them. Repeat clarification/shootdown as needed until the human agrees.
After final brief approval, offer one next-step choice:

- Publish the brief as an RFC at the approved `docs/designs/<feature>.md`;
  update `docs/designs/SITEMAP.md` if it exists and that update is approved.
- Proceed to `egm-draft` in this session.
- Continue refinement.
- Keep the brief for later and conclude.

Publication means a document write, not a Git commit, push or PR.
