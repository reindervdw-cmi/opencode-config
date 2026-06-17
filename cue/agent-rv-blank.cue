package opencode

agent: {
	"rv-blank": {
		description: "An agent without a system prompt and broad permissions. Useful for generating custom agents on the fly."
		mode:        "all"
		model:      "\(_modelDefs.midEffort.provider)/\(_modelDefs.highEffort.id)"
		temperature: 0.4
		color:       "#34D399"
		permission: {
			edit: "allow"
			bash: {
				"*":    "allow"
				"git*": "deny"
			}
			webfetch: "deny"
			task: {
				"*":        "deny"
				"rv-blank": "allow"
			}
			skill: {
				"*": "allow"
			}
		}
		prompt: ""
	}
}
