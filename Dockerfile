FROM n8nio/n8n:latest
USER root
RUN apk add --update python3 py3-pip
# installs requests library
RUN python3 -m pip install requests
RUN python3 -m pip install gradio_client
# upgrades pip (not necessary)
RUN python3 -m pip install --upgrade pip
USER node
