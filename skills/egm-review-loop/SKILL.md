---
name: egm-review-loop
description: Upstream antagonistic-review swarm, semantic range re-resolution and persistent Elephant resolution loop.
license: Apache-2.0
disable-model-invocation: true
---

# EGM Review Loop

OpenCode adaptation of upstream `skills/egm_review_loop/SKILL.md`.
Read `../egm-review/references/execution_instructions.md`.

## Inputs and confirmation

Require TargetFile, SemanticTarget (a stable heading or `full file`), Reviewers,
Standards mapping and GoldfishContext (an explicitly empty list is allowed).
Accept an approved OutputFile when used as a review-stage subflow; otherwise
default to `goldfish_review_report.md` in the workspace/artifact directory.
Ask only for missing inputs, one at a time. Display target, reviewers and
mapped standards and confirm configuration before a manual run. A caller's
already-approved stage configuration does not need a duplicate intake gate.

Resolve reviewer shortnames `zoom_out`, `comprehension`, `design_critic`,
`structural`, `style`, `implementation_readiness`, `codebase_details` to
`egm-goldfish-zoom-out-review`, `egm-goldfish-comprehension-review`, `egm-goldfish-design-review`,
`egm-goldfish-structural-review`, `egm-goldfish-style-review`,
`egm-goldfish-implementation-readiness-review`, `egm-goldfish-codebase-details-review`.
Standard shortnames map to `../egm-review/references/document_standards/<name>.md`.
Custom standards/blueprints may use explicit workspace/absolute paths.
Recommend design/structural with feature-spec-standard for feature specs,
readiness/codebase-details with implementation-readiness-standard for plans.

## Sharpening cycle

1. Before EVERY iteration read TargetFile and resolve SemanticTarget to its
   current absolute line range, including shifted lines after prior edits.
2. Launch a fresh `egm-synthesizer-review` without sessionID with target,
   current range, reviewers, standards, context and OutputFile. It launches
   requested Goldfish in parallel and writes the report. Direct fresh dispatch
    is the fallback if nesting is unavailable; no fresh subagents means stop.
   Direct dispatch uses the same review-only IDs and task inputs; no role-selection
   argument is required. Never dispatch -brainstorm agents for document review.
3. Wait for all findings. Preserve severity (Blocker/Major/Nit), references,
   discrepancies and rationales in a single FindingsList. Failed/incomplete
   reviews are limitations, not no-findings.
4. For an interactive caller's resolve choice, load `egm-resolve` in the
   persistent Elephant session with target, range and FindingsList. Manual
   loops offer resolution after each report. Uninterrupted review returns the
   report to its caller without inserting interactive remediation.
5. After resolution remain idle until the human explicitly asks for another
   round. Re-read/re-resolve and run fresh reviewers. Continue until zero
   findings or human halt; stage subflows obey `egm-review`'s one re-audit cap.

Programmatic callers receive the report and remaining issues and control
returns to the caller. A manual run ends with a short completion/path message
and one next-step question. Never report zero issues on a manual halt with
unresolved findings or a failed review.
