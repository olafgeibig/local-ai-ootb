# local-ai-ootb

This project builds a dockerfile to run local-ai as a backend on e.g. runpod.ai

Sources of local-ai can be found at https://github.com/go-skynet/LocalAI

You can configure the behavior using environment variables:

MODEL_DOWNLOAD_CONFIG   json content describing which ggml models to download during startup.
                        Here's an example. You can find more examples in `example_dl_configs`

                        [
                            {
                                "url": "https://gpt4all.io/models/ggml-gpt4all-j.bin",
                                "name": "ggml-gpt4all-j",
                                "template": "The prompt below is a question to answer, a task to complete, or a conversation to respond to; decide which and write an appropriate response.\n### Prompt:\n{{.Input}}\n### Response:\n"
                            }
                        ]

                        Newlines in the template string must be encoded as `\n`.

THREADS                 number of threads to use for inference. The models seem to not be too
                        parallelizable, I have never seen more than 15 threads in action.
CONTEXT_SIZE            maximum number of tokens to create in the output
MODEL_CONFIG            json content for model config file. You can finde examples at 
                        https://github.com/go-skynet/LocalAI

                        Here's an example:

                        

