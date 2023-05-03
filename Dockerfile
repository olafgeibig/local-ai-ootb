ARG GO_VERSION=1.20
ARG DEBIAN_VERSION=11
ARG COMMIT_SHA=HEAD
ARG BUILD_TYPE=
# ------------------------------ build stage -----------------------------
FROM golang:$GO_VERSION as builder
# reuse global ARG
ARG COMMIT_SHA
RUN git clone https://github.com/go-skynet/LocalAI.git /build \
    && cd /build \
    && git checkout $COMMIT_SHA
RUN apt-get update && apt-get install -y cmake

# reuse global ARG
ARG BUILD_TYPE
WORKDIR /build
RUN make build BUILD_TYPE=$BUILD_TYPE

# ------------------------------ run stage -----------------------------
FROM debian:${DEBIAN_VERSION}
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
