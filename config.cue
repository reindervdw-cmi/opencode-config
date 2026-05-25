package opencode

"$schema": "https://opencode.ai/config.json"

share: "disabled"

enabled_providers: ["litellm"]

provider: {
	litellm: {
		npm:  "@ai-sdk/openai-compatible"
		name: "LiteLLM"
		options: {
			baseURL: "https://agentic-prod-litellm.mangoocean-f4f0496c.eastus.azurecontainerapps.io"
		}
		models: {
			"bedrock/global.anthropic.claude-opus-4-6-v1": {
				name: "Claude Opus 4.6"
			}
			"bedrock/global.anthropic.claude-sonnet-4-6": {
				name: "Claude Sonnet 4.6"
			}
			"bedrock/global.anthropic.claude-haiku-4-5-20251001-v1:0": {
				name: "Claude Haiku 4.5"
			}
		}
	}
}

lsp: {
	ty: {
		command:    ["ty", "server"]
		extensions: [".py", ".pyi"]
	}
	ruff: {
		command:    ["ruff", "server"]
		extensions: [".py", ".pyi"]
	}
}
