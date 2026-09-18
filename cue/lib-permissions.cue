package opencode

import "list"

// Shared bash permission fragments.
//
// WHY LISTS INSTEAD OF STRUCTS:
// opencode evaluates bash permission rules by pattern match where the LAST
// matching rule wins. Field order in the exported JSON is therefore semantic,
// not cosmetic.
//
// CUE emits all literal fields of a struct BEFORE any embedded definition's
// fields, regardless of where the embedding is written. That means a struct
// like:
//
//     bash: {
//         "*":         "deny"
//         "git push*": "deny"   // literal -> emitted early
//         _gitWrite             // embedded -> emitted LATER, contains "git *"
//     }
//
// would emit "git *": "allow" AFTER the local "git push*": "deny", silently
// escalating privilege. With two or more embeddings the catch-all "*" drifts
// into the middle of the output and denies everything after it.
//
// Ordered lists of [pattern, action] pairs avoid both traps: _bash preserves
// concatenation order exactly, so "deny-narrowing" fragments can always be
// placed last and actually win.
//
// Duplicate patterns with conflicting actions are a hard build error rather
// than a silent override, which turns permission mistakes into `make validate`
// failures. Use _bashOverride to intentionally re-specify a pattern.

// _bash converts an ordered list of [pattern, action] pairs into the struct
// shape opencode expects, preserving order.
_bash: {
	#rules: [...[string, string]]
	out: {
		for r in #rules {(r[0]): r[1]}
	}
}

// _bashRules is the convenience entry point: concatenates fragments in order
// and returns the resulting struct.
//   bash: _bashRules([_denyAll, _readOnly, _gitRead])
_bashRules: {
	#frags: [...[...[string, string]]]
	out: (_bash & {#rules: list.Concat(#frags)}).out
}

// --- Baseline ------------------------------------------------------------

// Deny-by-default. Must come first in every composition.
_denyAll: [["*", "deny"]]

// --- Read-only inspection ------------------------------------------------

// Filesystem inspection. Note trailing " *" on each: a bare "wc" pattern does
// not match "wc -l file", so every command that takes arguments needs it.
_readOnlyFs: [
	["echo*", "allow"],
	["find *", "allow"],
	["grep *", "allow"],
	["rg *", "allow"],
	["cat *", "allow"],
	["head *", "allow"],
	["tail *", "allow"],
	["wc *", "allow"],
	["ls *", "allow"],
	["ls", "allow"],
	["tree *", "allow"],
	["file *", "allow"],
]

// Read-only git. "git status*" (not bare "git status") so that
// `git status --porcelain` and `git status -sb` also match.
_gitRead: [
	["git status*", "allow"],
	["git log*", "allow"],
	["git show*", "allow"],
	["git diff*", "allow"],
	["git branch*", "allow"],
	["git rev-parse*", "allow"],
	["git merge-base*", "allow"],
	["git ls-files*", "allow"],
]

// --- Verification --------------------------------------------------------

// Linters and type checkers. Non-mutating.
// Note: "ruff *" covers `ruff format`, which DOES mutate; _lintDenyWrite
// narrows that back out for read-only agents.
_lint: [
	["eslint *", "allow"],
	["ruff *", "allow"],
	["mypy *", "allow"],
	["ty *", "allow"],
	["tsc --noEmit*", "allow"],
	["cargo check*", "allow"],
	["cargo clippy*", "allow"],
	["go vet*", "allow"],
]

// Narrowing fragment: strip the mutating subcommands back out of _lint.
// Place AFTER _lint so it wins.
_lintDenyWrite: [
	["ruff format*", "deny"],
	["eslint --fix*", "deny"],
	["eslint * --fix*", "deny"],
]

// Test and build execution. Required by any agent expected to verify that
// code actually works rather than trusting a self-report.
_testRun: [
	["pytest*", "allow"],
	["uv run pytest*", "allow"],
	["uv run *", "allow"],
	["npm test*", "allow"],
	["npm run test*", "allow"],
	["npm run build*", "allow"],
	["npm run lint*", "allow"],
	["npm run typecheck*", "allow"],
	["bun test*", "allow"],
	["bun run *", "allow"],
	["pnpm test*", "allow"],
	["pnpm run *", "allow"],
	["yarn test*", "allow"],
	["cargo test*", "allow"],
	["cargo build*", "allow"],
	["go test*", "allow"],
	["go build*", "allow"],
	["make", "allow"],
	["make test*", "allow"],
	["make build*", "allow"],
	["make lint*", "allow"],
	["make validate*", "allow"],
]

// --- Git write -----------------------------------------------------------

// Mutating git operations. Reserved for the single agent that owns history.
_gitWrite: [
	["git add *", "allow"],
	["git commit *", "allow"],
	["git checkout *", "allow"],
	["git switch *", "allow"],
	["git stash*", "allow"],
	["git merge*", "allow"],
	["git worktree*", "allow"],
	["git reset --soft*", "allow"],
	["git reset --mixed*", "allow"],
	["git reset --hard*", "ask"],
	["git push*", "ask"],
]

// --- Azure DevOps --------------------------------------------------------

// Read-only ADO/auth.
_azRead: [
	["az account show*", "allow"],
	["az login*", "allow"],
	["az devops configure*", "allow"],
	["az boards query*", "allow"],
	["az boards work-item show*", "allow"],
	["az boards work-item relation list*", "allow"],
	["az repos pr list*", "allow"],
	["az repos pr show*", "allow"],
	["az devops invoke*", "allow"],
]

// Mutating ADO. PR creation asks; it is externally visible.
_azWrite: [
	["az boards work-item update*", "allow"],
	["az boards work-item relation add*", "allow"],
	["az repos pr create*", "ask"],
	["az repos pr update*", "allow"],
	["az repos pr reviewer add*", "allow"],
]

// --- Safety guards -------------------------------------------------------

// Blocks machine-wide mutation and network fetches. Intended for agents that
// run with a permissive bash baseline (i.e. the developer), where the risk is
// not reading the wrong file but changing the host. Place LAST so these denies
// beat any earlier allow.
_denyGlobalMutation: [
	["npm install -g*", "deny"],
	["npm i -g*", "deny"],
	["npm add -g*", "deny"],
	["pnpm add -g*", "deny"],
	["yarn global add*", "deny"],
	["uv tool install*", "deny"],
	["uv tool update*", "deny"],
	["pipx install*", "deny"],
	["pip install*", "deny"],
	["pip3 install*", "deny"],
	["brew install*", "deny"],
	["brew upgrade*", "deny"],
	["apt install*", "deny"],
	["apt-get install*", "deny"],
	["snap install*", "deny"],
	["sudo*", "deny"],
	["curl*", "deny"],
	["wget*", "deny"],
	["ssh*", "deny"],
	["scp*", "deny"],
	["nc*", "deny"],
	["rm -rf /*", "deny"],
	["rm -rf ~*", "deny"],
	["chmod 777*", "deny"],
	["dd *", "deny"],
	["mkfs*", "deny"],
	[":(){*", "deny"],
	["shutdown*", "deny"],
	["reboot*", "deny"],
]

// Denies every git subcommand. The pipeline funnels all history mutation
// through one agent; this keeps the others out.
//
// NOTE: this is a guardrail, not a security boundary. `command git`, an
// absolute path, or a subprocess call from a test script can still reach git.
// It prevents casual and accidental use, not deliberate evasion.
_denyGit: [
	["git*", "deny"],
]

// Denies forge/issue-tracker CLIs. These have side effects visible outside the
// repo (work item state, PR creation), which belong to the orchestrator alone.
_denyForgeCli: [
	["az*", "deny"],
	["gh*", "deny"],
	["glab*", "deny"],
]

// Denies infrastructure mutation. Separate from _denyForgeCli so a pipeline
// that legitimately needs containers (e.g. testcontainers-based integration
// tests) can omit just this fragment.
_denyInfra: [
	["docker*", "deny"],
	["kubectl*", "deny"],
	["terraform*", "deny"],
	["helm*", "deny"],
]
