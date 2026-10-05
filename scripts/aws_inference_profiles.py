"""Print active global Bedrock inference profiles as an OpenCode model list.

Use this whenever you want to update the full list of models in the Cue config files.
"""

import dataclasses
import json
import subprocess
from typing import Any

REGION = "us-east-1"
PROVIDER = "litellm"
BANNED_MODEL_MARKERS = ("fable", "pegasus", "embed")


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
        check=True,
    )
    summaries = json.loads(result.stdout)["inferenceProfileSummaries"]
    return [InferenceProfile.from_dict(s) for s in recursive_loads(summaries)]


def main() -> None:
    models = [
        {
            "id": f"bedrock/{profile.inferenceProfileId}",
            "name": profile.inferenceProfileName,
            "provider": PROVIDER,
        }
        for profile in list_inference_profiles()
        if profile.is_active_global and profile.is_llm
    ]
    print(json.dumps(models, indent=4, sort_keys=True))


if __name__ == "__main__":
    main()
