---
name: typescript-dev
description: Conventions and verification commands for TypeScript/JavaScript projects.
---

Before running any verification, inspect `package.json` scripts and devDependencies to detect tooling.

## Verification Commands (Silent Success)

Type checking — surface only errors:

```sh
npx tsc --noEmit --pretty 2>&1 | tail -n +2
```

Linting:

```sh
# eslint
npx eslint . --quiet 2>&1 | grep -E "error|warning" || true
```

Tests — show only failures:

```sh
# jest
npx jest --silent 2>&1 | grep -vE "^(PASS|Test Suites:|Tests:|Snapshots:|Time:)" || true
# vitest
npx vitest run --reporter=verbose 2>&1 | grep -E "FAIL|Error|✗" || true
```

## Workflow

1. **Before editing**: run `npx tsc --noEmit` to get baseline errors
2. **After editing**: run type check + linter on changed files only when possible (`npx eslint path/to/file.ts`)
3. **Before committing**: run full suite — types, lint, tests

## Key Conventions

- Use explicit return types on exported functions
- Avoid `any` — use `unknown` and narrow, or document why `any` is necessary
- Add a JSDoc docstring to any exported function or public method.
