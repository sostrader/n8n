# Etapa de construção
FROM --platform=linux/amd64 n8nio/n8n:latest AS builder

USER root

# Instala as dependências necessárias para a construção
RUN apk add --no-cache make gcc g++ python3


WORKDIR /usr/local/lib/node_modules


RUN npm install @gradio/client langfuse@3.18.0 langfuse-langchain@3.18.0 duckduckgo-ai-chat duck-duck-scrape

# Imagem final
FROM n8nio/n8n:latest

USER root

# Copia as dependências globais instaladas da etapa de construção
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules
# Instala as dependências do Gradio e Langfuse globalmente


USER node
