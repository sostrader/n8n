FROM n8nio/n8n:latest-debian
USER root
RUN cd /usr/lib/node_modules/n8n && npm install @gradio/client
RUN npm install -g \
    langfuse@3.18.0 \
    langfuse-langchain@3.18.0
USER node