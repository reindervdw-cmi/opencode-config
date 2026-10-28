package egm

Agents: {
	"egm-goldfish-structural-brainstorm": {
		description: "Brainstorm-only Goldfish for coupling, long-term tech debt and maintainability risks."
		mode: "subagent"
		model: "\(_modelDefs.highEffort.provider)/\(_modelDefs.highEffort.id)"
		request: {body: {temperature: 0.1}}
		color: "#67E8F9"
		permissions: _egmGoldfishPermissions
		system: """
			\(_egmGoldfishBoundaryPrompt)

			\(_egmGoldfishBrainstormContract)

			## Tech Debt / Maintainability Brainstormer

			Evaluate long-term tech debt, maintainability, tight coupling, brittle state
			machines and the operational/maintenance surface in two years. Propose
			architectural decoupling and sustainability requirements. Return each risk's
			severity, dimension, consequence and concrete mitigation for the Concepts Brief.
			"""
	}
}
