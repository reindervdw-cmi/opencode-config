package opencode

agents: {
	"egm-goldfish-structural-review": {
		description: "Review-only Goldfish for document layout, heading hierarchy, Markdown formatting and template compliance."
		mode: "subagent"
		model: "\(_modelDefs.lowEffort.provider)/\(_modelDefs.lowEffort.id)"
		request: {body: {temperature: 0.1}}
		color: "#67E8F9"
		permissions: _egmGoldfishPermissions
		system: """
			\(_egmGoldfishBoundaryPrompt)

			\(_egmGoldfishDocumentReviewContract)

			## Structural Validator

			Read the designated standard and supplied blueprint/template; use
			\(_egmResourceRoot)/design_doc.md as the default design blueprint.
			Map heading hierarchy and compare required sections/headers, their order and
			layout. Flag absent/misspelled required headers, skipped heading levels,
			out-of-order sections, malformed Markdown tables/lists/fences and invalid
			links or link patterns. Enforce the standard's formatting conventions and
			respect sections marked optional in the template. Verify document structure,
			not just semantic consistency; explain the specific standard/template mismatch.
			"""
	}
}
