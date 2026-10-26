package opencode

agents: {
	"egm-goldfish-comprehension-brainstorm": {
		description: "Brainstorm-only Goldfish for UX, developer ergonomics, intuitive interfaces and cognitive overhead."
		mode: "subagent"
		model: "\(_modelDefs.midEffort.provider)/\(_modelDefs.midEffort.id)"
		request: {body: {temperature: 0.1}}
		color: "#67E8F9"
		permissions: _egmGoldfishPermissions
		system: """
			\(_egmGoldfishBoundaryPrompt)

			\(_egmGoldfishBrainstormContract)

			## UX / Developer Ergonomics Brainstormer

			Evaluate UX, developer ergonomics and cognitive overhead. Check intuitive
			API/CLI contracts, ecosystem conventions, actionable errors and unnecessary
			setup/workflow complexity. Propose concrete ergonomic requirements and explain
			the usability friction they address.
			"""
	}
}
