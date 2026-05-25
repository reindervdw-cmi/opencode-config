# CUE is the source of truth. Run 'make' to generate opencode.json.
# Edit config.cue and agents.cue — never edit opencode.json directly.

.PHONY: build clean validate

build:
	cue export . --out json -o opencode.json

clean:
	rm -f opencode.json

validate:
	cue vet .
