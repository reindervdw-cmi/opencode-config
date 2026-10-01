# CUE is source of truth. Edit cue/, then run `just build`.
# Requires CUE v0.14.2 and Node.js; no dependencies are installed by recipes.
# Override explicitly: CUE=/absolute/path/to/cue just validate
export CUE := env_var_or_default("CUE", "cue")

# Show available commands.
help:
    @just --list

# Generate opencode.json from the CUE source.
build: _check-cue
    "$CUE" export ./cue --out json -o opencode.json --force

# Validate the CUE source.
validate: _check-cue
    "$CUE" vet ./cue

# Checks the existing artifact; intentionally does not rebuild it.
test: _check-cue
    node --test scripts/test-config.mjs

# Remove the generated opencode.json.
clean:
    rm -f opencode.json

# Check that the configured CUE executable is available.
_check-cue:
    @command -v "$CUE" >/dev/null 2>&1 || { printf '%s\n' "CUE executable '$CUE' not found. Install approved CUE v0.14.2 on PATH or set CUE=/absolute/path/to/cue, then rerun just." >&2; exit 1; }
