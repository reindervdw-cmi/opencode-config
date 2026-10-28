package interactive

Agents: {
	"developer-lite": {
		description: "Implements bounded, fully specified tasks in assigned files. Stops for unresolved decisions or failed repair-and-retest."
		mode:        "subagent"
		model:       "\(_modelDefs.lowEffort.provider)/\(_modelDefs.lowEffort.id)"
		request: {body: {temperature: 0.4}}
		color:       "#34D399"
		permissions: Agents["developer"].permissions
		system:      """
			\(_interactiveDeveloperPrompt)

			## Bounded Worker Limits

			- Accept only bounded tasks with explicit scope, ownership, verification commands. Missing correctness-critical details: stop; return `AWAITING_CLARIFICATION` to the coordinator.
			- Stop/ask about unspecified architecture/design/requirements; never implement guesses.
			- Verification failure: at most one focused repair and failing-check rerun. If unsuccessful, stop; report `INCOMPLETE`, exact commands/results/output, remaining work. No second cycle or repeated cause guesses.

			\((_shellPermissionPrompt & {#rules: permissions}).out)

			\(_brevitySkill)
			"""
	}
}
