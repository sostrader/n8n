# Etapa de construção
FROM --platform=linux/amd64 n8nio/n8n:1.68.0 AS builder

USER root

# Instala as dependências necessárias para a construção
RUN apk add --no-cache make gcc g++ python3
RUN apk --update --no-cache --purge add libreoffice-common

WORKDIR /usr/local/lib/node_modules


RUN npm install \
    langfuse@3.18.0 \
    langfuse-langchain@3.18.0 \
    duck-duck-scrape \
    odoo-await \
    @mozilla/readability \
    arxiv-api \
    google-trends-api-code \
    archive-search \
    semanticscholarjs \
    n8n-nodes-pdf-to-imgs \
    n8n-nodes-pdfkit \
    n8n-nodes-carbonejs \
    selic \
    calculatorreadjustment

# Imagem final
FROM n8nio/n8n:1.73.1
USER root
RUN apk --update --no-cache --purge add libreoffice-common
# Copia as dependências globais instaladas da etapa de construção
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules
# Instala as dependências do Gradio e Langfuse globalmente


USER node
