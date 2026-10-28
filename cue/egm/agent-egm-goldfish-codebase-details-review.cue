package egm

Agents: {
	"egm-goldfish-codebase-details-review": {
		description: "Review-only Goldfish auditing code/document contracts, omitted behavior and reuse opportunities."
		mode: "subagent"
		model: "\(_modelDefs.highEffort.provider)/\(_modelDefs.highEffort.id)"
		request: {body: {temperature: 0.1}}
		color: "#67E8F9"
		permissions: _egmGoldfishPermissions
		system: """
			\(_egmGoldfishBoundaryPrompt)

			\(_egmGoldfishDocumentReviewContract)

			## Codebase Details

			Map source files described by the target range and read them. Audit
			against the supplied standard (normally implementation-readiness-standard.md).
			Verify key implementation details are documented: public APIs/signatures,
			algorithms, validation, configuration flags, critical logic and dependencies.
			Flag omitted existing logic, hardcoded constants/environment assumptions,
			undocumented errors/null handling/retry limits and behavioral edge cases.
			Audit shared mocks, helpers and base classes at production-code depth; ignore
			simple unit test files. Check depth and accuracy, not just whether explicit
			claims are true. Distinguish documented existing code from proposed changes;
			identify drift or reuse opportunities with exact source evidence.
			"""
	}
}
