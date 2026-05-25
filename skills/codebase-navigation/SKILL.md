---
name: codebase-navigation
description: Load when exploring an unfamiliar codebase, tracing symbol usage, or finding code structure. Covers LSP tool selection, search strategy hierarchy, and entry-point exploration patterns.
---

# Codebase Navigation Skill

## Tool Selection — Quick Decision Tree

| Question                                | Tool                              |
| --------------------------------------- | --------------------------------- |
| "Where is this symbol defined?"         | `lsp_definition`                  |
| "Who calls / imports / uses this?"      | `lsp_references`                  |
| "What type / signature does this have?" | `lsp_hover`                       |
| "Find a class or function by name"      | `lsp_workspacesymbol`             |
| "What's in this file?"                  | `lsp_documentsymbol`              |
| "Fix / refactor this symbol everywhere" | `lsp_rename` or `lsp_codeactions` |
| "Find text pattern, not a symbol"       | `grep`                            |
| "Find a file by name pattern"           | `glob`                            |

## Search Strategy Hierarchy

1. **LSP first** — for symbols (functions, classes, variables, types). More precise than text search; works across rename boundaries.
2. **grep second** — for patterns that aren't symbols: string literals, comments, config keys, regex patterns.
3. **glob last** — when you know part of a file name but not its content.

Never use grep to find a symbol when the LSP can resolve it.

## LSP Tool Guide

### `lsp_definition`

Go to the source of a symbol. Use when you have a call site and need to read the implementation.

```
lsp_definition(file, line, character)  # character = 0-based column of the symbol
```

### `lsp_references`

Find every place a symbol is used. Use before renaming, deleting, or understanding call volume.

```
lsp_references(file, line, character, includeDeclaration=false)
```

### `lsp_hover`

Get the type signature or doc comment at a position. Use when you need the exact signature before making a call, or to understand what a variable holds.

### `lsp_workspacesymbol`

Search for a symbol by name across the whole workspace. Use when you know the name but not the file.

```
lsp_workspacesymbol(query="ClassName")   # empty string "" returns all symbols
```

### `lsp_documentsymbol`

List all top-level and nested symbols in a single file. Use to get an outline of a file without reading every line. Good starting point when you open an unfamiliar file.

### `lsp_rename` / `lsp_codeactions`

`lsp_rename` — rename a symbol across the workspace (preview first with `apply=false`).
`lsp_codeactions` — list available refactoring actions at a position (quick fixes, extract, etc.).

## When to Use Graphify Instead

Prefer the **graphify** skill for:

- Architectural or cross-cutting questions ("how does the auth flow connect to the database layer?")
- Understanding community structure and "god nodes" across the whole project
- Answering questions that require graph traversal rather than single-symbol lookup

If `graphify-out/GRAPH_REPORT.md` exists in the project, start there for any broad structural question before reaching for LSP or grep. See the graphify skill for full usage.
