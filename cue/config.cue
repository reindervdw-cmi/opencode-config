package opencode

import (
	interactive "opencode.local/config/cue/interactive@v0"
	egm "opencode.local/config/cue/egm@v0"
	scout "opencode.local/config/cue/scout@v0"
	review "opencode.local/config/cue/review@v0"
	court "opencode.local/config/cue/court@v0"
)

"$schema": "https://opencode.ai/config.json"

agents: interactive.Agents & egm.Agents & scout.Agents & review.Agents & court.Agents

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
		name:    "LiteLLM"
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
	}
	azureapim: {
		name: "Azure APIM"
		package: "aisdk:@ai-sdk/openai-compatible"
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
