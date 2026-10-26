---
name: egm-drift-report
description: Compare checked-in designs or READMEs against current code and report only documentation/implementation divergences.
license: Apache-2.0
disable-model-invocation: true
---

# EGM Drift Report

OpenCode adaptation of upstream `skills/egm_drift_report/SKILL.md`.
Read `../egm-review/references/execution_instructions.md`. This is a requested
inspection and Markdown report, not authorization to repair code or documents.

1. Require a directory containing designs or READMEs. If absent ask for the
   directory and wait. Confirm the workspace and report destination.
2. List its documents with glob. Process each document sequentially to avoid
   overflowing review output.
3. Read the design's intent, contracts, changes, filenames and symbols. Locate
   corresponding source with glob/grep; if links are missing, ask the human to
   add them to make future checks cheaper. Read the CURRENT source, not memory.
4. Compare specification versus implementation for:
   - Missing or unimplemented features.
   - Incomplete models: absent fields in classes/dataclasses/structs/protos.
   - Logic shortcuts, including hardcoded values in place of planned behavior.
   - Architectural divergence: different patterns/libraries/contracts.
   - Significant implemented behavior not referenced in the design/README.
   Double-check coverage and distinguish proposed/unimplemented work from
   drift of an already implemented specification. Report unavailable evidence
   as a limitation, not an invented divergence or clean result.
5. Append each document's analysis to `{YYYY-MM-DD}_DRIFT_REPORT.md` in the
   working directory or the approved `EGM artifact directory: <path>`:

   ```markdown
   ## <DESIGN_DOC_NAME>

   - Specific divergence, with design and source references.
   ```

   Report ONLY differences; do not describe matching behavior. If a document
   fully matches, write `No drift detected.` under its heading. Do not claim
   this when required evidence was unreadable. Notify the human with the path.
