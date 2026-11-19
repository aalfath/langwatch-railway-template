# Changelog

## 3.25.0 (2026-11-19)

First release of the template.

- LangWatch 3.25.0: `langwatch/langwatch`, `langwatch/langwatch_nlp` and `langwatch/langevals` pinned by digest.
- ClickHouse: `langwatch/clickhouse-serverless:0.5.0` (ClickHouse 26.8.36.3) on a volume, tuned for 1 CPU and 2 GB.
- Railway Postgres, Redis and a Railway Bucket for stored objects and datasets.
- `RAILWAY_HEALTHCHECK_TIMEOUT_SEC=1200` on LangWatch and Workers, so the first install finishes before the health check gives up.
- Sign-up is `invite_only`; the deployer's `ADMIN_EMAILS` is the only address that can create the first account.
