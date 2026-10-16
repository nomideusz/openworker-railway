FROM alpine/git:v2.49.1 AS src
ARG OPENWORKER_VERSION=v0.3.1
RUN git clone --depth 1 --branch ${OPENWORKER_VERSION} https://github.com/andrewyng/openworker /src

FROM node:22-slim AS gui
COPY --from=src /src/surfaces/gui /gui
WORKDIR /gui
RUN npm ci --no-audit --no-fund && npx vite build \
 # The gateway fills in the per-boot API token when it serves index.html (Caddy templates).
 && sed -i 's|</head>|<script>window.__COWORKER_API_TOKEN__="{{env "COWORKER_API_TOKEN"}}";</script></head>|' dist/index.html

FROM caddy:2.10.2 AS caddy

FROM python:3.12-slim
RUN apt-get update && apt-get install -y --no-install-recommends git curl ca-certificates ripgrep openssh-client \
 && rm -rf /var/lib/apt/lists/*
COPY --from=src /src /opt/openworker
RUN pip install --no-cache-dir "/opt/openworker[messaging]"
COPY --from=gui /gui/dist /srv/gui
COPY --from=caddy /usr/bin/caddy /usr/local/bin/caddy
COPY Caddyfile /etc/caddy/Caddyfile
COPY railway-start /usr/local/bin/railway-start
ENV HOME=/data/home
CMD ["/usr/local/bin/railway-start"]
