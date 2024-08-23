ARG NODE_VERSION=22

# 1. Create an image to build n8n
FROM --platform=linux/amd64 n8nio/base:${NODE_VERSION} AS builder

# Build the application from source
WORKDIR /src
COPY . /src
RUN apk add --update make gcc g++ python3
ENV NODE_TLS_REJECT_UNAUTHORIZED=0
RUN --mount=type=cache,id=pnpm-store,target=/root/.local/share/pnpm/store --mount=type=cache,id=pnpm-metadata,target=/root/.cache/pnpm/metadata pnpm install --frozen-lockfile
RUN pnpm build

# Install @gradio/client and langfuse
RUN pnpm install --frozen-lockfile @gradio/client langfuse@3.18.0 langfuse-langchain@3.18.0

# Delete all dev dependencies
RUN jq 'del(.pnpm.patchedDependencies)' package.json > package.json.tmp; mv package.json.tmp package.json
RUN node .github/scripts/trim-fe-packageJson.js

# Delete any source code, source-mapping, or typings
RUN find . -type f -name "*.ts" -o -name "*.js.map" -o -name "*.vue" -o -name "tsconfig.json" -o -name "*.tsbuildinfo" | xargs rm -rf

# Deploy the `n8n` package into /compiled
RUN mkdir /compiled
RUN NODE_ENV=production pnpm --filter=n8n --prod --no-optional deploy /compiled

# 2. Start with a new clean image with just the code that is needed to run n8n
FROM n8nio/base:${NODE_VERSION}
ENV NODE_ENV=production

ARG N8N_RELEASE_TYPE=dev
ENV N8N_RELEASE_TYPE=${N8N_RELEASE_TYPE}

WORKDIR /home/node
COPY --from=builder /compiled /usr/local/lib/node_modules/n8n
COPY docker-entrypoint.sh /

RUN \
    cd /usr/local/lib/node_modules/n8n && \
    npm rebuild sqlite3 && \
    cd - && \
    ln -s /usr/local/lib/node_modules/n8n/bin/n8n /usr/local/bin/n8n && \
    mkdir .n8n && \
    chown node:node .n8n

ENV SHELL /bin/sh
USER node
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]