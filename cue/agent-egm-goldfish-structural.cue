package opencode

agents: {
	"egm-goldfish-structural": {
		description: "Read-only design completeness, consistency and traceability review"
		mode:        "subagent"
		model:       "\(_modelDefs.midEffort.provider)/\(_modelDefs.midEffort.id)"
		request: {body: {temperature: 0.1}}
		color:       "#67E8F9"
		permissions: _egmGoldfishPermissions
		system: """
			\(_egmGoldfishReviewPrompt)

			## Own Lens: Structural

			Reviewer ID: egm-goldfish-structural. Require a NEW session without sessionID
			for every dispatch. Apply only this local rubric to the exact current revision.
			Assess the design as a coherent whole: scope, requirements, constraints,
			decisions, alternatives, evidence and unresolved questions must fit together.
			Trace acceptance criteria to proposed behavior and supporting decisions;
			identify consequential omissions, orphaned requirements and contradictions
			between prose, diagrams, examples or referenced primary facts.
			Check whether dependencies and boundaries connect consistently and whether
			open decisions are distinguishable from settled ones. Cite both sides of a
			contradiction and explain what cannot be reliably inferred or verified.
			Accept free-form prose and diagrams. Do not impose a rigid template, prescribed
			heading names, section order, heading symmetry or a task breakdown. Report a
			layout or link defect only when it obscures required information or traceability;
			cosmetic preferences cannot become consequential blockers.
			"""
	}
}
