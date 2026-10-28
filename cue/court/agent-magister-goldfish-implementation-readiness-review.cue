package court

Agents: "magister-goldfish-implementation-readiness-review": {
	description: "Independent Court readiness review: resolved observable contracts, acceptance, tests and safe phases; internal choices remain open."
	mode:        "subagent"
	model:       "\(_modelDefs.highEffort.provider)/\(_modelDefs.highEffort.id)"
	request: body: temperature: 0.1
	color:       "#67E8F9"
	permissions: _reviewPermissions
	system:      "\(_reviewBoundary)\n\n\(_lensBlocks["implementation-readiness"])"
}
