"""Print active global Bedrock inference profiles as an OpenCode model list.

Use this whenever you want to update the full list of models in the Cue config files.
"""

import dataclasses
import json
import subprocess
import sys
import urllib.error
import urllib.request
from typing import Any, Final

REGION: Final = "us-east-1"
PROVIDER: Final = "litellm"
BANNED_MODEL_MARKERS: Final = ("fable", "pegasus", "embed")
MODEL_CATALOG_URL: Final = "https://models.dev/api.json"


def recursive_loads(data: Any) -> Any:
    """Recursively parse strings containing JSON within a parsed JSON structure.

    Args:
        data: A value that may be a string, dict, list, or scalar.

    Returns:
        The same structure with every JSON-encoded string replaced by its
        parsed value. Strings that are not valid JSON are left unchanged.
    """
    if isinstance(data, str):
        try:
            return recursive_loads(json.loads(data))
        except (json.JSONDecodeError, TypeError):
            return data
    if isinstance(data, dict):
        return {key: recursive_loads(value) for key, value in data.items()}
    if isinstance(data, list):
        return [recursive_loads(item) for item in data]
    return data


@dataclasses.dataclass(frozen=True, match_args=False)
class InferenceProfile:
    inferenceProfileName: str
    inferenceProfileId: str
    status: str

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> "InferenceProfile":
        """Build a profile from a dict, ignoring keys that are not fields."""
        field_names = {field.name for field in dataclasses.fields(cls)}
        return cls(**{k: v for k, v in data.items() if k in field_names})

    @property
    def is_active_global(self) -> bool:
        return self.inferenceProfileId.startswith("global") and self.status == "ACTIVE"

    @property
    def is_llm(self) -> bool:
        return not any(
            marker in self.inferenceProfileId for marker in BANNED_MODEL_MARKERS
        )


def list_inference_profiles() -> list[InferenceProfile]:
    """Fetch all inference profiles from AWS Bedrock."""
    result = subprocess.run(
        ["aws", "bedrock", "list-inference-profiles", "--region", REGION],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        raise SystemExit(
            f"aws exited with status {result.returncode}:\n{result.stderr.strip()}"
        )
    summaries = json.loads(result.stdout)["inferenceProfileSummaries"]
    return [InferenceProfile.from_dict(s) for s in recursive_loads(summaries)]


def load_model_limits() -> dict[str, dict[str, int]]:
    """Fetch exact Bedrock model limits from OpenCode's model catalog."""
    # The catalog rejects urllib's default User-Agent with HTTP 403.
    request = urllib.request.Request(
        MODEL_CATALOG_URL,
        headers={
            "User-Agent": "opencode-model-generator/1.0",
            "Accept": "application/json",
        },
    )
    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            catalog = json.load(response)
    except urllib.error.URLError as error:
        raise SystemExit(
            f"Could not fetch model limits from {MODEL_CATALOG_URL}: {error}"
        ) from error
    return {
        model_id: model["limit"]
        for model_id, model in catalog["amazon-bedrock"]["models"].items()
        if "limit" in model
    }


def build_models(
    profiles: list[InferenceProfile], limits: dict[str, dict[str, int]]
) -> list[dict[str, Any]]:
    """Build model entries, warning rather than guessing unknown limits."""
    models = [
        {
            "id": f"bedrock/{profile.inferenceProfileId}",
            "name": profile.inferenceProfileName,
            "provider": PROVIDER,
        }
        for profile in profiles
        if profile.is_active_global and profile.is_llm
    ]
    for model in models:
        profile_id = model["id"].removeprefix("bedrock/")
        if profile_id in limits:
            model["limit"] = limits[profile_id]
        else:
            print(f"Warning: no catalog limits for {profile_id}", file=sys.stderr)
    return models


def main() -> None:
    """Print profiles with catalog limits as JSON suitable for the CUE list."""
    models = build_models(list_inference_profiles(), load_model_limits())
    print(json.dumps(models, indent=4, sort_keys=True))


if __name__ == "__main__":
    main()
