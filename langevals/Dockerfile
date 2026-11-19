# LangEvals: LangWatch's built-in evaluators and guardrails. Official image, pinned by
# version and digest. Listens on PORT (5562 in the template).
FROM langwatch/langevals:3.25.0@sha256:2ee69343d6a6e6600bb446b4ba18957d6b4325d2202ef0e70736a820958184bf
# Load evaluator models on first use instead of at boot, and run one gunicorn worker
# (each one is about 1 GB). Raise CPU_COUNT on a bigger service.
ENV DISABLE_EVALUATORS_PRELOAD=true \
    CPU_COUNT=1
