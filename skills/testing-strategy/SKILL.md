---
name: testing-strategy
description: Language-agnostic testing strategy and philosophy. Load when writing tests, running test suites, or verifying test quality.
---

# Testing Strategy

## Scoping Strategy

Run the narrowest scope that gives you confidence:

| Situation             | Scope                                                               |
| --------------------- | ------------------------------------------------------------------- |
| Fixing a specific bug | Run only the test file or test case covering that module            |
| Adding a new feature  | Run the new tests plus any integration tests touching the same area |
| Refactoring           | Run the full suite for the affected module                          |
| Before committing     | Run the full suite                                                  |

## Test Philosophy

- **Test behavior, not implementation.** Tests should break only when the observable behavior changes, not when internals are refactored.
- **One assertion per concept.** A test can have multiple `assert` lines if they all verify a single logical outcome. Don't cram unrelated checks into one test.
- **Readable names.** Test names should read as sentences: `test_returns_empty_list_when_no_results`, not `test_1`.
- **Minimal setup.** If a test needs more than a few lines of setup, extract a fixture or helper — but only if multiple tests share it.
- **No test interdependence.** Each test must be runnable in isolation. Never rely on state left by a previous test.

## Test-Driven Patterns

**Reproducing bugs as tests:**

1. Write a failing test that demonstrates the bug before touching the implementation.
2. Confirm the test fails for the right reason (not a test error — an assertion failure).
3. Fix the implementation until the test passes.
4. Run the full relevant suite to confirm no regressions.

**Writing tests before implementation:**

1. Define the expected behavior as one or more tests.
2. Run them to confirm they fail (red).
3. Write the minimal implementation to make them pass (green).
4. Refactor if needed — the tests are your safety net.
