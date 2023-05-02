#!/bin/sh

set -e

echo "Downloading model(s)"
python3 download_models.py

echo "Creating config file"
python3 create_config.py

echo "Running local-ai on port 8080 ..."
export MODELS_PATH=/models

# Run it in a loop so we can update the config
# and simply kill the local-ai process
while true; do
    /usr/bin/local-ai --config-file /etc/config.yml 1>&2 | tee --append /var/log/localai

    # If the process was killed, sleep for a moment before restarting
    sleep 1
done
