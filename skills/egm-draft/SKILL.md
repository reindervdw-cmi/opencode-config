---
name: egm-draft
description: Upstream EGM section-by-section design drafting with a complete zero-decision Detailed Implementation Plan and human approval gates.
license: Apache-2.0
disable-model-invocation: true
---

# EGM Draft

OpenCode adaptation of upstream `skills/egm_draft/SKILL.md`.
Read `../egm-review/references/execution_instructions.md`,
`../egm-review/references/design_doc.md` and the feature, implementation
readiness and zoom-out standards in its `document_standards/` directory.
Keep drafting in the persistent Elephant session; no production implementation.

## Intake

If a Context File is supplied, read it. Otherwise look first for
`concepts_brief.md`, then `discussion_summary.md`, in the working directory,
approved artifact directory or `scratch/`. If neither exists, ask for problem,
goals and context, or offer brainstorm. Do not require brainstorm when notes
are available. Confirm the source/understanding and obtain approval to draft.

## Section-by-section construction

Write/update `design_draft.md` in the working directory or the supplied
`EGM artifact directory: <path>`, using the template. Advance only after
explicit human agreement; the human may revisit earlier sections.

1. **Overview, Problem, Goals, Non-Goals**: business/user need and measurable
   outcomes, emphasizing why. Record unresolved questions and Given/When/Then
   Critical User Journeys in the template.
2. **Technical Plan (Architecture)**: components, interfaces, data flow,
   integration, new/modified files and API changes; diagrams when useful.
3. **Alternatives Considered**: viable alternatives, pros/cons and specific
   reasons for rejection. A single unexamined approach fails the feature standard.
4. **Detailed Implementation Plan**: one unified, detailed implementation list.
   Enumerate EVERY create/modify/delete/rename path, including docs, schema,
   config, dependencies/lockfiles and tests; give the change and rationale.
   Specify APIs/signatures, schemas, transformations, error/edge-case behavior,
   dependency choices, migration/rollout and rollback where applicable. Resolve
   all design/architecture choices before handoff: no TBDs, guessing, follow-up
   design questions or independent choices for implementers. Ordinary syntax
   need not be prescribed. Pseudocode, API declarations and schemas are allowed
   in Markdown; do not create production code.
   Partition into ordered incremental phases, each stable/buildable/testable,
   with dependencies, explicit task completion criteria, exact verification
   commands and specific happy-path/edge-case tests and expected assertions.
   Obtain correctness-affecting decisions from the human, not the Coordinator.

After each section write, give a visible short explanation (2–3 decisions),
link the draft, then ask one single-select approval question: approve and
proceed, or request revisions. Wait. Apply inline comments/chat notes before
advancing even when approval is selected. If revision is selected with no
notes, ask what needs changing rather than looping an empty gate.

## Finalization

Use the user-specified destination. Otherwise discover an existing design
directory from context, `docs/designs/` or the project, default `docs/designs/`,
and ask where to save (detected location or custom path). Confirm exact paths
and preservation of existing content. Update its SITEMAP.md if present and
approved. Self-evaluate against the zoom-out standard: root problem, YAGNI,
reuse, appropriate altitude and no redundancy. Discuss improvements and get
approval before applying them. Write the final template-based design to the
approved path, with clean Markdown. Link it and offer `egm-review` for that
path. Final design approval is not implementation or Git authorization.
