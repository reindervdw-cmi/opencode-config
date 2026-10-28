package court

import (
	"list"
	shared "opencode.local/config/cue/shared@v0"
)

_modelDefs:             shared.ModelDefs
_shellPermissionPrompt: shared.ShellPermissionPrompt
_reviewerIDs: ["magister-goldfish-review", for lens in _lensOrder {"magister-goldfish-\(lens)-review"}]

// Global denial precedes shell exceptions; a later wildcard would erase them.
_globalDeny: {action: "*", resource: "*", effect: "deny"}
_hashRules: [
	{action: "shell", resource: "sha256sum -- *local/specs/*.md", effect: "allow"},
	{action: "shell", resource: "sha256sum -- *local/specs/**/*.md", effect: "allow"},
]
_compositionGuards: [for pattern in ["*>*", "*<*", "*;*", "*|*", "*&*", "*$*", "*`*", "*\n*"] {
	action: "shell", resource: pattern, effect: "deny"
}]
_readingRules: [
	{action: "read", resource: "*", effect: "allow"},
	{action: "read", resource: "*.env", effect: "ask"},
	{action: "read", resource: "*.env.*", effect: "ask"},
	{action: "read", resource: "*.env.example", effect: "allow"},
	{action: "glob", resource: "*", effect: "allow"},
	{action: "grep", resource: "*", effect: "allow"},
	{action: "webfetch", resource: "*", effect: "ask"},
	{action: "external_directory", resource: "*", effect: "ask"},
	{action: "external_directory", resource: "~/.config/opencode/skills/*", effect: "allow"},
]
_reviewPermissions: list.Concat([
	[_globalDeny],
	(shared.Shell & {#rules: shared.DenyAll}).out,
	_hashRules,
	_compositionGuards,
	_readingRules,
	[{action: "websearch", resource: "*", effect: "ask"}],
])

_communication: """
	Use concise, factual English. Explain mechanisms, challenge unsupported
	assumptions and consider simpler alternatives. Do not flatter or manufacture
	findings. Ask one question at a time for consequential uncertainty. Report
	actual evidence and limitations; unrun checks are never passing checks.
	"""

_identity: """
	## Plan Content Identity

	Identify the baseline by canonical absolute path, logical revision and
	PlanDigest: a 64-character lowercase SHA-256 digest of the plan's UTF-8 bytes.
	Compute it with `sha256sum -- <absolute-plan-path>` using the supplied path,
	quoted as a single shell argument when needed. Hash only that plan inside
	repository-root local/specs/, not unrelated files. Never store a digest or
	approval metadata inside the same file being hashed. Do not invent a digest.
	A missing input, unavailable hash command or differing bytes is incomplete,
	not a clean baseline. A revision label alone cannot detect drift.
	"""

_behaviorBoundary: """
	## Suggested Files and Behavioral Boundaries

	The plan's file list is suggested navigation, not an edit allowlist. Internal
	interfaces, algorithms, helpers, dependencies and file organization may change
	within approved feature scope if observable behavior and acceptance criteria
	are preserved. Report every departure from the proposed approach with its
	reason. File freedom never authorizes unrelated cleanup, overwriting user work,
	outside-repository edits, network/auth operations or Git/forge mutations.

	Observable contracts include supported API/CLI/UI behavior, outputs, errors,
	defaults, configuration semantics, persisted formats and compatibility,
	permissions/security guarantees and agreed operational requirements. If a
	change affects those contracts, expands scope, weakens acceptance, or cannot
	be established as internal, pause affected work for the engineer. Do not
	silently interpret a behavioral change as an internal implementation choice.
	"""

_verification: """
	## Human-Run CUE Verification

	Run available, permitted project checks after inspecting their scripts for
	unsafe writes, installation or network operations. CUE validation/generation
	may run when explicitly authorized and available; edit CUE source, not the
	generated configuration. Validate before generating. If a command is denied
	or unavailable, never install tools or use a wrapper/child to bypass it. Ask
	the engineer to run the exact check, record their output as human-run evidence,
	and retain any independent-review limitation. Human/worker reports are not
	independent reproduction. Do not claim an unrun or denied check passed.
	"""
