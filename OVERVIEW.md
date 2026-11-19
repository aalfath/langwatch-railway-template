# Deploy and Host LangWatch on Railway

LangWatch is an open-source LLM observability, evaluation and agent-testing platform (Apache-2.0). It collects OpenTelemetry traces from your LLM apps and agents, shows cost, latency and quality per request, runs built-in and LLM-as-judge evaluations and guardrails, and lets you test agents with simulated scenarios, prompt management and the Optimization Studio.

## About Hosting LangWatch

LangWatch is a multi-service stack, and this template deploys all of it, wired together over Railway's private network: the LangWatch app (web UI, REST and OTLP API), the background workers, the NLP engine, the LangEvals evaluator service, ClickHouse for traces and analytics, PostgreSQL for users and projects, Redis for the job queue, and a Railway Bucket for uploaded files. Every secret is generated at deploy time and every database keeps its data on a volume. The workers run LangWatch's own database and ClickHouse upgrade on every start, so a fresh deploy and a version update both migrate themselves. The only thing you supply is the email address of the first administrator.

## Common Use Cases

* Trace and debug LLM apps and AI agents (OpenAI, Anthropic, LangChain, LangGraph, DSPy, Vercel AI SDK and any OpenTelemetry source) with cost and latency per call
* Run evaluations and guardrails (LLM-as-judge, RAG quality, PII and jailbreak checks) on live traffic and on datasets
* Test agents with simulated users before release, and manage and version prompts with your team

## Dependencies for LangWatch Hosting

* PostgreSQL, Redis and ClickHouse (all included, each on its own volume)
* S3-compatible object storage (included as a Railway Bucket)

### Deployment Dependencies

* LangWatch source and releases: https://github.com/langwatch/langwatch/releases (this template ships 3.25.0)
* Self-hosting docs: https://langwatch.ai/docs/self-hosting/overview
* Environment variables: https://langwatch.ai/docs/self-hosting/configuration/environment-variables
* Template source: https://github.com/aalfath/langwatch-railway-template

### Implementation Details

Services in this template:

| Service | What it does |
| --- | --- |
| LangWatch | Web UI, REST API, OTLP trace ingestion and sign-in (public, port 5560) |
| Workers | Event-sourcing pipeline, evaluations, scheduled jobs; runs the database and ClickHouse upgrade at every start |
| NLP | Go engine for Optimization Studio workflows and the prompt playground |
| LangEvals | Built-in evaluators and guardrails |
| ClickHouse | LangWatch's own ClickHouse build: traces, spans, evaluations, analytics (volume) |
| Postgres | Users, organizations, projects, prompts (volume) |
| Redis | Job queue and cache (volume) |
| Bucket | Railway Bucket for datasets and stored files, uploaded through LangWatch |

**After deploy:** set `ADMIN_EMAILS` on the deploy form to your own email. The first boot takes about 10 minutes: the images build, then the workers run LangWatch's first install (about 570 database and ClickHouse steps) while the app waits not-ready; `RAILWAY_HEALTHCHECK_TIMEOUT_SEC=1200` gives it room. When the LangWatch service is active, open the LangWatch URL, choose sign up and register with that address; you become the operator (the `/ops` pages). Sign-up is `invite_only`, so nobody else can create an account unless you invite them from the app. Create your organization and project, add a model provider key under Settings to use evaluations and the playground, and copy the project's API key into your SDK with `LANGWATCH_ENDPOINT` set to your Railway URL.

**Optional settings** (add on the LangWatch and Workers services): email delivery (`EMAIL_PROVIDER=smtp` with `SMTP_URL` and `EMAIL_DEFAULT_FROM`, or `SENDGRID_API_KEY`), `SIGN_UP_MODE=open` to let anyone sign up, and `DISABLE_USAGE_STATS=true` to stop LangWatch's daily anonymous usage report. A custom domain goes on the LangWatch service; `BASE_HOST`, `NEXTAUTH_URL` and `LANGWATCH_ENDPOINT` follow Railway's public domain variable.

**Sizing:** LangEvals runs one worker (`CPU_COUNT=1`) and ClickHouse is tuned for 1 CPU and 2 GB (`CH_CPU`, `CH_RAM`). Raise those variables if you give the services more resources. The AI Gateway and the Langy assistant (optional add-ons upstream) are not included.

**Updates:** every service builds from the template's GitHub repo, with each image pinned by version and digest. When the repo moves to a new LangWatch release, Railway shows an update in your project; apply it, and the workers migrate the databases before the app reports ready. Read the repo's CHANGELOG first. Keep `CREDENTIALS_SECRET` unchanged: a new value makes stored provider keys unreadable.

## Why Deploy LangWatch on Railway?

<!-- Recommended: Keep this section as shown below -->
Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying LangWatch on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
<!-- End recommended section -->
