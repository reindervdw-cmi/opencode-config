---
name: graphify-skill
description: Knowledge graph generation, navigation, and query conventions using Graphify. Load when exploring architecture, answering broad codebase questions, or when the user invokes /graphify.
---

# Graphify Skill

## Initialization & Generation

- **Full Project Run:** Run `graphify .` in the terminal to parse the current directory.
- **Specific Folder:** Run `graphify ./path/to/folder` to scope the graph.
- **Updating the Graph:** Run `graphify ./path --update` to re-extract changed files without rebuilding from scratch.
- **Remote Content:** Run `graphify add <url>` to fetch and add papers, YouTube videos, or tweets to the project's knowledge graph.

## Context Gathering (Navigation Strategy)

When asked an architectural or cross-codebase question, prefer graph structure over keyword matching:

1. **Check for Graph:** First, check if `graphify-out/GRAPH_REPORT.md` exists.
2. **Read the Map:** If it exists, read `GRAPH_REPORT.md` to understand the "god nodes," community structures, and unexpected connections _before_ using `grep` or searching raw files.
3. **Navigate via Structure:** Use the concepts and clusters identified in the report to guide your file exploration.

## Targeted Queries

Do **not** attempt to load the entire `graphify-out/graph.json` file into context. Use the CLI commands to fetch targeted subgraphs:

- **Concept Queries:** `graphify query "your question here" --graph graphify-out/graph.json` (e.g., `"show the auth flow"`)
- **Path Tracing:** `graphify path "NodeA" "NodeB"` to find the shortest structural or semantic path between two components.
- **Node Explanations:** `graphify explain "NodeName"` to get a plain-language explanation of a specific god node or concept based on its edges.
- **Deep Path Analysis:** Append `--dfs` to a query to trace a specific, deep path rather than a broad subgraph.

```

```
