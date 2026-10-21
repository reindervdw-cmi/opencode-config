---
name: python-dev
description: Python development conventions using uv, pytest, ruff, and mypy/ty. Load this skill when working on any Python project.
---

# Python Development Skill

## uv (Environment & Deps)

- Prefer existing project environment via `uv run --no-sync <cmd>` for checks;
  this avoids implicit dependency synchronization. An environment must exist.
- `uv sync`, `uv venv`, and `uv add` mutate environment/dependencies. Use only
  with explicit setup/dependency intent; no automatic installs during checks.

## Conventions

- Inspect pyproject.toml for guidance on Python version and dependencies; in particular the linter and type checker.
- Follow Google-style imports: import modules, not classes or functions; access members through their module. The typing module (and equivalents from collections) are exempt.
- Type all function signatures; prefer modern union/collection types and `pathlib.Path`. Avoid unexplained `Any` or suppressions.
- Use snake_case, PascalCase classes, and SCREAMING_SNAKE_CASE constants. Include module docstrings and public function/class docstrings; comments explain intent.
- Annotate constants with the Final type.
- Prefer immutable types.
- Prefer lazy imports in Python 3.15+.
- Public functions/classes must always have Google-style docstrings. Complex private functions should have them.
