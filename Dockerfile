FROM n8nio/n8n:latest
USER root
RUN apk add --no-cache --virtual .build-deps make gcc g++ python3 \
    && npm install node-gyp -g && npm install node-gyp-build -g && cd /usr/local/lib/node_modules/n8n && npm install @gradio/client  

RUN npm install -g \
    langfuse@3.18.0 \
    langfuse-langchain@3.18.0

RUN apk del .build-deps
USER node