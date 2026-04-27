# <img src="favicon.svg" alt="census" height="24"> census

Uptime monitoring for **[rguixaro.dev](https://rguixaro.dev)** applications. Live
status at **[census.rguixaro.dev](https://census.rguixaro.dev)**. Built on
[Gatus](https://github.com/TwiN/gatus).

## What's monitored

| App       | Codename    | URL                                              |
| --------- | ----------- | ------------------------------------------------ |
| Cookbook  | receptarium | `https://cookbook.rguixaro.dev/api/health`       |
| Roots     | atrium      | `https://roots.rguixaro.dev/api/health`          |
| Rask      | itinerarium | `https://rask.rguixaro.dev/api/health`           |
| Portfolio | tabularium  | `https://portfolio.rguixaro.dev/api/health.json` |

Each endpoint is polled every 60 seconds. An endpoint is considered healthy when it
returns `200` within 5 seconds.

## Deployment

Any change to `config.yaml` requires a redeploy via `fly deploy`
