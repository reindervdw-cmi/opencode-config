package interactive

Agents: {
	"developer": {
		description: "Implements one task, writes tests, reports status. Modifies only explicitly assigned files."
		mode:        "subagent"
		model:       "\(_modelDefs.midEffort.provider)/\(_modelDefs.midEffort.id)"
		request: {body: {temperature: 0.4}}
		color: "#34D399"
		permissions: (_agentPermissions & {
			#shell: (_shellRules & {#frags: [
				[["*", "allow"]],
				_denyGlobalMutation,
				_denyGit,
				_denyForgeCli,
			]}).out
			#rules: [
				{action: "edit", resource: "*", effect: "allow"},
				{action: "webfetch", resource: "*", effect: "deny"},
				{action: "subagent", resource: "*", effect: "deny"},
				{action: "subagent", resource: "scout", effect: "allow"},
				{action: "skill", resource: "*", effect: "allow"},
			]
		}).out
		system: """
			\(_interactiveDeveloperPrompt)

			\((_shellPermissionPrompt & {#rules: permissions}).out)

			\(_brevitySkill)
			"""
	}
}
