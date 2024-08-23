FROM n8nio/n8n:latest
USER root
RUN apk add --no-cache --virtual .build-deps alpine-sdk python3 
RUN npm install -g \
    langfuse@3.18.0 \
    langfuse-langchain@3.18.0 \
    @gradio/client

RUN apk del .build-deps   
USER node