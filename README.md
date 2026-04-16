# census

Uptime monitoring for [rguixaro.dev](https://rguixaro.dev) apps. Live status at
**[census.rguixaro.dev](https://census.rguixaro.dev)**.

Built on [Gatus](https://github.com/TwiN/gatus), deployed to
[Fly.io](https://fly.io).

## What's monitored

| App      | Codename    | URL                                        |
| -------- | ----------- | ------------------------------------------ |
| Cookbook | Receptarium | `https://cookbook.rguixaro.dev/api/health` |
| Roots    | Atrium      | `https://roots.rguixaro.dev/api/health`    |
| Rask     | Itinerarium | `https://rask.rguixaro.dev/api/health`     |

Each endpoint is polled every 60 seconds. An endpoint is considered healthy when it
returns `200` within 5 seconds.

## Layout

```
.
├── Dockerfile      # Gatus binary + Caddy front, baked-in config
├── Caddyfile       # Caddy reverse-proxy + favicon override
├── start.sh        # Launches Gatus on :8081 and Caddy on :8080
├── config.yaml     # Endpoint definitions, storage, UI
├── favicon.svg     # Browser-tab icon served by Caddy
├── fly.toml        # Fly app + VM + volume definition
└── README.md
```

Caddy sits in front of Gatus purely to override `/favicon.svg` (Gatus's favicon is
baked into the binary). Everything else is proxied transparently to Gatus on :8081.

## Deploying changes

Any change to `config.yaml` (e.g. adding an endpoint, tweaking conditions) requires a
redeploy:

```bash
fly deploy
```

Zero-downtime, ~60 seconds.

## Adding an endpoint

Append to `endpoints:` in [config.yaml](config.yaml):

```yaml
- name: My New App
  group: rguixaro.dev
  url: https://example.rguixaro.dev/api/health
  interval: 60s
  conditions:
      - '[STATUS] == 200'
      - '[RESPONSE_TIME] < 5000'
```

Then `fly deploy`.

## Alerts

Not yet wired up. When added, webhook URLs will live in Fly secrets, not this repo:

```bash
fly secrets set DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/..."
```

Referenced in `config.yaml` as `${DISCORD_WEBHOOK_URL}`.

## Operations

```bash
fly status              # current machine state
fly logs                # live log stream
fly ssh console         # shell into the running container
fly volumes list        # persistent volumes (SQLite DB lives in gatus_data)
fly certs show census.rguixaro.dev   # TLS cert status
```
