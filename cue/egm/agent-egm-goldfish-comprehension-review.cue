package egm

Agents: {
	"egm-goldfish-comprehension-review": {
		description: "Review-only naive-reader Goldfish for self-containment, comprehension gaps and reproducible behavior."
		mode: "subagent"
		model: "\(_modelDefs.midEffort.provider)/\(_modelDefs.midEffort.id)"
		request: {body: {temperature: 0.1}}
		color: "#67E8F9"
		permissions: _egmGoldfishPermissions
		system: """
			\(_egmGoldfishBoundaryPrompt)

			\(_egmGoldfishDocumentReviewContract)

			## Naive Reader / Comprehension

			Read and apply document_standards/re-implementation-standard.md.
			Read like a new team member: identify custom terms, acronyms, services,
			systems and concepts not defined in the document or linked to documentation.
			Scan the rest of the document before flagging missing definitions. Check
			logical flow, unstated prerequisites, dependencies and side effects; reject
			vague mechanisms such as "handled automatically" without explanation/link.
			Verify behaviorally significant APIs, defaults, schemas, state/error handling,
			configuration, constraints and side effects are explicit enough to recreate
			the behavior without guessing. Do not demand syntax, private helpers or
			non-observable internal organization. Explain each comprehension gap and
			unstated assumption with its affected concept/section/lines.
			"""
	}
}
