[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/langwatch?utm_medium=integration&utm_source=button&utm_campaign=langwatch)

# LangWatch on Railway

One-click Railway template for [LangWatch](https://github.com/langwatch/langwatch) **3.25.0**, the open-source LLM observability, evaluation and agent-testing platform (Apache-2.0). It deploys the full upstream stack as separate Railway services wired over the private network.

| Service | Folder | Image (pinned by version and digest) |
| --- | --- | --- |
| LangWatch (public) | `app/` | `langwatch/langwatch:3.25.0` |
| Workers | `workers/` | `langwatch/langwatch:3.25.0` |
| NLP | `nlp/` | `langwatch/langwatch_nlp:3.25.0` |
| LangEvals | `langevals/` | `langwatch/langevals:3.25.0` |
| ClickHouse | `clickhouse/` | `langwatch/clickhouse-serverless:0.5.0` (ClickHouse 26.8) |
| Postgres, Redis | - | Railway's own databases |
| Bucket | - | Railway Bucket (stored objects and datasets) |

Each folder holds a `Dockerfile` that starts `FROM` the official image and adds only a small start script:

- `app/railway-start.sh` and `workers/railway-start.sh` set the fixed defaults (`SIGN_UP_MODE=invite_only`, `STORED_OBJECTS_UPLOADS=through-langwatch`, trusted proxy ranges, no ClickHouse backup metrics) and start the api or the worker.
- `clickhouse/railway-start.sh` hands the Railway volume to the `clickhouse` user (uid 101) and drops to it before the server starts.

## Variables

The only prompt is `ADMIN_EMAILS`, the email of the first administrator; only that address (and people you invite) can sign up. Everything else is a reference or a generated secret:

- `NEXTAUTH_SECRET`, `CREDENTIALS_SECRET` (64 hex), `LANGWATCH_NLP_INTERNAL_SECRET`, `CLICKHOUSE_PASSWORD`: generated per deploy.
- `DATABASE_URL`, `REDIS_URL`, `CLICKHOUSE_URL`, `S3_*`, `LANGWATCH_NLP_SERVICE`, `LANGEVALS_ENDPOINT`: references to the other services.
- `BASE_HOST`, `NEXTAUTH_URL`, `LANGWATCH_ENDPOINT`: the LangWatch service's public domain.
- `RAILWAY_HEALTHCHECK_TIMEOUT_SEC=1200` on LangWatch and Workers: the first install runs about 570 upgrade steps before the app reports ready, longer than Railway's default 300 s health check window.

Optional settings (SMTP, `SIGN_UP_MODE=open`, `DISABLE_USAGE_STATS=true`) are described in the template overview, [`OVERVIEW.md`](OVERVIEW.md).

## How updates reach deployers

Every non-database service builds from this repo's `main` branch. A version bump here (new pins plus a `CHANGELOG.md` entry) makes Railway offer an update to everyone who deployed the template; they choose when to apply it. The workers run LangWatch's upgrade (Postgres and ClickHouse migrations) at start, and the app stays not-ready until it has finished. Read [`CHANGELOG.md`](CHANGELOG.md) before applying an update.
