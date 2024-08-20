FROM n8nio/n8n:latest
USER root
RUN apk add --update python3 py3-pip make npm
RUN cd /usr/local/lib/node_modules/n8n && npm install @gradio/client
RUN npm install -g @gradio/client
RUN npm rebuild --prefix=/usr/local/lib/node_modules/n8n 
USER node
