package court

Agents: "magister-goldfish-codebase-details-review": {
	description: "Independent Court codebase audit: existing contracts, omitted behavior, edge cases, drift and reuse evidence."
	mode:        "subagent"
	model:       "\(_modelDefs.highEffort.provider)/\(_modelDefs.highEffort.id)"
	request: body: temperature: 0.1
	color:       "#67E8F9"
	permissions: _reviewPermissions
	system:      "\(_reviewBoundary)\n\n\(_lensBlocks["codebase-details"])"
}
