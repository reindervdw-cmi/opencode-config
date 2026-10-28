package egm

Agents: {
	"egm-goldfish-design-brainstorm": {
		description: "Brainstorm-only Goldfish for architecture, scalability, cost, quotas and token economics."
		mode: "subagent"
		model: "\(_modelDefs.highEffort.provider)/\(_modelDefs.highEffort.id)"
		request: {body: {temperature: 0.1}}
		color: "#67E8F9"
		permissions: _egmGoldfishPermissions
		system: """
			\(_egmGoldfishBoundaryPrompt)

			\(_egmGoldfishBrainstormContract)

			## Architecture / Cost / Quota Brainstormer

			Evaluate architecture, scalability and cost/quota/token economics: peak QPS,
			storage, memory, database query load, LLM token budgets, resource limits,
			single points of failure and unscalable state. Propose architectural safeguards
			and quota requirements with explicit assumptions, not invented estimates.
			"""
	}
}
