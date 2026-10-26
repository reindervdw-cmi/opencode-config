---
name: egm-resolve
description: Upstream persistent Elephant resolution: contest findings with evidence or propose precise human-approved document repairs.
license: Apache-2.0
disable-model-invocation: true
---

# EGM Resolve

OpenCode adaptation of upstream `skills/egm_resolve/SKILL.md`.
Read `../egm-review/references/execution_instructions.md`. Work in the
persistent Elephant session that generated the design when available.

## Intake and classification

Require TargetFile, LineRange (or `full file`) and FindingsList. For a complete
programmatic handoff skip onboarding; otherwise ask for missing inputs one
at a time and confirm setup. Read the current target/range and each finding.

Classify each as:

- **CONTEST**: inaccurate/misunderstood critique; give exact code/design evidence.
- **PROPOSE FIX**: valid critique; propose precise replacements or structural
  edits, preserving the intended design. Do not silently decide new behavior.

Write `goldfish_review_report.md` in the working directory or approved
artifact directory with title Goldfish Annotated Review Report, target/range,
and findings ordered by severity. Each includes reviewer, affected scope/link,
original discrepancy/rationale, AI Suggestion, justification and exact proposed
edit/location. Preserve contested and unaddressed issues, not just fixes.

## Human decision gate

Link the report and ask how to proceed; yield immediately, with no further
tools until a response. Explain the actions:

- Comment on the file/chat to approve, reject or contest particular items.
- **Auto accept**: batch-apply all PROPOSE FIX items, skipping CONTEST.
- **Continue / no changes**: apply nothing and return remaining issues.
- **Interactive breakdown**: discuss every item in sequence, one question per
  turn. PROPOSE FIX choices: accept, skip, discuss. CONTEST choices: agree with
  contest, overrule/propose fix, discuss. Record decisions; edit only after all
  items are decided, not during the item-by-item loop.
- A custom instruction may approve targeted edits or change the discussion.

An explicit accept-all/proceed response to this fix gate authorizes the
displayed PROPOSE FIX edits only; it does not authorize production changes.
Apply only approved Markdown edits to TargetFile. If a new request contradicts
earlier architecture/goals, do not write; ask for resolution first.

## Synchronize

Re-read the changed target, validate Markdown structure and shifted line bounds.
Add `Status: resolved` to indicate completion of the resolution round, not that
all issues are fixed. Keep counts of accepted fixes, contests and remaining
unaddressed issues visible. Return those counts to the caller and wait for
explicit permission before another review round.
