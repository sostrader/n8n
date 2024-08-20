FROM n8nio/n8n:latest
USER root
RUN apk add --update python3 py3-pip make npm
RUN cd /usr/local/lib/node_modules/n8n && npm @gradio/client
USER node
ENTRYPOINT [“docker-entrypoint.sh”]