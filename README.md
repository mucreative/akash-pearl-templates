# Akash Templates

Templates in this directory are meant to be copied or edited before deployment.

## `pool-miner`

Use this first. It runs AlphaPool's Pearl miner directly against a pool.

Pros:

- No `pearld` full node required.
- No `pearl-gateway` required.
- No Tailscale required.
- Easier to monitor via pool dashboard.

## `vllm-miner-remote-node`

Advanced mode. Use a container running `pearl-gateway + vllm-miner` against a
remote VPS `pearld` full node. This path needs more moving parts and an SM90 GPU
such as H100/H200.
