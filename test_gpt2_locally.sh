#!/bin/bash

# builds and runs local-ai-ootb locally with gpt2, inderences via curl
# expects ggml-model-gpt-2-117M.bin to be located in subdir models/

tag=${1:-local}
commit_sha=${2:-$(curl --silent https://api.github.com/repos/go-skynet/LocalAI/branches/master | jq -r '.commit.sha')}

echo "using/building local-ai-ootb:$tag, based on commit $commit_sha"

if [[ $tag == "local" ]]; then    
    docker build --progress=plain --build-arg COMMIT_SHA=$commit_sha -t theveryomni/local-ai-ootb:local  .
else
    docker pull theveryomni/local-ai-ootb:$tag
fi

# start local fileserver in models
python3 -m http.server 8081 --directory models/ &
server_pid=$!

host_ip=$(ifconfig | grep -A 1 $(netstat -nr | grep '^0\.0\.0\.0' | awk '{print $NF}') | grep 'inet ' | awk '{print $2}')

dl_config="{
    \"models\": [
        {
            \"url\": \"http://$host_ip:8081/ggml-model-gpt-2-117M.bin\",
            \"name\": \"ggml-gpt2-117M\"
        }
    ],
    \"templates\": [
        {
            \"name\": \"ggml-gpt2-117M\",
            \"content\": \"The prompt below is a question to answer, a task to complete, or a conversation to respond to; decide which and write an appropriate response.\\n### Prompt:\\n{{.Input}}\\n### Response:\\n\"
        }
    ]
}"

echo "docker run --name local-ai-ootb -p 8080:8080  \
           -e MODEL_CONFIG="$(cat example_configs/ggml-gpt2-117M.json)" \
           -e MODEL_SETUP_CONFIG="$dl_config" \
           -e DEBUG=true theveryomni/local-ai-ootb:$tag  "           
docker run --name local-ai-ootb -p 8080:8080  \
           -e MODEL_CONFIG="$(cat example_configs/ggml-gpt2-117M.json)" \
           -e MODEL_SETUP_CONFIG="$dl_config" \
           -e DEBUG=true theveryomni/local-ai-ootb:$tag  &

# give container time to startup, download model from local http server
sleep 5

curl http://localhost:8080/v1/chat/completions "Content-Type: application/json" -d '{ 
      "model": "ggml-gpt2-117M",
      "messages": [{"role": "user", "content": "Hello world!"}],
      "temperature": 0.9 
    }'
statuscode=$?

kill $server_pid
docker container rm -f local-ai-ootb

exit $statuscode