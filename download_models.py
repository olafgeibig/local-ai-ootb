"""
This script downloads one or more LLMs based on a json configuration provided in the
`MODEL_SETUP_CONFIG` environment variable, and saves them to the `/model` directory.

The configuration should be a JSON object or array containing one or more model download descriptions, each
with the following properties:
- `url` (required): The URL from which to download the model file.
- `name` (required): The filename to use for the downloaded model file, which will be saved in the `/model`
  directory.
- `template` (required): A string containing the content of a template file that should be saved to a file
  with the same name as the model file, but with a `.tmpl` extension.

If any model download fails, an error message and stacktrace will be printed, but the script will continue
with the next model download. If all model downloads complete successfully, a message will be printed to the
console indicating that the downloads have completed.

Example configuration:
{
  "url": "https://example.com/my-model.bin",
  "name": "my-model.bin",
  "template": "This is the template for my-model.bin"
}

To use this script in a Docker container, set the `MODEL_SETUP_CONFIG` environment variable to the stringified
JSON configuration, and call this script from the entrypoint or command of the container.
"""

import os
import json
import subprocess
import traceback
from pathlib import Path

if not Path("/models").exists():
    Path("/models").mkdir()

config_str = os.environ.get("MODEL_SETUP_CONFIG")
if not config_str:
    raise ValueError("MODEL_SETUP_CONFIG environment variable not set")

config = json.loads(config_str)

if not isinstance(config, list):
    config = [config]

successful = 0
for item in config:
    url = item.get("url")
    name = item.get("name")
    template = item.get("template")

    if not all([url, name, template]):
        raise ValueError("Invalid model configuration: missing url, name, or template")

    try:
        subprocess.check_call(["curl", "-L", url, "-o", f"/models/{name}"])
        with open(f"/models/{name}.tmpl", "w") as f:
            f.write(template.replace(r"\n", "\n"))
        successful += 1
    except Exception as e:
        print(f"Error downloading model {name} from {url}:")
        traceback.print_exc()

print(f"{successful}/{len(config)} model downloads completed successfully")
