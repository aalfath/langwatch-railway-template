# ClickHouse for LangWatch: LangWatch's own auto-tuning build (clickhouse-serverless),
# pinned by version and digest. Stores traces, spans, evaluations and analytics.
FROM langwatch/clickhouse-serverless:0.5.0@sha256:1e6174ac0b7bd4cdaf45d4bbcb783c755808d48a6824c02f7511b5ec5f4d07f5
# Size ClickHouse for a small Railway service (upstream compose limits: 1 CPU, 2 GB)
# rather than the whole host. Override CH_CPU and CH_RAM as variables to grow it.
ENV CH_CPU=1 \
    CH_RAM=2Gi
# Railway mounts volumes owned by root: start as root, hand the volume to the
# clickhouse user (uid 101) and drop to it before the server starts.
USER 0:0
COPY --chmod=755 railway-start.sh /railway-start.sh
ENTRYPOINT ["/railway-start.sh"]
CMD ["clickhouse-server"]
