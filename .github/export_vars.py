import json
import os

# Load configuration from JSON
with open("./.github/build_vars.json", "r") as f:
    config = json.load(f)

# Get the GITHUB_ENV path from the environment;
# This is the file where GitHub Actions reads env var exports.
github_env = os.getenv("GITHUB_ENV")
if github_env:
    with open(github_env, "a") as env_file:
        # Write our variables to the file
        env_file.write(f"GAME_NAME={config.get('game_name', 'Game')}\n")
        env_file.write(f"GAME_VERSION={config.get('version', '0.0.1')}\n")
else:
    print("GITHUB_ENV variable is not set.")
