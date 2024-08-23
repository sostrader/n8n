FROM n8nio/n8n:latest
USER root
RUN apk add --update build-base python3
RUN npm install -g \
    langfuse@3.18.0 \
    langfuse-langchain@3.18.0 
RUN npm install -g \
    @gradio/client@1.5.0
USER node