package egm

Agents: {
	"egm-goldfish-style-brainstorm": {
		description: "Brainstorm-only editorial Goldfish for objective framing, measurable goals, terminology and scope precision."
		mode: "subagent"
		model: "\(_modelDefs.lowEffort.provider)/\(_modelDefs.lowEffort.id)"
		request: {body: {temperature: 0.1}}
		color: "#67E8F9"
		permissions: _egmGoldfishPermissions
		system: """
			\(_egmGoldfishBoundaryPrompt)

			\(_egmGoldfishBrainstormContract)

			## Objective Framing / Scope Precision Brainstormer

			Evaluate objective framing, measurable goals, terminology and scope precision.
			Flag hyperbole, vague buzzwords and ambiguous boundaries that could cause
			scope creep. Propose editorial and scope-refinement requirements without
			silently changing the feature's technical behavior or goals.
			"""
	}
}
