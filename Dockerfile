# Etapa de construção
FROM --platform=linux/amd64 n8nio/n8n:latest AS builder

USER root

# Instala as dependências necessárias
RUN apk add --no-cache make gcc g++ python3

# Define o diretório de trabalho
WORKDIR /usr/local/lib/node_modules/n8n

# Instala as dependências do Gradio e Langfuse
RUN npm install @gradio/client@0.20.1 langfuse@3.18.0 langfuse-langchain@3.18.0

USER node

# Imagem final
FROM n8nio/n8n:latest

USER root

# Copia as dependências instaladas da etapa de construção
COPY --from=builder /usr/local/lib/node_modules/n8n /usr/local/lib/node_modules/n8n

USER node