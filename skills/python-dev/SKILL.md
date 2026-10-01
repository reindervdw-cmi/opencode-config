---
name: python-dev
description: Python development conventions using uv, pytest, ruff, and mypy/ty. Load this skill when working on any Python project.
---

# Python Development Skill

## uv (Environment & Deps)

- Use repository instructions already supplied by OpenCode and inspect
  `pyproject.toml` for tooling, versions, and scope. Ask for missing or ambiguous
  context.
- Prefer existing project environment via `uv run --no-sync <cmd>` for checks;
  this avoids implicit dependency synchronization. An environment must exist.
- `uv sync`, `uv venv`, and `uv add` mutate environment/dependencies. Use only
  with explicit setup/dependency intent; no automatic installs during checks.

## Linting & Formatting (ruff)

```bash
uv run --no-sync ruff check path/to/changed.py
uv run --no-sync ruff format --check path/to/changed.py
```

Use owned changed files or affected package paths, not unconditional `.`.
Fixes (`ruff check --fix`, `ruff format` without `--check`) require scoped
implementation intent; never fix unrelated baseline errors automatically.

## Type Checking

Use project's configured checker (`ty`, or `mypy` if established). Type-check
affected package with dependencies, not isolated files if that loses context:

```bash
uv run --no-sync ty check path/to/affected_package
```

For mypy projects: `uv run --no-sync mypy path/to/affected_package`. Do not add
a checker dependency just to follow this skill.

## Testing (pytest)

Run focused tests covering changed behavior and relevant integrations:

```bash
uv run --no-sync pytest tests/test_affected.py
```

## Verification Workflow

1. Before editing, inspect configured tooling and run affected baseline checks.
2. After editing, run scoped lint, format check, type check, and relevant tests.
3. Broaden only for cross-cutting risk or local delivery policy. Checks do not
   authorize snapshots, generated-file updates, or unrelated source edits.
4. Preserve stderr and each command's exit status; no `|| true`, error-discarding
   redirects, or filtered pipelines. Report baseline failures separately.
5. If tooling/environment/network is unavailable, report exact unverified scope
   rather than installing dependencies or claiming success. Tests/type checkers
   may create caches; inspect local scripts and disable writes where required.

## Conventions

- Python 3.10+. Use `X | Y` not `Union[X, Y]`.
- Prefer `pathlib.Path` over `os.path`.
- Type hints on all function signatures.
- Google-style DocStrings on all public function signatures.
- Check `pyproject.toml` for project-specific tool config before assuming defaults.
