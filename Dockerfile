FROM quay.io/go-skynet/local-ai:latest

WORKDIR /

COPY download_models.py .
COPY run.sh .
RUN chmod +x run.sh
ENTRYPOINT ["/bin/sh", "-c", "./run.sh \"$@\"", "--"]
