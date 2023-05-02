# local-ai-ootb

This project builds a dockerfile to run local-ai as a backend on e.g. runpod.ai

Sources of local-ai can be found at https://github.com/go-skynet/LocalAI

There's a runpod template available: https://github.com/fHachenberg/local-ai-ootb

You can configure the behavior of the docker image using environment variables:

- `MODEL_DOWNLOAD_CONFIG` json content describing which ggml models to download during startup.
                          Here's an example. You can find more examples in `example_dl_configs`.
                          Newlines in the template string must be encoded as `\n`.

        {
            "models": [
                {
                    "url": "https://gpt4all.io/models/ggml-gpt4all-j.bin",
                    "name": "ggml-gpt4all-j"
                }
            ],
            "templates": [
                {
                    "name": "ggml-gpt4all-j",
                    "content": "The prompt below is a question to answer, a task to complete, or a conversation to respond to; decide which and write an appropriate response.\n### Prompt:\n{{.Input}}\n### Response:\n"
                }
            ]
        }

                          

- `MODEL_CONFIG` json content for model config file. You can finde yaml examples at 
                 https://github.com/go-skynet/LocalAI and json exampls in `example_configs`.
                 Here's an example of the json format for this config file:

        [
            {
                "name": "ggml-gpt4all-j",
                "parameters": {
                    "model": "ggml-gpt4all-j"
                },
                "context_size": 512,
                "threads": 52,
                "stopwords": [
                    "HUMAN:",
                    "### Response:"
                ],
                "roles": {
                    "user": "HUMAN:",
                    "system": "GPT:"
                },
                "template": {
                    "completion": "completion",
                    "chat": "ggml-gpt4all-j"
                }
            }
        ]
- `DEBUG false|true` activates additional debug messages during runtime of local-ai
