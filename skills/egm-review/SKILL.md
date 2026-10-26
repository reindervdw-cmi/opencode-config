---
name: egm-review
description: Upstream EGM five-stage isolated review with interactive, uninterrupted, feature-only and implementation-only presets.
license: Apache-2.0
disable-model-invocation: true
---

# EGM Review

OpenCode adaptation of upstream `skills/egm_review/SKILL.md`.
Read `references/execution_instructions.md`. Shared standards are in
`references/document_standards/`; the blueprint is `references/design_doc.md`.
Resolve these to full paths for reviewers. Target/report paths belong to
the user's workspace, not this skill directory.

## Intake and presets

Require TargetFile; ask for a missing path in plain chat and wait. Read it.
Ask whether the human wants an optional GoldfishContext reading list unless
already provided or explicitly declined. Reviewers automatically read files
linked or explicitly mentioned in the design; baseline lists supplement this.

If Step is supplied, map it directly: `interactive`, `uninterrupted`,
`feature_spec`, `implementation`, or individual stage `5`, `6`, `7`, `8`, `9`.
Otherwise offer one single-select gate with these modes, in this order:

1. Interactive review with all rubrics, checkpoints after every stage.
2. Consolidated report with all rubrics, no inter-stage pauses.
3. Feature spec only, architecture without implementation readiness.
4. Implementation plan only, execution readiness.

## Semantic split

For feature-only mode, skip split discovery: FeatureRange is the full file,
DetailedRange is N/A, and run stages 5–8.
Otherwise locate `## Detailed Implementation Plan` or its synonyms
`## Implementation Plan`, `## Work Breakdown`, `## Implementation Steps`.
For an unambiguous header at line L, bind FeatureRange = 1..L-1,
DetailedRange = L..End; briefly confirm the ranges without an extra gate.
For an ambiguous split, ask one question offering the likely split or custom
ranges. If no implementation plan exists, offer feature-only stages 5–8;
do not claim implementation readiness. Re-read/rebind ranges after every edit.

## Stages

Use a fresh `egm-synthesizer-review` session without sessionID for each stage.
Pass TargetFile, current ranges, the exact reviewer IDs below,
reviewer-to-standard mapping, GoldfishContext and approved OutputFile.
Every reviewer also runs freshly without sessionID. Wait for all reviewers
and the written report before the next stage; parallelize only within a stage.
If nesting is unavailable, directly dispatch fresh reviewers and aggregate
their findings. If fresh delegation is unavailable, stop rather than substitute
a same-context Goldfish review. Failed/incomplete reviewers block completion.
For direct dispatch use the same review-only IDs and pass target, current scope,
standard and context. Agent IDs select document review; no role-selection
argument is required. Never dispatch -brainstorm agents for document review.

| Stage | Reviewers | Scope | Standard | Report |
| --- | --- | --- | --- | --- |
| 5 Initial zoom-out | egm-goldfish-zoom-out-review | Full file | zoom-out-standard.md | zoom_out_report.md |
| 6 Comprehension | egm-goldfish-comprehension-review | FeatureRange and DetailedRange | re-implementation-standard.md | comprehension_report.md |
| 7 Critic | egm-goldfish-design-review, egm-goldfish-structural-review, egm-goldfish-style-review | FeatureRange | feature-spec-standard.md for design/structural; blueprint for structural | critic_report.md |
| 8 Intermediate zoom-out | egm-goldfish-zoom-out-review | Full file | zoom-out-standard.md | intermediate_zoom_out_report.md |
| 9 Implementation readiness | egm-goldfish-implementation-readiness-review, egm-goldfish-codebase-details-review, egm-goldfish-style-review | DetailedRange | implementation-readiness-standard.md for readiness/codebase-details | implementation_readiness_report.md |

Stage 8 also receives the initial `zoom_out_report.md` path and focuses on
additions/mitigations from comprehension and critic review. Do not share other
prior/sibling conclusions with reviewers. Stage 9 demands an executable
zero-decision plan, not a design from which tasks might be derived.
Stages 7 and 9 use `egm-review-loop` in this Elephant session with the listed
configuration; no other persona IDs or rubric substitutions.

Interactive runs all five stages in order. Feature-only ends after stage 8.
Implementation-only runs stage 9. Individual-stage requests run that stage
with its required scope/context, asking for a missing stage-8 baseline.

## Checkpoints, resolution and resume

Stages 5, 6, 8: offer proceed, update doc first, or pause.
Stages 7, 9: offer proceed, resolve findings with agent, update manually, or
pause. Terminal proceed concludes review (feature-only: begin implementation
planning, not implementation). Ask exactly one question and yield immediately.

For agent resolution load `egm-resolve` in the persistent Elephant session
with TargetFile, active range and report findings. Apply only approved edits,
re-read the target and recalculate ranges, then advance or re-audit the stage.
For manual edits, wait for the human's completion notice and re-audit.
Upstream's stage convergence cap is one re-audit: after it is exhausted,
record residual findings as trade-offs and advance without another audit.
Do not turn residual findings into a clean pass or execution authorization.
Pause halts without further tools, preserving reports; read them on resume.

## Uninterrupted mode

Run all five stages sequentially without checkpoint pauses, preserving the
same dependencies and writing every report. Do not apply unapproved fixes.
Collect all findings, prioritize Blocker/Major/Nit, deduplicate and write
`consolidated_review_report.md` with a traceability matrix from raw findings
to consolidated actions. Notify with its path, not a chat dump.

All reports default to the working directory or `EGM artifact directory:
<path>` supplied by the human/instructions. Designs remain at TargetFile.
