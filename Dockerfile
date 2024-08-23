FROM naskio/n8n-python:latest-debian
USER root

RUN npm install -g \
    langfuse@3.18.0 \
    langfuse-langchain@3.18.0

RUN cd /usr/local/lib/node_modules/n8n && npm install @gradio/client

USER node