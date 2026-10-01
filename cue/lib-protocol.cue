// Shared prompt fragments for the delivery pipeline.
package opencode


_statusVocabulary: """
	## Status Vocabulary

	These tokens are a machine-read contract. Emit them EXACTLY as written —
	uppercase, underscores, no surrounding punctuation or markdown emphasis.

	Developer task status:
	- `COMPLETE` — every Definition-of-Done item satisfied; tests written and passing.
	- `INCOMPLETE` — progress made, could not finish. State precisely what remains.
	- `BLOCKED` — cannot proceed without outside intervention. State what is needed.
	- `AWAITING_CLARIFICATION` — a genuine ambiguity prevents correct work.

	Review verdicts:
	- `APPROVED` — all DoD items verified PASS; no critical or major issues.
	- `CHANGES_REQUESTED` — any DoD item FAIL, or any critical/major issue.

	Per-criterion results: `PASS` | `FAIL` | `UNVERIFIABLE`

	Issue severities:
	- `critical` — must fix before merge; broken, unsafe, or wrong.
	- `major` — must fix before merge; meaningful defect or missing requirement.
	- `minor` — should fix eventually; does not block delivery.
	"""

// Agents blocked by ambiguity use this envelope instead of inventing context.
_clarificationProtocol: """
	## When You Lack Information

	You are never required to guess. Inventing a requirement, a file path, or a
	root cause is worse than stopping, because downstream agents cannot tell an
	invention from a fact.

	Before asking, try to answer it yourself with the tools you have. Ask only
	about genuine ambiguity that would change what you produce.

	Emit this INSTEAD OF your normal output, as your entire response:

	```
	--- CLARIFICATION NEEDED ---
	status: AWAITING_CLARIFICATION

	questions:
	  - [specific, answerable question]

	context:
	  - [what you were doing and why you cannot proceed]
	  - [what you already tried]

	options:
	  - [option A and its tradeoff]
	  - [option B and its tradeoff]

	blocked_on: [what you cannot produce without an answer]
	--- END CLARIFICATION ---
	```

	Clarification requests do not count as failures and are exempt from the
	Two-Strike Rule.
	"""

// Provider-neutral identity passed unchanged through triage, planning, task
// dispatch, and reporting. Consumers choose provider tooling, not this contract.
_forgeContextSchema: """
	## Forge Context
	forge: [github | azure-devops | other | none]
	host: [forge hostname; include organization/collection URL when applicable]
	repository: [repository identity, e.g. owner/name; null if not applicable]
	project: [project identity; null if provider has no project scope]
	issue_id: [issue/work-item identifier; null if no linked issue]
	issue_url: [canonical issue/work-item URL; null if no linked issue]
	target_branch: [exact delivery base/PR target branch]

	Carry this context unchanged in handoffs. Use explicit null for absent fields;
	never invent identities or assume github.com, an organization, or a branch.
	Resolve required unknowns with the clarification protocol before delivery.
	This is identity/context, not authorization or a provider-specific command recipe.
	"""

// THE plan schema.
_planSchema: """
	```
	--- BEGIN PLAN ---

	\(_forgeContextSchema)

	## Git Strategy
	branch: [exact branch name, e.g. feature/1234-add-login]
	base: [branch to branch from and target in the PR, e.g. main]
	notes: [anything the program manager must know before the first commit]

	## Task Plan

	### Task 1: [short title]
	- **Description**: [what must be done, concretely]
	- **Files**: [explicit paths this task may create/modify/delete]
	- **Parallel group**: [A/B/C... — same-letter tasks may run concurrently]
	- **Depends on**: [task numbers, or "none"]
	- **Checkpoint after**: [yes | no]
	- **Verification**: [exact command(s) proving this task works, e.g. `uv run pytest tests/test_login.py`]
	- **Definition of Done**:
	  - [ ] [specific, independently checkable criterion]
	  - [ ] [Tests: which tests must exist and pass]
	- **Satisfies**: [acceptance-criterion IDs from triage this task serves, e.g. AC1, AC3]

	### Task 2: [short title]
	...

	## Test Strategy
	[test types, frameworks, and the full-suite command for the whole change]

	## Acceptance Criteria Coverage
	[Every acceptance criterion ID mapped to the task numbers that satisfy it.
	 Every criterion MUST appear. If one is not covered by any task, say so
	 explicitly and why — silent omission is a defect.]

	## Risks
	- [risk]: [mitigation]

	## Rollback Plan
	[how to revert if delivery fails]

	--- END PLAN ---
	```
	"""

// Concurrency control for parallel developers. Rests on prompt compliance,
// since all developers share one working tree and `edit` cannot be scoped
// per-dispatch.
_fileOwnership: """
	## File Ownership

	Parallel developers share one working tree. Your assignment's file list is
	how collisions are prevented. A write outside it can silently destroy
	another agent's concurrent work — the loss is invisible until review.

	**You own** only explicitly assigned paths. Every path you create, modify,
	delete, or rename must be listed, including tests and new files. Creating a
	file yourself does not grant ownership or exempt later writes. A test
	requirement does not authorize an unlisted test path.
	This boundary also applies to shell commands and cross-file LSP actions.

	**Also permitted**, no need to ask: reading any file in the repo.

	**Stop and report** — do not edit — for anything else, specifically:
	- Source files owned by another task.
	- Shared manifests and lockfiles (`package.json`, `pyproject.toml`,
	  `uv.lock`, `Cargo.toml`, `go.mod`): high-collision, so the program
	  manager sequences them.
	- Config, CI, or infrastructure not explicitly assigned.

	When you need an unlisted file, finish what you safely can, then report
	`INCOMPLETE` naming the file and why. Do not silently expand your scope.
	"""

// Developer completion report. Read by the program manager, QA, and reviewer.
_developerReport: """
	## Completion Report

	End your turn with exactly this block:

	```
	--- BEGIN REPORT ---
	status: COMPLETE | INCOMPLETE | BLOCKED

	forge_context: [copy supplied Forge Context fields unchanged; do not infer missing values]

	files_modified:
	  - path: [path]
	    change: [what changed and why]

	files_created:
	  - path: [path]
	    purpose: [why it exists]

	verification:
	  - command: [exact command you ran]
	    result: PASS | FAIL
	    output: [key lines — the failure, or the pass summary]

	definition_of_done:
	  - status: DONE | NOT_DONE
	    criterion: [each DoD item, verbatim]
	    evidence: [file:line or command output proving it]

	out_of_scope_needed:
	  - [files outside your assignment you needed, or "none"]

	dependencies_added:
	  - name: [package]
	    reason: [problem it solves]
	    alternative_considered: [stdlib or existing dep you rejected, and why]

	notes:
	  - [anything the program manager must know, or "none"]
	--- END REPORT ---
	```

	Report what you actually observed. A `COMPLETE` you did not verify is worse
	than an honest `INCOMPLETE`: the reviewer will catch it, the pipeline will
	loop, and the cause will be harder to find. Never claim a command passed
	without running it.
	"""

_evidenceStandard: """
	## Evidence Standard

	Report only what you directly observed in the code or in command output.

	- Cite `file:line` for every claim about the code.
	- Quote real command output for every claim about behaviour.
	- Never infer that something works because a report says so. Self-reports
	  are claims to verify, not evidence.
	- If you cannot verify a criterion, mark it `UNVERIFIABLE` and say what
	  blocked you. Never guess `PASS` — this pipeline can open a pull request
	  on your verdict.
	- Do not invent issues to appear thorough. A clean check is a useful result.
	"""

_sandboxNote: """
	## Sandbox Environment

	You are running inside a sandboxed agent session. The working tree visible
	to you may not be the complete repository: some paths are intentionally
	withheld by the sandbox and will appear absent even when they exist on the
	host.

	When a file or directory that logically should exist cannot be found:
	- Do not conclude it is missing, deleted, or misconfigured in the project.
	- Treat it as likely outside your sandbox boundary.
	- Note it as `UNVERIFIABLE` or `out_of_scope_needed` in your report rather
	  than inventing its contents or reporting a false defect.
	- Do not retry the same path repeatedly — if it is not visible on the first
	  attempt it will not become visible on the second.
	"""
