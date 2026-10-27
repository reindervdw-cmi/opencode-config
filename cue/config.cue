package opencode

"$schema": "https://opencode.ai/config.json"

_models: [
    {
        "id": "bedrock/global.amazon.nova-2-lite-v1:0",
        "limit": {
            "context": 1000000,
            "output": 65535
        },
        "name": "GLOBAL Amazon Nova 2 Lite",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-sonnet-4-5-20250929-v1:0",
        "limit": {
            "context": 200000,
            "output": 64000
        },
        "name": "Global Claude Sonnet 4.5",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-opus-4-5-20251101-v1:0",
        "limit": {
            "context": 200000,
            "output": 64000
        },
        "name": "GLOBAL Anthropic Claude Opus 4.5",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.openai.gpt-5.6-sol",
        "limit": {
            "context": 1050000,
            "input": 922000,
            "output": 128000
        },
        "name": "Global OpenAI GPT-5.6 Sol",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.xai.grok-4.6",
        "limit": {
            "context": 500000,
            "output": 500000
        },
        "name": "Global xAI Grok 4.6",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-haiku-4-5-20251001-v1:0",
        "limit": {
            "context": 200000,
            "output": 64000
        },
        "name": "Global Anthropic Claude Haiku 4.5",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.openai.gpt-6-sol",
        "limit": {
            "context": 1050000,
            "input": 922000,
            "output": 128000
        },
        "name": "Global OpenAI GPT-6 Sol",
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
        "limit": {
            "context": 1000000,
            "output": 128000
        },
        "name": "Global Anthropic Claude Opus 5",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-opus-4-8",
        "limit": {
            "context": 1000000,
            "output": 128000
        },
        "name": "Global Anthropic Claude Opus 4.8",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-sonnet-5",
        "limit": {
            "context": 1000000,
            "output": 128000
        },
        "name": "Global Anthropic Claude Sonnet 5",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-opus-4-7",
        "limit": {
            "context": 1000000,
            "output": 128000
        },
        "name": "Global Anthropic Claude Opus 4.7",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.xai.grok-4.7",
        "limit": {
            "context": 500000,
            "output": 500000
        },
        "name": "Global xAI Grok 4.7",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.openai.gpt-6-astra",
        "limit": {
            "context": 1050000,
            "input": 922000,
            "output": 128000
        },
        "name": "Global OpenAI GPT-6 Astra",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.openai.gpt-6.1-sol",
        "limit": {
            "context": 1050000,
            "input": 922000,
            "output": 128000
        },
        "name": "Global OpenAI GPT-6.1 Sol",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.zai.glm-5.3",
        "limit": {
            "context": 1000000,
            "output": 128000
        },
        "name": "Global Z.AI GLM 5.3",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.moonshotai.kimi-k3",
        "limit": {
            "context": 1048576,
            "output": 128000
        },
        "name": "Global Moonshot AI Kimi K3",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-haiku-5-5",
        "limit": {
            "context": 1000000,
            "output": 128000
        },
        "name": "Global Anthropic Claude Haiku 5.5",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-sonnet-5-5",
        "limit": {
            "context": 1000000,
            "output": 128000
        },
        "name": "Global Anthropic Claude Sonnet 5.5",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-sonnet-4-6",
        "limit": {
            "context": 1000000,
            "output": 128000
        },
        "name": "Global Anthropic Claude Sonnet 4.6",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-opus-4-6-v1",
        "limit": {
            "context": 1000000,
            "output": 128000
        },
        "name": "Global Anthropic Claude Opus 4.6",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.openai.gpt-5.6-luna",
        "limit": {
            "context": 1050000,
            "input": 922000,
            "output": 128000
        },
        "name": "Global OpenAI GPT-5.6 Luna",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.openai.gpt-6-luna",
        "limit": {
            "context": 1050000,
            "input": 922000,
            "output": 128000
        },
        "name": "Global OpenAI GPT-6 Luna",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.openai.gpt-6.1-terra",
        "name": "Global OpenAI GPT-6.1 Terra",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.anthropic.claude-opus-5-5",
        "limit": {
            "context": 1000000,
            "output": 128000
        },
        "name": "Global Anthropic Claude Opus 5.5",
        "provider": "litellm"
    },
    {
        "id": "bedrock/global.openai.gpt-5.6-terra",
        "limit": {
            "context": 1050000,
            "input": 922000,
            "output": 128000
        },
        "name": "Global OpenAI GPT-5.6 Terra",
        "provider": "litellm"
    }
]

_apim_models: [{
        "id": "gpt-5.5",
        "name": "Azure APIM GPT 5.5",
        "provider": "azureapim"
}]


_modelDefs: {
    highEffort: {
        id:   "bedrock/global.openai.gpt-6.1-sol"
        provider: "litellm"
    }
    midEffort: {
        id:   "bedrock/global.openai.gpt-6.1-terra"
        provider: "litellm"
    }
    lowEffort: {
        id:   "bedrock/global.openai.gpt-6-luna"
        provider: "litellm"
    }
}

share: "disabled"

policies: [
	{action: "provider.use", resource: "*", effect: "deny"},
	{action: "provider.use", resource: "litellm", effect: "allow"},
	{action: "provider.use", resource: "azureapim", effect: "allow"},
]
permissions: [
	{action: "webfetch", resource: "*", effect: "deny"},
]
experimental: {
	subagent_depth: 5
}

providers: {
	litellm: {
		package: "aisdk:@ai-sdk/openai-compatible"
		name: "LiteLLM"
		settings: {
			baseURL: "https://litellm-prod-litellm.wonderfulriver-dd795f9a.eastus.azurecontainerapps.io/"
		}
		models: {
            for _, model in _models {
                (model.id): {
                    name: model.name
                    if model.limit != _|_ {
                        limit: model.limit
                    }
                }
            }
	}
	},
	azureapim: {
		package: "@opencode-ai/ai/providers/openai-compatible"
		name: "Azure APIM"
		settings: {
            baseURL: "https://cmi-apim-01.azure-api.net/CMI-APIM/openai"
		}
		models: {
            for _, model in _apim_models {
                (model.id): {
                    name: model.name
                }
            }
	}
	}
}
