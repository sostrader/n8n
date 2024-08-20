FROM n8nio/n8n:latest
RUN apk add --update --no-cache python3 curl
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools
RUN pip3 install --no-cache gradio_client