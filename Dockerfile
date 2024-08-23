FROM n8nio/n8n:latest
USER root
RUN apk add make gcc g++ python3
ENV NODE_TLS_REJECT_UNAUTHORIZED=0
RUN npm install -g \
    langfuse@3.18.0 \
    langfuse-langchain@3.18.0 \
    @gradio/client 
USER node