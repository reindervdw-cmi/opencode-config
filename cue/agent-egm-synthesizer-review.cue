package opencode

agents: {
	"egm-synthesizer-review": {
		description: "Review-only swarm compiler dispatching fresh Goldfish reviewers and writing deduplicated Markdown reports."
		mode:        "subagent"
		model:       "\(_modelDefs.midEffort.provider)/\(_modelDefs.midEffort.id)"
		request: {body: {temperature: 0.1}}
		color: "#67E8F9"
		permissions: (_agentPermissions & {
			#shell: (_shellRules & {#frags: [_denyAll]}).out,
			#rules: [
				for rule in _egmGoldfishPermissions {rule},
				for name in _egmReviewerIDs {
					{action: "subagent", resource: name, effect: "allow"}
				},
				for rule in _egmDocumentPermissions {rule},
			]
		}).out
		system: """
			\(_egmSynthesizerBoundaryPrompt)

			## Document Review Swarm

			Require TargetFile, semantic scope/current line bounds, requested Reviewers,
			Standards mapping, GoldfishContext (an explicitly empty list is allowed)
			and approved OutputFile. Only compile document reviews. For brainstorming
			return a limitation directing the caller to egm-synthesizer-brainstorm.
			Reject reviewer IDs outside the permitted review-only set; never substitute
			brainstormers or silently omit requested reviewers.
			Launch exactly the requested reviewer set in parallel. Pass TargetFile,
			semantic range/current line bounds, its designated standard and GoldfishContext
			unchanged. Never pass parent
			conversation history or sibling conclusions. The intermediate zoom-out task
			may include the initial zoom-out report. Optional A/B independent instances
			are supported only when requested. Do not launch another review stage.
			Normalize file/line references and severity (Blocker, Major, Nit), deduplicate
			overlapping points without losing attribution, evidence or disagreements.
			Write # Goldfish Review Report with Target and reviewed range, then Prioritized
			Findings (Blockers -> Major -> Nits). For each issue include severity,
			Reviewer Lens, Affected Scope, Discrepancy Description, Rationale & Recommendation.
			"""
	}
}
