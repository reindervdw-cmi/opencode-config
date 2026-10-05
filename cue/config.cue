package opencode

"$schema": "https://opencode.ai/config.json"

_models: [
    {
        "id": "bedrock/global.amazon.nova-2-lite-v1:0",
        "name": "GLOBAL Amazon Nova 2 Lite",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-sonnet-4-20250514-v1:0",
        "name": "Global Claude Sonnet 4",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-sonnet-4-5-20250929-v1:0",
        "name": "Global Claude Sonnet 4.5",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-opus-4-5-20251101-v1:0",
        "name": "GLOBAL Anthropic Claude Opus 4.5",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.openai.gpt-5.6-terra",
        "name": "Global OpenAI GPT-5.6 Terra",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.openai.gpt-5.6-luna",
        "name": "Global OpenAI GPT-5.6 Luna",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.openai.gpt-5.6-sol",
        "name": "Global OpenAI GPT-5.6 Sol",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.xai.grok-4.6",
        "name": "Global xAI Grok 4.6",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-haiku-4-5-20251001-v1:0",
        "name": "Global Anthropic Claude Haiku 4.5",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-opus-4-6-v1",
        "name": "Global Anthropic Claude Opus 4.6",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-sonnet-4-6",
        "name": "Global Anthropic Claude Sonnet 4.6",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.moonshotai.kimi-k3",
        "name": "Global Moonshot AI Kimi K3",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.openai.gpt-6-sol",
        "name": "Global OpenAI GPT-6 Sol",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.openai.gpt-6-luna",
        "name": "Global OpenAI GPT-6 Luna",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-opus-5-5",
        "name": "Global Anthropic Claude Opus 5.5",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.openai.gpt-5.4",
        "name": "Global OpenAI GPT 5.4",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.openai.gpt-5.5",
        "name": "Global OpenAI GPT 5.5",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-opus-5",
        "name": "Global Anthropic Claude Opus 5",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-opus-4-8",
        "name": "Global Anthropic Claude Opus 4.8",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-sonnet-5",
        "name": "Global Anthropic Claude Sonnet 5",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-opus-4-7",
        "name": "Global Anthropic Claude Opus 4.7",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.xai.grok-4.7",
        "name": "Global xAI Grok 4.7",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.openai.gpt-6-astra",
        "name": "Global OpenAI GPT-6 Astra",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.openai.gpt-6.1-sol",
        "name": "Global OpenAI GPT-6.1 Sol",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-sonnet-5-5",
        "name": "Global Anthropic Claude Sonnet 5.5",
        "provider": "litellm"
    }
]


_modelDefs: {
    highEffort: {
        id:   "bedrock/global.anthropic.claude-opus-5-5"
        provider: "litellm"
    }
    midEffort: {
        id:   "bedrock/global.openai.gpt-6.1-sol"
        provider: "litellm"
    }
    lowEffort: {
        id:   "bedrock/global.openai.gpt-6-luna"
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
            for _, model in _models {
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

