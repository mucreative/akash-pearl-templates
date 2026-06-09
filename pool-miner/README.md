# Akash Pearl Pool Miner Template

This template runs the AlphaPool Pearl miner on an Akash GPU provider.

Default pool:

```text
sg1.alphapool.tech:5566
```

## Files

- `Dockerfile` builds a small CUDA runtime image and downloads `alpha-miner`.
- `entrypoint.sh` validates environment variables and starts the miner.
- `deploy.yaml` is the Akash SDL template.
- `env.example` lists the variables to fill in.

## Build Image

From the repository root:

```bash
docker build -f deploy/akash/templates/pool-miner/Dockerfile \
  -t ghcr.io/YOUR_GITHUB_USER/pearl-pool-miner-akash:latest .

docker push ghcr.io/YOUR_GITHUB_USER/pearl-pool-miner-akash:latest
```

## Configure SDL

Edit `deploy/akash/templates/pool-miner/deploy.yaml`:

- Replace `image` with your pushed image.
- Replace `PEARL_ADDRESS`.
- Adjust `PEARL_WORKER`.
- Keep `PEARL_POOL_HOST=sg1.alphapool.tech` if your provider is close to Asia.
- Adjust `pricing.amount` until you get bids.
- Keep `model: h100` unless you have confirmed the miner supports another GPU.

Do not commit a real wallet address if you want to keep it private.

## Deploy

Use Akash Console or Akash CLI with `deploy.yaml`.

Healthy logs should show:

```text
Pearl pool miner starting
Pool: sg1.alphapool.tech:5566
Health endpoint listening on port 8080
Detected GPU:
Starting alpha-miner
```

Then verify worker status and accepted shares from the pool dashboard.
