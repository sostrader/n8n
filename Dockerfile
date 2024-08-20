FROM n8nio/n8n:latest
USER root
RUN cd /usr/local/lib/node_modules/n8n && \
    npm install @gradio/client && \
    npm rebuild sqlite3 && \
    RUN npm install -g @gradio/client

USER node
