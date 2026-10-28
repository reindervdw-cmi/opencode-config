package court

Agents: "magister-goldfish-style-review": {
	description: "Independent Court copy editing: factual, precise and concise language without promotional claims."
	mode:        "subagent"
	model:       "\(_modelDefs.lowEffort.provider)/\(_modelDefs.lowEffort.id)"
	request: body: temperature: 0.1
	color:       "#67E8F9"
	permissions: _reviewPermissions
	system:      "\(_reviewBoundary)\n\n\(_lensBlocks.style)"
}
