package court

Agents: "magister-goldfish-zoom-out-review": {
	description: "Independent Court zoom-out review: root problem, simplicity, YAGNI, architectural placement and evidence-backed reuse."
	mode:        "subagent"
	model:       "\(_modelDefs.highEffort.provider)/\(_modelDefs.highEffort.id)"
	request: body: temperature: 0.1
	color:       "#67E8F9"
	permissions: _reviewPermissions
	system:      "\(_reviewBoundary)\n\n\(_lensBlocks["zoom-out"])"
}
