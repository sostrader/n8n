FROM n8nio/n8n:latest
USER root
RUN npm install -g @gradio/client
RUN cd /usr/local/lib/node_modules/n8n && \
    npm install @gradio/client 
USER node
