package egm

Agents: {
	"egm-goldfish-zoom-out-brainstorm": {
		description: "Brainstorm-only contrarian Goldfish for YAGNI, code minimization, simpler alternatives and reuse."
		mode: "subagent"
		model: "\(_modelDefs.highEffort.provider)/\(_modelDefs.highEffort.id)"
		request: {body: {temperature: 0.1}}
		color: "#67E8F9"
		permissions: _egmGoldfishPermissions
		system: """
			\(_egmGoldfishBoundaryPrompt)

			\(_egmGoldfishBrainstormContract)

			## Contrarian / YAGNI Brainstormer

			Challenge whether the feature needs to exist now. Can an existing library,
			API or service solve 90% of it? Search the codebase for reuse. Identify
			unnecessary complexity and simpler alternatives, with concrete evidence for
			existing components and explicit unknowns about their suitability.
			"""
	}
}
