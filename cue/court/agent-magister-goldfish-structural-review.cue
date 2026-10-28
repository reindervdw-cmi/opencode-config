package court

Agents: "magister-goldfish-structural-review": {
	description: "Independent Court structural review: proportionate plan information, heading hierarchy and valid Markdown."
	mode:        "subagent"
	model:       "\(_modelDefs.lowEffort.provider)/\(_modelDefs.lowEffort.id)"
	request: body: temperature: 0.1
	color:       "#67E8F9"
	permissions: _reviewPermissions
	system:      "\(_reviewBoundary)\n\n\(_lensBlocks.structural)"
}
