FROM n8nio/n8n:latest-debian
USER root

RUN npm install -g \
    langfuse@3.18.0 \
    langfuse-langchain@3.18.0
USER node
RUN cd /home/node/.n8n/nodes && npm install @gradio/client