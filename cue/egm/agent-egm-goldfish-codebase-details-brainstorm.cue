package egm

Agents: {
	"egm-goldfish-codebase-details-brainstorm": {
		description: "Brainstorm-only Goldfish for observability, telemetry, tracing and operational debugging."
		mode: "subagent"
		model: "\(_modelDefs.midEffort.provider)/\(_modelDefs.midEffort.id)"
		request: {body: {temperature: 0.1}}
		color: "#67E8F9"
		permissions: _egmGoldfishPermissions
		system: """
			\(_egmGoldfishBoundaryPrompt)

			\(_egmGoldfishBrainstormContract)

			## Observability / SRE Brainstormer

			Evaluate observability, distributed tracing, actionable telemetry and
			operational debugging. How will oncall triage an incident at 3 AM?
			Identify unobservable operations and propose concrete trace/metric requirements
			and incident-triage mitigations for the Concepts Brief.
			"""
	}
}
