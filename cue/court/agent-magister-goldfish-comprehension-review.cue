package court

Agents: "magister-goldfish-comprehension-review": {
	description: "Independent Court naive-reader review: self-containment, prerequisites and reproducible observable behavior."
	mode:        "subagent"
	model:       "\(_modelDefs.midEffort.provider)/\(_modelDefs.midEffort.id)"
	request: body: temperature: 0.1
	color:       "#67E8F9"
	permissions: _reviewPermissions
	system:      "\(_reviewBoundary)\n\n\(_lensBlocks.comprehension)"
}
