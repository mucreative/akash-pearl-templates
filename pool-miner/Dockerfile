FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl netcat-openbsd procps && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L -o /usr/local/bin/alpha-miner https://pearl.alphapool.tech/downloads/alpha-miner && \
    chmod +x /usr/local/bin/alpha-miner

COPY pool-miner/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENV PYTHONUNBUFFERED=1

ENTRYPOINT ["/app/entrypoint.sh"]
