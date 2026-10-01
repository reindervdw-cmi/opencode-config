# Bundled LSP tools

**Internal use only.** This inventory records observed artifacts, not a license
or grant of redistribution rights. Provenance and notice review remain
publication gates.

## Inventory

All seven `.ts` files are installation inputs. Each exports a default OpenCode
tool and contains bundled JavaScript despite its TypeScript filename.

| Artifact / tool name | Behavior |
| --- | --- |
| `lsp_codeactions.ts` / `lsp_codeactions` | List code actions for a range; optionally execute a selected action, including edits or server commands. |
| `lsp_definition.ts` / `lsp_definition` | Find a symbol's definition. |
| `lsp_documentsymbol.ts` / `lsp_documentsymbol` | List symbols in a document. |
| `lsp_hover.ts` / `lsp_hover` | Retrieve type information and documentation at a position. |
| `lsp_references.ts` / `lsp_references` | Find references across a workspace. |
| `lsp_rename.ts` / `lsp_rename` | Preview rename edits; write changes only when `apply: true`. |
| `lsp_workspacesymbol.ts` / `lsp_workspacesymbol` | Search workspace symbols; optionally select a file to identify the language server. |

Position arguments use zero-based lines and characters. File arguments expect
absolute paths. Rename and executed code actions can mutate files; respect
configured permissions and workflow authorization. Preview/discovery does not
authorize applying changes.

## Installation prerequisites

Install all seven artifacts under the chosen OpenCode configuration directory's
`tools/` directory, alongside generated configuration and locked npm manifests.
Follow [root installation instructions](../README.md) for isolation and
`npm ci --ignore-scripts --no-audit --no-fund`. External imports include
`@opencode-ai/plugin`, pinned by this repository to **1.17.8**, plus Node built-ins.
Use the manifest's supported Node range, **`^22.22.2 || ^24.15.0 || >=26.0.0`**,
and npm **11+**. These requirements are not a claim of tested tool execution.

Tools spawn these hard-coded commands from the workspace root; executables must
be on OpenCode's `PATH`. They do not consult OpenCode's native `lsp` settings.

| Language | Command | Project prerequisites |
| --- | --- | --- |
| Go | `gopls` | Go toolchain and module dependencies |
| TypeScript / JavaScript | `typescript-language-server --stdio` | Node.js, TypeScript (`tsserver`), project dependencies |
| Python | `ty server` | `ty` and target project's Python environment |
| Rust | `rust-analyzer` | Rust toolchain and project dependencies |

Server versions are not pinned or runtime-tested here. Install only approved
servers needed for a target project; npm dependency installation does not
install these executables. Native Python `ruff server` configuration is separate
and is not used by these custom tools. No global dependency installs were part
of completed smoke checks.

## Provenance evidence and unresolved gates

Observed evidence in the seven artifacts:

- Bundler-style helpers and repeated module blocks identify embedded
  `node_modules/vscode-jsonrpc/lib/common/*`, `lib/node/*`, and `node.js` code.
- Source-path comments identify `.opencode/tools/lsp_*.ts`,
  `.opencode/tools/lib/language-config.ts`, and
  `.opencode/tools/lib/lsp-client.ts`.
- Runtime imports reference `@opencode-ai/plugin` and Node built-ins. Root npm
  manifests pin the plugin API, but do not establish the embedded JSON-RPC
  version or the origin of the custom tool implementation.
- This checkout has bundled artifacts, not the source/build configuration needed
  to reproduce them. No tool rebuild recipe is documented here.

Comments and module paths are evidence of included code, **not** proof of
authorship, upstream revision, exact dependency versions, or licensing rights.
Do not infer redistribution permission from repository possession, internal-use
wording, or the plugin dependency's license.

Before publication or redistribution, an authorized maintainer must:

1. Establish custom-tool authorship/ownership, original source location and
   revision, modifications, and permission to distribute.
2. Recover the build configuration and exact embedded dependency versions;
   verify correspondence between source and these bundles.
3. Review applicable upstream licenses and required copyright, license, and
   attribution notices for embedded code and distributed dependencies; preserve
   or supply required notices based on verified evidence.
4. Resolve rights and notice findings before releasing a bundle. These gates do
   not prevent documenting or verifying the existing artifacts internally.

No upstream rights, license, or completed notice review is asserted here.
Tracked-file and reachable Git-history secret/database scans remain separate
publication gates; this inventory does not clear history or credentials.

## Verification boundary

Completed isolated CLI smoke on OpenCode **1.18.33** loaded all **14 agents** and
both forge skills (`github-cli`, `ado-cli`). Locked dependency installation and
plugin `tool` API import passed. Those results do not establish that all seven
custom tools initialized or executed successfully.

Detailed `debug agent` inspection timed out after **60 seconds**; custom-tool
initialization, language-server startup, and tool execution remain unverified.
Smoke used Node **24.13**, below the declared `ini@7.0.0` support range, and npm
**11.17**; a supported-Node smoke remains outstanding. No live model or forge
execution is claimed. Reviewer audit is pending.
