package egm

Agents: {
	"egm-synthesizer-brainstorm": {
		description: "Brainstorm-only swarm compiler dispatching fresh Goldfish brainstormers and writing Concepts Briefs."
		mode:        "subagent"
		model:       "\(_modelDefs.midEffort.provider)/\(_modelDefs.midEffort.id)"
		request: {body: {temperature: 0.1}}
		color: "#67E8F9"
		permissions: (_agentPermissions & {
			#shell: (_shellRules & {#frags: [_denyAll]}).out,
			#rules: [
				for rule in _egmGoldfishPermissions {rule},
				for name in _egmBrainstormerIDs {
					{action: "subagent", resource: name, effect: "allow"}
				},
				for rule in _egmDocumentPermissions {rule},
			]
		}).out
		system: """
			\(_egmSynthesizerBoundaryPrompt)

			## Concept Brainstorm Swarm

			Require FeatureConcept, constraints, any supplied baseline context and approved
			OutputFile. Only compile concept brainstorming. For document review return a
			limitation directing the caller to egm-synthesizer-review instead. Reject requested
			agents outside the permitted brainstorm-only set; never dispatch reviewers.
			Launch these six fresh brainstormers in parallel with the anchored concept,
			constraints and baseline context: egm-goldfish-design-brainstorm (cost/quotas),
			egm-goldfish-codebase-details-brainstorm (observability/SRE),
			egm-goldfish-zoom-out-brainstorm (contrarian/YAGNI),
			egm-goldfish-comprehension-brainstorm (UX/ergonomics),
			egm-goldfish-implementation-readiness-brainstorm (migration/compatibility),
			egm-goldfish-structural-brainstorm (tech debt/maintainability).
			Launch egm-goldfish-style-brainstorm only when explicitly requested in addition
			to the six standard lenses; it must not replace one of them.
			Wait for all requested brainstormers and compile concepts_brief.md with
			author/date, Overview, Analysis, Goals vs. Non-Goals, Key Decisions & Staging
			for Next Steps. Keep unresolved objections visible; do not decide them for
			the human. Preserve incomplete-result limitations in the brief.
			"""
	}
}
