package opencode

import "list"

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

// Deny-by-default. Must come first in every composition.
_denyAll: [["*", "deny"]]

// Filesystem inspection. Use glob instead of find, which can delete or execute.
_readOnlyFs: [
	["echo*", "allow"],
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
	["*>*", "deny"],
]

// Read-only git. Output files and redirects are writes, not inspection.
_gitRead: [
	["git status*", "allow"],
	["git log*", "allow"],
	["git show*", "allow"],
	["git diff*", "allow"],
	["git branch", "allow"],
	["git branch --list", "allow"],
	["git branch -a", "allow"],
	["git branch -r", "allow"],
	["git branch -v", "allow"],
	["git branch -vv", "allow"],
	["git remote", "allow"],
	["git remote -v", "allow"],
	["git remote --verbose", "allow"],
	["git remote get-url*", "allow"],
	["git rev-parse*", "allow"],
	["git merge-base*", "allow"],
	["git ls-files*", "allow"],
	["*git *--output*", "deny"],
	["*git *>*", "deny"],
]

// Check entry points, including routine runners and skill-recommended forms.
_lint: [
	for prefix in ["", "uv run ", "uv run --no-sync "]
	for cmd in ["ruff check*", "mypy *", "ty check*"] {
		["\(prefix)\(cmd)", "allow"]
	},
	for prefix in ["", "./node_modules/.bin/", "npx ", "bunx ", "bun run ", "pnpm exec "]
	for cmd in ["eslint *", "prettier --check*", "tsc --noEmit*", "tsc *--noEmit*"] {
		["\(prefix)\(cmd)", "allow"]
	},
	["cargo check*", "allow"],
	["cargo clippy*", "allow"],
	["go vet*", "allow"],
]

// Narrowing fragment: strip the mutating subcommands back out of _lint.
// Place AFTER _lint so it wins.
_lintDenyWrite: [
	// Leading wildcards also cover runners such as uv run, npx, and bunx.
	["*ruff format*", "deny"],
	// Last-match semantics: allow checks after the generic formatter denial,
	// then deny fixes/output writes even when combined with --check.
	for prefix in ["", "uv run ", "uv run --no-sync ", "bun run ", "pnpm exec ", "npx ", "bunx "] {
		["\(prefix)ruff format *--check*", "allow"]
	},
	["*ruff *--output-file*", "deny"],
	["*ruff *-o*", "deny"],
	["*ruff *>*", "deny"],
	["*prettier *--write*", "deny"],
	["*prettier *-w*", "deny"],
	["*eslint *--fix*", "deny"],
	["*eslint *--output-file*", "deny"],
	["*eslint *-o*", "deny"],
	["*eslint *--cache*", "deny"],
	["*cargo clippy*--fix*", "deny"],
	["*tsc *--noEmit false*", "deny"],
	["*tsc *--noEmit=false*", "deny"],
	// Verification runners never authorize Git or forge operations, including
	// when appended to an otherwise allowed verification command.
	for cmd in ["git", "gh", "az"] {
		["* \(cmd) *", "deny"]
	},
	["*ruff *--fix*", "deny"],
]

// Inspected test/build scripts only; never grant an unrestricted runner.
_testRun: [
	["pytest*", "allow"],
	["uv run pytest*", "allow"],
	["uv run --no-sync pytest*", "allow"],
	["npm test*", "allow"],
	["npm run test*", "allow"],
	["npm run build*", "allow"],
	["npm run lint*", "allow"],
	["npm run typecheck*", "allow"],
	["bun test", "allow"],
	["bun test *", "allow"],
	for runner in ["bun run", "pnpm run"]
	for cmd in ["test", "test *", "build", "build *", "lint", "lint *", "typecheck", "typecheck *"] {
		["\(runner) \(cmd)", "allow"]
	},
	["pnpm test", "allow"],
	["pnpm test *", "allow"],
	for prefix in ["./node_modules/.bin/", "npx ", "bunx ", "bun run ", "pnpm exec "]
	for cmd in ["jest *", "vitest run*"] {
		["\(prefix)\(cmd)", "allow"]
	},
	["yarn test*", "allow"],
	["cargo test*", "allow"],
	["cargo build*", "allow"],
	["go test*", "allow"],
	["go build*", "allow"],
	["make test*", "allow"],
	["make build*", "allow"],
	["make lint*", "allow"],
	["make validate*", "allow"],
	["just build", "allow"],
	["just build *", "allow"],
	["just validate", "allow"],
	["just validate *", "allow"],
	["just test", "allow"],
	["just test *", "allow"],
]

// Mutating git operations.
_gitWrite: [
	["git add *", "allow"],
	["git commit *", "allow"],
	["git checkout *", "allow"],
	["git switch *", "allow"],
	["git branch *", "allow"],
	["git stash*", "allow"],
	["git merge*", "allow"],
	["git worktree*", "allow"],
	["git reset --soft*", "allow"],
	["git reset --mixed*", "allow"],
	["git reset --hard*", "ask"],
	["git push*", "ask"],
]

_azRead: [
	["az account show*", "allow"],
	["az account list*", "allow"],
	["az devops project list*", "allow"],
	["az devops project show*", "allow"],
	["az boards query*", "allow"],
	["az boards work-item show*", "allow"],
	["az boards work-item relation show*", "allow"],
	["az repos pr list*", "allow"],
	["az repos pr show*", "allow"],
	["az repos show*", "allow"],
	["az repos list*", "allow"],
	["az repos ref list*", "allow"],
	["az repos pr reviewer list*", "allow"],
	["az repos pr policy list*", "allow"],
	["az repos pr work-item list*", "allow"],
]

// Credentials and persistent CLI defaults are not read-only operations.
_azAuth: [
	["az login*", "ask"],
	["az logout*", "ask"],
	["az account set*", "ask"],
	["az devops login*", "ask"],
	["az devops logout*", "ask"],
	["az devops configure*", "ask"],
	["az config set*", "ask"],
	["az config unset*", "ask"],
]

// Externally visible mutations require confirmation, including generic APIs
// with any method spelling (--http-method, --method, -X, or implicit writes).
_azWrite: [
	["az boards work-item create*", "ask"],
	["az boards work-item delete*", "ask"],
	["az boards work-item update*", "ask"],
	["az boards work-item relation add*", "ask"],
	["az boards work-item relation remove*", "ask"],
	["az repos pr create*", "ask"],
	["az repos pr update*", "ask"],
	["az repos pr set-vote*", "ask"],
	["az repos pr reviewer add*", "ask"],
	["az repos pr reviewer remove*", "ask"],
	["az repos pr policy queue*", "ask"],
	["az repos pr work-item add*", "ask"],
	["az repos pr work-item remove*", "ask"],
	["az repos create*", "ask"],
	["az repos delete*", "ask"],
	["az repos update*", "ask"],
	["az repos import create*", "ask"],
	["az repos ref create*", "ask"],
	["az repos ref delete*", "ask"],
	["az devops invoke*", "ask"],
]

// Narrow inspection commands only; notably no `gh api` or `gh auth token`.
_ghRead: [
	["gh auth status*", "allow"],
	["gh repo view*", "allow"],
	["gh repo list*", "allow"],
	["gh issue list*", "allow"],
	["gh issue view*", "allow"],
	["gh issue status*", "allow"],
	["gh pr list*", "allow"],
	["gh pr view*", "allow"],
	["gh pr status*", "allow"],
	["gh pr diff*", "allow"],
	["gh pr checks*", "allow"],
	["gh run list*", "allow"],
	["gh run view*", "allow"],
	["gh workflow list*", "allow"],
	["gh workflow view*", "allow"],
	["gh release list*", "allow"],
	["gh release view*", "allow"],
	// Status disclosure flags are not inspection. Keep these narrowing rules
	// after the broad status allowance; substrings cover scoped and =value forms.
	["gh auth status*--show-token*", "deny"],
	["gh auth status*-t*", "deny"],
]

// Credential operations require confirmation.
_ghAuth: [
	["gh auth login*", "ask"],
	["gh auth logout*", "ask"],
	["gh auth refresh*", "ask"],
	["gh auth setup-git*", "ask"],
	["gh auth switch*", "ask"],
	["gh auth token*", "ask"],
	["gh config *", "ask"],
]

_ghWrite: [
	["gh issue create*", "ask"],
	["gh issue edit*", "ask"],
	["gh issue comment*", "ask"],
	["gh issue close*", "ask"],
	["gh issue reopen*", "ask"],
	["gh issue delete*", "ask"],
	["gh issue transfer*", "ask"],
	["gh issue pin*", "ask"],
	["gh issue unpin*", "ask"],
	["gh issue lock*", "ask"],
	["gh issue unlock*", "ask"],
	["gh pr create*", "ask"],
	["gh pr edit*", "ask"],
	["gh pr comment*", "ask"],
	["gh pr close*", "ask"],
	["gh pr reopen*", "ask"],
	["gh pr merge*", "ask"],
	["gh pr review*", "ask"],
	["gh pr ready*", "ask"],
	["gh pr lock*", "ask"],
	["gh pr unlock*", "ask"],
	["gh pr update-branch*", "ask"],
	["gh repo create*", "ask"],
	["gh repo edit*", "ask"],
	["gh repo delete*", "ask"],
	["gh repo fork*", "ask"],
	["gh repo rename*", "ask"],
	["gh repo archive*", "ask"],
	["gh repo unarchive*", "ask"],
	["gh repo sync*", "ask"],
	["gh release create*", "ask"],
	["gh release edit*", "ask"],
	["gh release delete*", "ask"],
	["gh release upload*", "ask"],
	["gh workflow run*", "ask"],
	["gh workflow enable*", "ask"],
	["gh workflow disable*", "ask"],
	["gh run rerun*", "ask"],
	["gh run cancel*", "ask"],
	["gh run delete*", "ask"],
	["gh api*", "ask"],
]

// For strictly read-only roles, append after any provider fragments. Raw APIs
// can mutate via methods, form fields, or GraphQL; even GET is not inferred safe.
_denyForgeApi: [
	["az devops invoke*", "deny"],
	["gh api*", "deny"],
]

// Blocks machine-wide mutation and network fetches.
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
	// Broad developer baselines must not bypass network/auth guards via runners.
	for cmd in ["curl", "wget", "ssh", "scp", "nc", "sudo"] {
		["* \(cmd)*", "deny"]
	},
	["rm -rf /*", "deny"],
	["rm -rf ~*", "deny"],
	["chmod 777*", "deny"],
	["dd *", "deny"],
	["mkfs*", "deny"],
	[":(){*", "deny"],
	["shutdown*", "deny"],
	["reboot*", "deny"],
]

// Denies every git subcommand, including uv/bun/pnpm/npx/command wrappers.
_denyGit: [
	["git*", "deny"],
	["* git *", "deny"],
	["* git", "deny"],
]

// Conservative token guards cover routine wrappers, raw APIs, and auth alike.
_denyForgeCli: [
	["az*", "deny"],
	["gh*", "deny"],
	["* az *", "deny"],
	["* az", "deny"],
	["* gh *", "deny"],
	["* gh", "deny"],
]

// Denies infrastructure mutation.
_denyInfra: [
	["docker*", "deny"],
	["kubectl*", "deny"],
	["terraform*", "deny"],
	["helm*", "deny"],
]
