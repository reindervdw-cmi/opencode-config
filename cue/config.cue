package opencode

"$schema": "https://opencode.ai/config.json"

_modelDefs: {
    highEffort: {
        id:   "bedrock/global.anthropic.claude-opus-5"
        name: "Claude Opus 5.0"
        provider: "litellm"
    }
    midEffort: {
        id:   "bedrock/us.anthropic.claude-sonnet-4-6"
        name: "Claude sonnet 4.6"
        provider: "litellm"
    }
    lowEffort: {
        id:   "bedrock/zai.glm-5"
        name: "GLM 5"
        provider: "litellm"
    }
}

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
            for _, model in _modelDefs {
                (model.id): {
                    name: model.name
                }
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

plugin: ["context-mode"]
