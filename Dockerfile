FROM n8nio/n8n:latest
USER root
RUN apk add --no-cache --virtual .build-deps make gcc g++ python3 
RUN npm install -g \
    langfuse@3.18.0 \
    langfuse-langchain@3.18.0

RUN npm install --production --silent -g @gradio/client 
RUN apk del .build-deps
USER node