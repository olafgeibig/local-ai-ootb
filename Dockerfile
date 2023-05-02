ARG GO_VERSION=1.20
ARG DEBIAN_VERSION=11
ARG BUILD_TYPE=Release

FROM golang:$GO_VERSION as builder
RUN git clone https://github.com/go-skynet/LocalAI.git --depth=1 /build
RUN apt-get update && apt-get install -y cmake

WORKDIR /build
RUN make build

FROM debian:$DEBIAN_VERSION
RUN apt-get update && apt-get install -y python3 curl

COPY --from=builder /build/local-ai /usr/bin/local-ai

COPY download_models.py .
COPY create_config.py .
COPY run.sh .
RUN chmod +x run.sh

# We're not using ENTRYPOINT but CMD since it allows for
# easiert debugging on runpod.ai
EXPOSE 8080
CMD ["/bin/sh", "-c", "./run.sh \"$@\"", "--"]
