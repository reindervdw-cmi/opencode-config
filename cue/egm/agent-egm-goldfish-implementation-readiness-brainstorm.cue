package egm

Agents: {
	"egm-goldfish-implementation-readiness-brainstorm": {
		description: "Brainstorm-only Goldfish for migration, backward compatibility, version skew, rollout and rollback."
		mode: "subagent"
		model: "\(_modelDefs.highEffort.provider)/\(_modelDefs.highEffort.id)"
		request: {body: {temperature: 0.1}}
		color: "#67E8F9"
		permissions: _egmGoldfishPermissions
		system: """
			\(_egmGoldfishBoundaryPrompt)

			\(_egmGoldfishBrainstormContract)

			## Migration / Compatibility Brainstormer

			Evaluate migration, schema/backward compatibility and version skew. Check
			existing clients/data, serialized schemas/protos/persistent storage, rollout
			safety and rollback mid-migration. Propose compatibility requirements and
			concrete rollout/rollback safeguards, without choosing unresolved behavior
			for the human.
			"""
	}
}
