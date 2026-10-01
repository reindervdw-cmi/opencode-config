---
name: typescript-dev
description: Conventions and verification commands for TypeScript/JavaScript projects.
---

# TypeScript / JavaScript Development Skill

Use repository instructions already supplied by OpenCode and inspect
`package.json` scripts and devDependencies, lockfile, and workspace/type-check
config. Ask for missing or ambiguous context. Follow established package
manager/tooling. Inspect scripts for fix/write, snapshot-update, code-generation,
install, and global-state side effects before running them.

## Verification Commands (Non-Mutating Checks)

Prefer inspected project scripts with scoped arguments. Examples below use
already-installed local binaries from package root; no `npx` implicit downloads
or package install/setup as verification. If dependencies are absent, report
limit and ask before setup. Adapt to workspace tooling without changing config.

Type checking uses affected project's configuration (passing individual files
can ignore `tsconfig.json`). `--incremental false` avoids build-info writes for
compatible configs; use project's approved no-write script for composite/build
setups instead of blindly overriding options:

```sh
./node_modules/.bin/tsc --project path/to/tsconfig.json --noEmit --incremental false
```

Lint and formatting checks on owned changed files, only when tools configured:

```sh
./node_modules/.bin/eslint path/to/changed.ts
./node_modules/.bin/prettier --check path/to/changed.ts
```

Run configured test runner only, scoped to relevant tests, without watch mode or
snapshot updates:

```sh
./node_modules/.bin/jest --runInBand path/to/affected.test.ts
./node_modules/.bin/vitest run path/to/affected.test.ts
```

Do not add tools to follow these examples. Checks may create caches; inspect
local configuration and disable writes where required. `eslint --fix`,
`prettier --write`, snapshot updates, and generated-file changes require scoped
implementation intent and owned paths, not automatic cleanup.

## Workflow

1. **Before editing**: inspect tooling and capture affected baseline checks.
2. **After editing**: type-check affected project, lint/format-check owned changed
   files, and run tests covering changed behavior and relevant integrations.
3. **Before delivery**: broaden checks when local policy or cross-cutting risk
   requires it; no unconditional repo-wide lint/test/fix commands.
4. Preserve stderr and exit status for every command; no `|| true`, discarded
   diagnostics, or filtered pipelines that hide failures. Report baseline errors
   separately; never fix unrelated errors automatically.
5. Report unavailable tooling, permissions, or network as exact verification
   limits. Do not claim unrun checks passed or mutate environment to hide gaps.

## Key Conventions

- Use explicit return types on exported functions
- Avoid `any` — use `unknown` and narrow, or document why `any` is necessary
- Add a JSDoc docstring to any exported function or public method.
