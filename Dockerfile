# Etapa de construção
FROM --platform=linux/amd64 n8nio/n8n:latest AS builder

USER root

# Instala as dependências necessárias para a construção
RUN apk add --no-cache make gcc g++ python3




WORKDIR /usr/local/lib/node_modules

RUN npm install \
    langfuse@3.18.0 \
    langfuse-langchain@3.18.0 \
    duck-duck-scrape \
    duckduckgo-search-api \
    odoo-await \
    @mozilla/readability \
    arxiv-api \
    google-trends-api-code \
    archive-search \
    semanticscholarjs \
    selic \
    calculatorreadjustment \
    puppeteer \
    n8n-nodes-youtube-transcript
# Imagem final
FROM n8nio/n8n:latest
USER root


ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=false
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

RUN apk --update --no-cache --purge add libreoffice-common \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    su-exec

# Copia as dependências globais instaladas da etapa de construção
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules
# Instala as dependências do Gradio e Langfuse globalmente
USER node
