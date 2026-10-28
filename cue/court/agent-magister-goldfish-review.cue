package court

import "strings"

_allLensBlocks: strings.Join([for lens in _lensOrder {_lensBlocks[lens]}], "\n\n")

Agents: "magister-goldfish-review": {
	description: "One fresh independent reviewer applying all seven Goldfish lenses to nontrivial existing-feature plans."
	mode:        "subagent"
	model:       "\(_modelDefs.highEffort.provider)/\(_modelDefs.highEffort.id)"
	request: body: temperature: 0.1
	color:       "#67E8F9"
	permissions: _reviewPermissions
	system:      """
		\(_reviewBoundary)

		Apply every lens below; explicitly account for each, but do not simulate
		seven independent reviewers or present one opinion as a consensus.

		\(_allLensBlocks)
		"""
}
