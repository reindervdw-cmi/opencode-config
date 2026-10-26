# OpenCode team workflows

Internal OpenCode configuration using our LiteLLM service.

## Setup

Place this repository in `~/.config/opencode/` (back up any existing configuration first). Connect to the configured LiteLLM provider through OpenCode's `/connect` command.

For GitHub work, install and authenticate `gh`. For Azure DevOps, use Azure CLI with the `azure-devops` extension.

Run OpenCode from the project you want to work on. After editing CUE sources, follow the generation steps under [Maintenance](#maintenance).

## Usage

```sh
opencode
```

Describe your change, choose a branch or worktree, and approve the architect's plan. Then say:

> Execute.

Coordinator delegates implementation and testing, then arranges independent review. Commits, pushes, and PRs require your authorization.

### Elephant/Goldfish design workflow

Start a design conversation with Elephant:

```sh
# After just validate, then just build:
opencode --agent egm-elephant
```

Elephant interviews you, presents alternatives (including simpler approaches), and evolves a free-form design through explicit human decisions. It does not implement code or run commands. Bounded Scout evidence supports five ordered Goldfish stages:

1. **Initial zoom-out:** `egm-goldfish-zoom-out` alone.
2. **Comprehension:** `egm-goldfish-comprehension` alone.
3. **Critic:** `egm-goldfish-design`, `egm-goldfish-structural`, and `egm-goldfish-style` in parallel.
4. **Intermediate zoom-out:** `egm-goldfish-zoom-out` alone.
5. **Design-readiness:** `egm-goldfish-implementation-readiness`, `egm-goldfish-codebase-details`, and `egm-goldfish-style` in parallel.

All seven read-only, subagent-only personas use `midEffort` and own their single-lens rubric:

| Reviewer source / ID                                                                           | Lens                                                        |
| ---------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| [`egm-goldfish-zoom-out`](cue/agent-egm-goldfish-zoom-out.cue)                                 | Problem/solution fit, architecture, scope, simplicity       |
| [`egm-goldfish-comprehension`](cue/agent-egm-goldfish-comprehension.cue)                       | Independent reconstruction and comprehension gaps           |
| [`egm-goldfish-design`](cue/agent-egm-goldfish-design.cue)                                     | Technical tradeoffs, failures, security, dependencies       |
| [`egm-goldfish-structural`](cue/agent-egm-goldfish-structural.cue)                             | Completeness, consistency, acceptance traceability          |
| [`egm-goldfish-style`](cue/agent-egm-goldfish-style.cue)                                       | Precision, readability, consequential wording               |
| [`egm-goldfish-implementation-readiness`](cue/agent-egm-goldfish-implementation-readiness.cue) | Decisions and evidence sufficient for later task derivation |
| [`egm-goldfish-codebase-details`](cue/agent-egm-goldfish-codebase-details.cue)                 | Repository claims against primary codebase evidence         |

Parallelism is only within a stage: Elephant waits for **all** required reviewers, never overlaps stages or sends sibling results to reviewers, and synthesizes directly into the existing ledger. No synthesizer agent or extra artifacts are introduced. Deduplication preserves stable finding IDs, individual attribution, evidence, severity, disagreements, and human dispositions. Resolve findings/disagreements with the human and obtain an explicit stage gate before proceeding; missing, failed, or contaminated reviews block the stage rather than disappearing through consolidation.

Reviewers read the full free-form design and explicit primary references. No rigid headings, task template, or existing task breakdown are required. Design-readiness means a feasible implementation breakdown can be derived; it is not actual tasks, task approval, execution/Git authorization, or proof that checks pass.

#### Artifacts and confinement

Before any write, confirm the repository/worktree root with read-only evidence and require the session's **Location to be that root**. If it cannot be established, stop and ask; Elephant must not change Location. Approve a nonempty, single-component feature slug (no slash, backslash, dot segments, or traversal) and these exact root-relative paths:

- `specs/<feature>/design.md`: design with an explicit revision marker.
- `specs/<feature>/goldfish-review.md`: revision/change ledger, human gates, review manifests/results with stage/reviewer/lens/revision, stable finding IDs, attribution, severity, disagreements, dispositions, rationale, evidence, invalidations, accepted risks, and final approval.

Creation or adoption/overwrite of existing artifacts needs explicit approval. Existing content is preserved unless overwrite is approved. Elephant may directly edit only those two approved documents: no other feature, implementation file, deletion, rename, or delegated write.

This is **lexical confinement, not a hard sandbox**. Edit permissions are Location-relative; the approved slug is a prompt guard, not a dynamically narrowed permission rule. Wildcards cross path separators, so nested-feature denials must stay last. Check both artifact paths and every parent for symlinks with supported read-only tools. If absence cannot be established, disclose unchecked paths and ask for confirmation or guidance; never claim realpath confinement or symlink safety. Lack of a hard sandbox alone does not reject the workflow.

Denied shell/execute does not prevent all side effects: edits can trigger formatters/plugins. Inspect available configuration read-only, disclose possible effects before approval, and ask about uncertain effects; do not run runtime probes. External evidence needs permission and never authorizes external writes. Ambient tools, instructions, skills, and plugins are not an isolation boundary; unknown tools/MCP actions remain denied and children cannot be used to bypass denials.

#### Fresh review, revisions, and resume

Every Goldfish dispatch uses a **new session without `sessionID`**, including reused reviewer IDs, never continuation of a previous review. Each manifest names stage, reviewer ID/lens and agent-local rubric, exact design path/current revision, and explicitly permitted primary reference paths/sections. The full design must stand on its own. By default exclude the ledger (including its path), parent deliberation, interview transcripts, earlier Scout summaries, and previous reviews/conclusions. Links do not authorize reading excluded artifacts; references cannot expand transitively.

**Only intermediate zoom-out has a baseline exception:** supply the initial zoom-out result and explicit human dispositions **directly**, declared in its manifest as baseline-informed input, never as fresh evidence or a pass. Do not supply the ledger or its path, other review results, transcripts, or parent deliberation. Initial zoom-out and every other review remain independent; **Scouts never receive the exception**, baseline results, or dispositions. The intermediate reviewer compares current scope/simplicity without inheriting prior conclusions. Accepted decisions remain challengeable with new evidence or changed design: preserve prior acceptance, identify the new basis, and request renewed human disposition.

Fresh sessions do **not** provide filesystem or ambient-context isolation. Children enforce their own permissions, not an intersection with the parent's. Reference/read exclusions are prompt obligations; in particular, grep permission matches the query, not the search path. Goldfish limits reads/searches to named references. Any Scout it needs is also fresh, with exact questions, the same permitted references/exclusions, no writes, commands, probes, checks, or broad searches, and requested file:line evidence, read-discovered verification entrypoints, unknowns, and exposure disclosure. Scout supplies facts, not verdicts; reading a check's entrypoint does not prove it passes.

Unintended exposure, including ambient context or Scout output, makes a review contaminated and **UNVERIFIABLE**, never a pass. Correct the manifest/design and redispatch freshly, or seek human guidance if uncontaminated review cannot be established. Failed launches/reads and missing essential evidence cannot count as success. Verdicts are `READY`, `READY_WITH_ACCEPTED_RISKS`, `NOT_READY`, or `UNVERIFIABLE`. Only you can accept nonessential risks, with rationale for an explicit revision; waivers cannot replace essential facts, requirements, permissions, or authorization.

Resolve findings with the human and obtain the explicit gate before the next stage. Scope, architecture, or acceptance changes invalidate **all** prior lenses; narrower changes must record which lenses are invalidated and why. Repeat invalidated reviews freshly in stage order, preserving stage gates and waiting for all required reviewers; retained evidence keeps its original reviewed revision and an explanation of continued applicability, never relabeled as a new review. Final design approval names the current revision, applicable reviews, and accepted risks, with no unresolved essential blockers.

On resume, summarize both artifacts and approvals, identify missing/stale state, and ask to repair it. File existence or a prior session summary is not approval. Do not review a design that changes during review.

#### Breakdown and execution gates

After current-revision design approval, Elephant offers an `egm-coordinator` handoff for **breakdown only**, dispatched only with your acceptance. You can also start that Coordinator directly with an approved design and coverage ledger; a preexisting task plan is not required:

```sh
# After just validate, then just build:
opencode --agent egm-coordinator
```

The EGM Coordinator checks the repository/worktree root, exact revision, acceptance criteria, reviewed coverage, approval, and accepted risks. Read-only Scout evidence supports a full derived breakdown: complete task descriptions, exact allowed create/modify/delete/rename paths, dependencies/non-overlapping batches, complete DoDs, verification entrypoints, and acceptance traceability covering every criterion. It adds no requirements or architecture; unresolved design choices return to the caller/user for Elephant revision. Derivation does not authorize branch setup, mutation, or developer dispatch.

**Design approval, derived-breakdown approval, execution authorization, and Git Strategy authorization are distinct.** Before implementation setup, approve the breakdown tied to the exact design revision, explicitly authorize execution for that revision/breakdown, and authorize the applicable Git Strategy (including a no-mutations strategy). One response may grant breakdown approval and execution/Git authorization when every scope is explicit. Design approval alone authorizes none of implementation, task execution, Git mutation, or forge writes; commits, pushes, and PRs still require authorization.

Material design/requirements discoveries stop affected work and return to the caller/user for Elephant revision; the Coordinator does not edit the design or recursively dispatch Elephant. Resume affected work only after reviewed, human-approved revised design/coverage and reauthorized breakdown/execution. Substantive breakdown changes likewise need reapproval and renewed execution/applicable Git authorization; retries cannot bypass gates. Only demonstrably unaffected, already authorized work may continue.

This is a lean, original adaptation, not a full plugin port; no upstream prompts are copied. Background: [Google announcement](https://opensource.googleblog.com/2026/10/introducing-elephant-goldfish-model-plugin.html), [essay](https://drensin.medium.com/elephants-goldfish-and-the-new-golden-age-of-software-engineering-c33641a48874), and [upstream Elephant/Goldfish model](https://github.com/google/elephant-goldfish-model). Local definitions: [Elephant](cue/agent-egm-elephant.cue), [shared Goldfish boundary](cue/lib-egm.cue), the seven reviewer sources above, and [EGM Coordinator](cue/agent-egm-coordinator.cue). The existing [Architect](cue/agent-architect.cue) workflow above remains available.

### Docker Compose

Use [`compose.yaml`](compose.yaml) to run the OpenCode server in Docker for sandboxing. From this repository, create `.env` from `.env.example` if it does not already exist, and set `HOME` to your home directory:

```sh
docker compose up -d --build
```

The server listens at `http://127.0.0.1:49374`. The container mounts `~/repositories`, your OpenCode configuration and data, and the development caches listed in `compose.yaml`. You may need to modify the volume mounts for your personal setup.

You can then connect your OpenCode to the sandboxed server with

```sh
~/.opencode/bin/opencode --server http://127.0.0.1:49374
```

You may want to alias the above command to `opencode` in your shell configurations.

## Maintenance

Requires `just` and CUE for configuration.

Edit `cue/`, not generated `opencode.json`.

```sh
just validate
just build
```

Run these in order with real CUE available; do not hand-edit generated JSON or substitute another compiler. Include the regenerated artifact with configuration changes and verify its rendered agents, modes, models, permissions, and prompts before treating new agents as active. For this source-only delivery, `opencode.json` intentionally remains unchanged and these checks remain pending; source checks and secondary comparisons against the checked-in Coordinator are not authoritative rendered verification.

Skills live in `skills/`.
