FROM n8nio/n8n:latest
USER root
RUN apk add --update python3 py3-pip
RUN npm install -g \
    langfuse@3.18.0 \
    langfuse-langchain@3.18.0 
RUN npm install -g \
    @gradio/client@1.5.0
USER node