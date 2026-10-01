package opencode

"$schema": "https://opencode.ai/config.json"

_modelDefs: {
    highEffort: {
        id:   "bedrock/global.anthropic.claude-opus-5-5"
        name: "Opus 5.5"
        provider: "litellm"
    }
    midEffort: {
        id:   "bedrock/global.openai.gpt-6.1-sol"
        name: "GPT-6.1 Sol"
        provider: "litellm"
    }
    lowEffort: {
        id:   "bedrock/global.openai.gpt-6-luna"
        name: "GPT-6 Luna"
        provider: "litellm"
    }
}

share: "disabled"

enabled_providers: ["litellm"]
permission: {
    "webfetch": "deny"
}
subagent_depth: 2

provider: {
	litellm: {
		npm:  "@ai-sdk/openai-compatible"
		name: "LiteLLM"
		options: {
			baseURL: "https://litellm-prod-litellm.wonderfulriver-dd795f9a.eastus.azurecontainerapps.io/"
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

