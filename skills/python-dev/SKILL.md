---
name: python-dev
description: Python development conventions using uv, pytest, ruff, and mypy/ty. Load this skill when working on any Python project.
---

# Python Development Skill

## uv (Environment & Deps)

- `uv sync` — install project deps. `uv venv` — create venv.
- `uv add <pkg>` / `uv add --dev <pkg>` — add deps.
- `uv run <cmd>` — always run commands through this.

## Linting & Formatting (ruff)

```bash
uv run ruff check --fix -q . && uv run ruff format -q .
```

## Type Checking

Use `ty` for type checking.

## Testing (pytest)

Use `pytest` for running unit tests with `uv run pytest`.

## Writing Tests

When writing or modifying tests, read `testing-patterns.md` in this skill directory for pytest fixtures, parametrize, assertions, running subsets, and conftest patterns. Only load it when actually writing tests.

## Verification Workflow

After any code change, run this single pipeline:

## Conventions

- Python 3.10+. Use `X | Y` not `Union[X, Y]`.
- Prefer `pathlib.Path` over `os.path`.
- Type hints on all function signatures.
- Google-style DocStrings on all public function signatures.
- Check `pyproject.toml` for project-specific tool config before assuming defaults.
