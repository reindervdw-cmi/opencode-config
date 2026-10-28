package court

Agents: "magister-goldfish-design-review": {
	description: "Independent Court design review: architecture, alternatives, constraints, economics and material risks."
	mode:        "subagent"
	model:       "\(_modelDefs.highEffort.provider)/\(_modelDefs.highEffort.id)"
	request: body: temperature: 0.1
	color:       "#67E8F9"
	permissions: _reviewPermissions
	system:      "\(_reviewBoundary)\n\n\(_lensBlocks.design)"
}
