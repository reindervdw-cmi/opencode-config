# CUE is the source of truth. Run 'make' to generate opencode.json.
# Edit files in cue/ — never edit opencode.json directly.

CUE ?= $(shell command -v cue 2>/dev/null || echo $(shell go env GOPATH)/bin/cue)

.PHONY: build clean validate

build:
	$(CUE) export ./cue --out json -o opencode.json --force

clean:
	rm -f opencode.json

validate:
	$(CUE) vet ./cue
